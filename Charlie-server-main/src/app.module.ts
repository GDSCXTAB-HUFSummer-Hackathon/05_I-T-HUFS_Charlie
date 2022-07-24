import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { LogModule } from './log/log.module';
import { UserModule } from './user/user.module';
import { ConfigModule } from '@nestjs/config';
import { AuthService } from './auth/auth.service';
import { BadgeController } from './badge/badge.controller';
import { BadgeModule } from './badge/badge.module';
import { CharlieModule } from './charlie/charlie.module';
import { MissionModule } from './mission/mission.module';

@Module({
  imports: [
    UserModule,
    LogModule,
    ConfigModule.forRoot(),
    BadgeModule,
    CharlieModule,
    MissionModule,
  ],
  controllers: [AppController, BadgeController],
  providers: [AuthService],
})
export class AppModule {}
