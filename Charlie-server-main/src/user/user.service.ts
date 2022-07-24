import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { CreateUserDto } from './dto/create-user.dto';
import * as argon2 from 'argon2';
import { LoginUserDto } from './dto/login-user.dto';
import { PrismaService } from 'src/shared/services/prisma.service';
import { LogService } from 'src/log/log.service';
import { formatDateToMDY } from 'src/utils/formatter';
import { CharlieService } from 'src/charlie/charlie.service';
const jwt = require('jsonwebtoken');

@Injectable()
export class UserService {
  constructor(
    private prisma: PrismaService,
    private logService: LogService,
    private charlieService: CharlieService,
  ) {}

  async getUserInfoForMyPage(id: string): Promise<any> {
    const userInfo = await this.prisma.user.findUnique({
      where: { id },
      select: {
        username: true,
        createdAt: true,
      },
    });
    const formattedDate = await formatDateToMDY(userInfo.createdAt);
    return {
      status: HttpStatus.OK,
      data: { username: userInfo.username, joined: formattedDate },
    };
  }

  async getUserInfo(id: string): Promise<any> {
    try {
      const { data } = await this.getUserInfoForMyPage(id);
      const totalSteps: number = await this.logService.getTotalSteps(id);
      const currLevel: string =
        totalSteps === 0
          ? 'overweight'
          : await this.logService.getCurrLevel(id);
      data['currLevel'] = currLevel;
      data['totalSteps'] = totalSteps;
      return { status: HttpStatus.OK, data: data };
    } catch (e) {
      throw new HttpException(
        {
          statusCode: HttpStatus.NOT_FOUND,
          message: 'User not found',
        },
        404,
      );
    }
  }

  async create(dto: CreateUserDto): Promise<any> {
    const { username, password } = dto;
    const userNotUnique = await this.prisma.user.findUnique({
      where: { username },
    });
    if (userNotUnique) {
      const errors = { username: 'Username must be unique' };
      throw new HttpException(
        {
          statusCode: HttpStatus.FORBIDDEN,
          message: 'Input data validation failed',
          errors,
        },
        403,
      );
    }
    const hashedPassword = await argon2.hash(password);
    const data = {
      username,
      password: hashedPassword,
    };
    const user = await this.prisma.user.create({ data });
    const token = await this.generateJWT(user);
    return { status: HttpStatus.CREATED, data: { token, ...user } };
  }

  async login(payload: LoginUserDto): Promise<any> {
    const _user = await this.prisma.user.findUnique({
      where: { username: payload.username },
    });
    const errors = { User: 'Wrong username or password' };
    if (!_user) {
      throw new HttpException(
        { statusCode: HttpStatus.FORBIDDEN, errors },
        403,
      );
    }
    const authenticated = await argon2.verify(_user.password, payload.password);
    if (!authenticated) {
      throw new HttpException(
        { statusCode: HttpStatus.FORBIDDEN, errors },
        403,
      );
    }
    const token = await this.generateJWT(_user);
    const { password, ...user } = _user;
    return {
      status: HttpStatus.OK,
      data: { token, ...user },
    };
  }

  public generateJWT(user) {
    const today = new Date();
    const exp = new Date(today);
    exp.setDate(today.getDate() + 60);

    return jwt.sign(
      {
        id: user.id,
        usernmae: user.username,
        exp: exp.getTime() / 1000,
      },
      process.env.SECRET,
    );
  }
}
