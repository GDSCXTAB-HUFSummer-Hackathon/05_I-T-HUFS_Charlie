import { Module } from '@nestjs/common';
import { AuthService } from 'src/auth/auth.service';
import { PrismaService } from 'src/shared/services/prisma.service';
import { LogController } from './log.controller';
import { LogService } from './log.service';

@Module({
  providers: [LogService, PrismaService, AuthService],
  controllers: [LogController],
  exports: [LogService],
})
export class LogModule {}
