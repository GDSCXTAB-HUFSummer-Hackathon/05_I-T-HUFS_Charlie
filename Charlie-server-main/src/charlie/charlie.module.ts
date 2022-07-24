import { Module } from '@nestjs/common';
import { AuthService } from 'src/auth/auth.service';
import { LogService } from 'src/log/log.service';
import { PrismaService } from 'src/shared/services/prisma.service';
import { CharlieController } from './charlie.controller';
import { CharlieService } from './charlie.service';

@Module({
  providers: [CharlieService, AuthService, LogService, PrismaService],
  controllers: [CharlieController],
  exports: [CharlieService],
})
export class CharlieModule {}
