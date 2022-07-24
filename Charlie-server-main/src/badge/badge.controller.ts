import {
  Controller,
  Get,
  Headers,
  Param,
  ParseIntPipe,
  Post,
  Body,
} from '@nestjs/common';
import { AuthService } from 'src/auth/auth.service';
import { BadgeService } from './badge.service';
import { AwardBadgeDto } from './dto/award-badge.dto';

@Controller('badge')
export class BadgeController {
  constructor(
    private readonly authService: AuthService,
    private readonly badgeService: BadgeService,
  ) {}

  @Get()
  async getUserBadgeMap(@Headers() headers: any): Promise<any> {
    const { userId } = this.authService.verify(headers);
    return this.badgeService.getUserBadgeMap(userId);
  }

  @Get('/:badgeId')
  async getBadgeDetails(
    @Headers() headers: any,
    @Param('badgeId', ParseIntPipe) badgeId: number,
  ): Promise<any> {
    const { userId } = this.authService.verify(headers);
    return this.badgeService.getBadgeDetails(userId, badgeId);
  }

  @Post()
  async awardBadge(
    @Headers() headers: any,
    @Body() badgeData: AwardBadgeDto,
  ): Promise<any> {
    const { userId } = this.authService.verify(headers);
    return this.badgeService.awardBadge(userId, badgeData);
  }
}
