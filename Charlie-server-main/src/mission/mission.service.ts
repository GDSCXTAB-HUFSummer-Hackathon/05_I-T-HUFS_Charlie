import { HttpStatus, Injectable } from '@nestjs/common';
import { PrismaService } from 'src/shared/services/prisma.service';
import { formatDateToMDY } from 'src/utils/formatter';

@Injectable()
export class MissionService {
  constructor(private prisma: PrismaService) {}

  async findOne(): Promise<any> {
    const currMission = await this.prisma.mission.findFirst({
      where: { ongoing: true },
    });
    currMission['startDateFormatted'] = formatDateToMDY(currMission.startDate);
    currMission['endDateFormatted'] = formatDateToMDY(currMission.endDate);

    currMission['completedCount'] = await this.prisma.userMission.count({
      where: {
        MissionId: currMission.id,
      },
    });

    return { status: HttpStatus.OK, data: currMission };
  }
}
