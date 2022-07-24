import { Controller, Headers, Get, Put, Body } from '@nestjs/common';
import { AuthService } from 'src/auth/auth.service';
import { CharlieService } from './charlie.service';

@Controller('charlie')
export class CharlieController {
  constructor(
    private charlieService: CharlieService,
    private authService: AuthService,
  ) {}

  @Get()
  async getComponentIndexes(@Headers() headers: any): Promise<any> {
    const { userId } = this.authService.verify(headers);
    return this.charlieService.getComponentIndexes(userId);
  }
}
