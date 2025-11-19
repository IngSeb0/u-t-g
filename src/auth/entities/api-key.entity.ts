import { Column, CreateDateColumn, Entity, PrimaryGeneratedColumn } from 'typeorm';

@Entity()
export class ApiKey {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column('text', { unique: true })
  key: string;

  @CreateDateColumn()
  createdAt: Date;
}
