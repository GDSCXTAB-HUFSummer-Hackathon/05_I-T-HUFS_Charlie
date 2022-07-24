import { Module } from '@nestjs/common';
import { AuthService } from 'src/auth/auth.service';
import { PrismaService } from 'src/shared/services/prisma.service';
import { BadgeController } from './badge.controller';
import { BadgeService } from './badge.service';

@Module({
  providers: [BadgeService, PrismaService, AuthService],
  controllers: [BadgeController],
  exports: [BadgeService],
})
export class BadgeModule {}
