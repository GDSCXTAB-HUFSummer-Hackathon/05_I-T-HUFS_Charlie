import { IsNotEmpty, IsString } from '@nestjs/class-validator';
import { MaxLength, MinLength } from 'class-validator';

export class CreateUserDto {
  @IsNotEmpty()
  @IsString()
  @MinLength(2)
  readonly username: string;

  @IsNotEmpty()
  @IsString()
  @MinLength(6)
  @MaxLength(20)
  readonly password: string;
}
