import { Body, Controller, Get, Post, Headers, Put } from '@nestjs/common';
import { AuthService } from 'src/auth/auth.service';
import { CreateLogDto } from './dto/create-log.dto';
import { UpdateLogDto } from './dto/update-log.dto';
import { LogService } from './log.service';

@Controller('log')
export class LogController {
  constructor(
    private readonly logService: LogService,
    private readonly authService: AuthService,
  ) {}

  @Get()
  async findAll(@Headers() headers: any): Promise<any> {
    const { userId } = this.authService.verify(headers);
    return this.logService.findAll(userId);
  }

  @Get('/logExists')
  async logExists(@Headers() headers: any): Promise<any> {
    const { userId } = this.authService.verify(headers);
    return this.logService.logExists(userId);
  }

  @Get('/today')
  async findTodayLog(@Headers() headers: any): Promise<boolean> {
    const { userId } = this.authService.verify(headers);
    return this.logService.todayLogExists(userId);
  }

  @Post()
  async create(
    @Headers() headers: any,
    @Body() logData: CreateLogDto,
  ): Promise<any> {
    const { userId } = this.authService.verify(headers);
    return this.logService.create(userId, logData);
  }

  @Put()
  async update(
    @Headers() headers: any,
    @Body() logData: UpdateLogDto,
  ): Promise<any> {
    const { userId } = this.authService.verify(headers);
    return this.logService.update(userId, logData);
  }
}
