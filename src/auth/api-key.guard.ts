import { Injectable, CanActivate, ExecutionContext, UnauthorizedException } from '@nestjs/common';
import { AuthService } from './auth.service';

@Injectable()
export class ApiKeyGuard implements CanActivate {
  constructor(private readonly authService: AuthService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    const apiKey = request.headers['x-api-key'];

    if (!apiKey) {
      throw new UnauthorizedException('Missing API key in x-api-key header');
    }

    const keyEntity = await this.authService.findByKey(apiKey);
    if (!keyEntity) {
      throw new UnauthorizedException('Invalid API key');
    }

    request.apiKey = keyEntity;
    return true;
  }
}
