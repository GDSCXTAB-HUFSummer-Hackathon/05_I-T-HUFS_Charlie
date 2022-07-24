import { HttpStatus, Injectable } from '@nestjs/common';
import { PrismaService } from 'src/shared/services/prisma.service';
import { formatDateToMDY } from 'src/utils/formatter';
import { AwardBadgeDto } from './dto/award-badge.dto';

@Injectable()
export class BadgeService {
  constructor(private prisma: PrismaService) {}

  generateBadgeName(tier: number, color: string) {
    const badgeName = `lv${tier}${color}`; // ex. lv4silver
    return badgeName;
  }

  async findAll(): Promise<any> {
    const badges = await this.prisma.badge.findMany({});
    badges.map((b) => {
      b['name'] = this.generateBadgeName(b.tier, b.color);
    });
    return badges;
  }

  async findOne(badgeId: number): Promise<any> {
    const badge = await this.prisma.badge.findUnique({
      where: { id: badgeId },
    });
    badge['name'] = this.generateBadgeName(badge.tier, badge.color);
    return badge;
  }

  async getUserAcquiredBadgeIds(id: string): Promise<any> {
    const acquiredBadges = await this.prisma.userBadge.findMany({
      where: { userId: id },
    });
    const acquiredBadgeId = acquiredBadges.map((b) => b.badgeId);
    return acquiredBadgeId;
  }

  async awardBadge(id: string, badgeData: AwardBadgeDto): Promise<any> {
    const badgeId: number = badgeData.badgeId;
    const badgeLog = await this.prisma.userBadge.create({
      data: {
        user: {
          connect: {
            id: id,
          },
        },
        badge: {
          connect: {
            id: badgeId,
          },
        },
      },
    });
    return { status: HttpStatus.CREATED, data: { badgeLog: badgeLog } };
  }

  async getUserBadgeMap(id: string): Promise<any> {
    const badges = await this.findAll();
    const acquiredBadgeIds = await this.getUserAcquiredBadgeIds(id);
    const promises = badges.map(async (b) =>
      acquiredBadgeIds.includes(b.id)
        ? ((b['acquired'] = true),
          (b['awardedAt'] = formatDateToMDY(
            await this.getAwardedDate(id, b.id),
          )))
        : ((b.acquired = false), (b['awardedAt'] = '')),
    );
    await Promise.all(promises);
    return { status: HttpStatus.OK, data: { badges: badges } };
  }

  async getBadgeDetails(id: string, badgeId: number): Promise<any> {
    const acquiredBadgeIds = await this.getUserAcquiredBadgeIds(id);
    const acquired: boolean = acquiredBadgeIds.includes(badgeId) ? true : false;
    const badge = await this.findOne(badgeId);
    badge.acquired = acquired;

    if (acquired) {
      const { awardedAt } = await this.prisma.userBadge.findFirst({
        where: { userId: id, badgeId: badgeId },
      });
      badge.awardedAt = awardedAt;
    }
    return { status: HttpStatus.OK, data: badge };
  }

  async getAwardedDate(id: string, badgeId: number): Promise<any> {
    const { awardedAt } = await this.prisma.userBadge.findFirst({
      where: { userId: id, badgeId: badgeId },
    });
    return awardedAt;
  }
}
