import { Injectable, UnauthorizedException } from '@nestjs/common';
const jwt = require('jsonwebtoken');

@Injectable()
export class AuthService {
  verify(headers: any) {
    const jwtString = headers.authorization
      ? headers.authorization.split('Bearer ')[1]
      : headers.bearer;
    try {
      const payload = jwt.verify(jwtString, process.env.SECRET);

      const { id, username } = payload;

      return {
        userId: id,
      };
    } catch (error) {
      throw new UnauthorizedException();
    }
  }
}
