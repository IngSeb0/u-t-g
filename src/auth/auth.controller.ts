import { Controller, Post } from '@nestjs/common';
import { AuthService } from './auth.service';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('register')
  async register() {
    const apiKey = await this.authService.createApiKey();
    // return only the key string to the user
    return { apiKey: apiKey.key };
  }
}
