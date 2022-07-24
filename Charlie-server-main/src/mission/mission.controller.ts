import { Controller, Get } from '@nestjs/common';
import { MissionService } from './mission.service';

@Controller('mission')
export class MissionController {
  constructor(private readonly missionService: MissionService) {}

  @Get()
  async findOne(): Promise<any> {
    return this.missionService.findOne();
  }
}
