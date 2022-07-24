import { Module } from '@nestjs/common';
import { AuthService } from 'src/auth/auth.service';
import { BadgeService } from 'src/badge/badge.service';
import { CharlieService } from 'src/charlie/charlie.service';
import { LogService } from 'src/log/log.service';
import { PrismaService } from 'src/shared/services/prisma.service';
import { UserController } from './user.controller';
import { UserService } from './user.service';

@Module({
  providers: [
    UserService,
    PrismaService,
    LogService,
    AuthService,
    BadgeService,
    CharlieService,
  ],
  controllers: [UserController],
  exports: [UserService],
})
export class UserModule {}
