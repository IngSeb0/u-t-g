import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ApiKey } from './entities/api-key.entity';
import { randomUUID } from 'crypto';

@Injectable()
export class AuthService {
  private readonly logger = new Logger('AuthService');

  constructor(
    @InjectRepository(ApiKey)
    private readonly apiKeyRepository: Repository<ApiKey>,
  ) {}

  async createApiKey() {
    const key = randomUUID();
    const entity = this.apiKeyRepository.create({ key });
    await this.apiKeyRepository.save(entity);
    this.logger.log(`Created API key ${entity.id}`);
    return entity;
  }

  async findByKey(key: string) {
    return this.apiKeyRepository.findOneBy({ key });
  }
}
