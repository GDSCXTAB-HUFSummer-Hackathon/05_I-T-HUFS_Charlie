import { IsNotEmpty } from '@nestjs/class-validator';

export class LoginUserDto {
  @IsNotEmpty()
  readonly username: string;

  @IsNotEmpty()
  readonly password: string;
}
