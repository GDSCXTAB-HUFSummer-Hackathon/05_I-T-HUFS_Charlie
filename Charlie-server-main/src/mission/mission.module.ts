import { Module } from '@nestjs/common';
import { PrismaService } from 'src/shared/services/prisma.service';
import { MissionController } from './mission.controller';
import { MissionService } from './mission.service';

@Module({
  providers: [PrismaService, MissionService],
  controllers: [MissionController],
  exports: [MissionService],
})
export class MissionModule {}
