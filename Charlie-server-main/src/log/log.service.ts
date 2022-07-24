import { HttpStatus, Injectable } from '@nestjs/common';
import { PrismaService } from 'src/shared/services/prisma.service';
import { CreateLogDto } from './dto/create-log.dto';
import { Level } from '@prisma/client';
import { UpdateLogDto } from './dto/update-log.dto';
import { formatDateToMDY } from 'src/utils/formatter';

@Injectable()
export class LogService {
  constructor(private prisma: PrismaService) {}

  private goalReachThreshold = Number(process.env.STEPS_GOAL_REACH_THRESHOLD);
  private goalFailThreshold = Number(process.env.STEPS_GOAL_FAIL_THRESHOLD);

  async findAll(id: string): Promise<any> {
    const logs = await this.prisma.log.findMany({
      where: { userId: id },
      orderBy: { date: 'desc' },
      select: {
        date: true,
        steps: true,
      },
    });
    logs.map((l) => {
      l['dateStringified'] = formatDateToMDY(l.date);
      l['date'] = undefined;
    });
    return { status: HttpStatus.OK, data: { logs: logs } };
  }

  async update(id: string, logData: UpdateLogDto): Promise<any> {
    const initLevel = await this.getInitLevel(id, true);
    const currLog = await this.getLastLog(id);

    const newLevel =
      (await !this.isLevelUpdated(initLevel, currLog.level)) &&
      (await this.reachedGoal(logData.steps))
        ? await this.loseWeight(currLog.level)
        : currLog.level;
    const updatedLog = await this.prisma.log.update({
      where: { id: currLog.id },
      data: {
        steps: logData.steps,
        level: Level[newLevel],
      },
    });
    return { status: HttpStatus.OK, data: updatedLog };
  }

  async create(id: string, logData: CreateLogDto): Promise<any> {
    let level = await this.getInitLevel(id, false);
    if (await this.reachedGoal(logData.steps)) {
      level = await this.loseWeight(level);
    }
    const log = await this.prisma.log.create({
      data: {
        user: {
          connect: {
            id: id,
          },
        },
        steps: logData.steps,
        level: Level[level],
      },
    });
    return { status: HttpStatus.CREATED, data: log };
  }

  async logExists(id: string): Promise<any> {
    const res: boolean = (await this.getLogCount(id)) < 1 ? false : true;
    return { status: HttpStatus.OK, data: { res } };
  }

  async todayLogExists(id: string): Promise<boolean> {
    if ((await this.getLogCount(id)) < 1) {
      return false;
    }
    const lastLog = await this.getLastLog(id);
    // Stringify and format dates to YYYY-MM-DD, check if dates match
    const today = new Date(Date.now()).toISOString().slice(0, 10);
    const lastLogDate = lastLog.date.toISOString().slice(0, 10);
    if (today === lastLogDate) {
      return true;
    } else {
      return false;
    }
  }

  async reachedGoal(steps: number): Promise<boolean> {
    if (steps >= this.goalReachThreshold) {
      return true;
    } else {
      return false;
    }
  }

  async failedGoal(steps: number): Promise<boolean> {
    if (steps < this.goalFailThreshold) {
      return true;
    } else {
      return false;
    }
  }

  // today's initial level, calculated from yesterday's data
  async getInitLevel(id: string, todayLogExists: boolean): Promise<string> {
    let marker = 0;
    let latestLevel: string;
    let referenceLog: any;

    if (todayLogExists === true) {
      referenceLog = await this.getNthLatestLog(id, 2); // today - 1
    } else {
      referenceLog = await this.getLastLog(id); // latest
    }

    if (referenceLog == null) {
      latestLevel = 'overweight';
    } else {
      latestLevel = referenceLog.level;
      if (await this.failedGoal(referenceLog.steps)) {
        marker--; // FAILED goal yesterday
      }
    }

    const level =
      marker === -1 ? await this.gainWeight(latestLevel) : latestLevel;
    return level;
  }

  async isLevelUpdated(initLevel: string, currLevel: string): Promise<boolean> {
    const initLevelIdx = Object.keys(Level).indexOf(initLevel);
    const currLevelIdx = Object.keys(Level).indexOf(currLevel);
    if (Math.abs(initLevelIdx - currLevelIdx) < 1) {
      return false;
    } else {
      return true;
    }
  }

  async getCurrLevel(id: string): Promise<string> {
    const { level: lastLevel } = await this.prisma.log.findFirst({
      where: { userId: id },
      orderBy: { date: 'desc' },
    });

    const currLevel: string = lastLevel == null ? 'overweight' : lastLevel;
    return currLevel;
  }

  async getLastLog(id: string): Promise<any> {
    const log = await this.prisma.log.findFirst({
      where: { userId: id },
      orderBy: { date: 'desc' },
    });
    return log;
  }

  async getNthLatestLog(id: string, n: number): Promise<any> {
    if ((await this.getLogCount(id)) < n) {
      return null;
    }
    const logs = await this.prisma.log.findMany({
      where: { userId: id },
      orderBy: { date: 'desc' },
      take: n,
    });
    return logs.pop();
  }

  async gainWeight(currLevel: string): Promise<string> {
    const newLevel: string =
      currLevel !== 'veryObese'
        ? Object.keys(Level)[Object.keys(Level).indexOf(currLevel) - 1]
        : currLevel;
    return newLevel;
  }

  async loseWeight(currLevel: string): Promise<string> {
    const newLevel: string =
      currLevel !== 'veryHealthy'
        ? Object.keys(Level)[Object.keys(Level).indexOf(currLevel) + 1]
        : currLevel;
    return newLevel;
  }

  async getLogCount(id: string): Promise<number> {
    const logCount = await this.prisma.log.count({
      where: {
        userId: id,
      },
    });
    return logCount;
  }

  async getTotalSteps(id: string): Promise<number> {
    const allLogs = await this.prisma.log.findMany({
      where: { userId: id },
      select: {
        steps: true,
      },
    });
    const totalSteps: number = allLogs.reduce((acc, obj) => {
      return acc + obj.steps;
    }, 0);
    return totalSteps;
  }

  async calcPrevAndTodayLevelDiff(id: string): Promise<number> {
    let currLevel, prevLevel;
    if (await this.todayLogExists(id)) {
      currLevel = await this.getCurrLevel(id);
      prevLevel = (await this.getNthLatestLog(id, 2)).level;
    } else {
      prevLevel = (await this.getLastLog(id)).level;
      currLevel = await this.getInitLevel(id, false);
    }
    const levelDiff =
      Object.keys(Level).indexOf(currLevel) -
      Object.keys(Level).indexOf(prevLevel);
    return levelDiff;
  }
}
