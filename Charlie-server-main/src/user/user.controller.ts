import { Body, Controller, Get, Headers, HttpCode, Post } from '@nestjs/common';
import { UserService } from './user.service';
import { UserRO } from './user.interface';
import { CreateUserDto } from './dto/create-user.dto';
import { LoginUserDto } from './dto/login-user.dto';
import { AuthService } from 'src/auth/auth.service';
import { CharlieService } from 'src/charlie/charlie.service';

@Controller('user')
export class UserController {
  constructor(
    private readonly userService: UserService,
    private readonly authService: AuthService,
    private readonly charlieService: CharlieService,
  ) {}

  @Get()
  async getUserInfo(@Headers() headers: any): Promise<string> {
    const { userId } = this.authService.verify(headers);
    return this.userService.getUserInfo(userId);
  }

  @Get('/mypage')
  async getUserInfoForMyPage(@Headers() headers: any): Promise<string> {
    const { userId } = this.authService.verify(headers);
    return this.userService.getUserInfoForMyPage(userId);
  }

  @Post()
  async create(@Body() userData: CreateUserDto) {
    const newUser = await this.userService.create(userData);
    if (newUser.status === 201) {
      await this.charlieService.createDefaultCharlie(newUser.data.id);
    }
    return newUser;
  }

  @HttpCode(200)
  @Post('/login')
  async login(@Body() loginUserDto: LoginUserDto): Promise<UserRO> {
    return await this.userService.login(loginUserDto);
  }
}
