import { BadRequestException, Injectable, InternalServerErrorException, Logger, NotFoundException } from '@nestjs/common';
import { CreateProductDto } from './dto/create-product.dto';
import { UpdateProductDto } from './dto/update-product.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Product } from './entities/product.entity';
import { PaginationDto } from 'src/common/dtos/pagination.dto';
import { ProductImage } from './entities/product-image.entity';

@Injectable()
export class ProductsService {

  private readonly logger = new Logger('Product Service')

  constructor(
    @InjectRepository(Product)
    private readonly productRepository: Repository<Product>,
    @InjectRepository(ProductImage)
    private readonly productImageRepository: Repository<ProductImage>,
    ){}

  async create(createProductDto: CreateProductDto) {
    try {
      const {images = [], ...productDetails} = createProductDto;
      const product = this.productRepository.create({
        ...productDetails, 
        images: images.map(img => this.productImageRepository.create({url: img})) })
      await this.productRepository.save(product)
      // return product para este caso no quiero el id de la img, quiero solamente el string y lo ajusto 
      // por este motivo lo retorno de esta forma
      return {...product, images};
    } catch (error) {
      this.handleDBExceptions(error);
    }
  }

  async findAll(pagination: PaginationDto) {
    const {limit=10, offset=0} = pagination;
   try {
    return await this.productRepository.find({
      take: limit,
      skip: offset,
      relations: {
        images: true
      }
    })
   } catch (error) {
    this.handleDBExceptions(error)
   }
  }

  async findOne(id: string): Promise<Product> {
    try {
      const product = await this.productRepository.findOne({
        where: { id },
        relations: { images: true }
      })
      if(!product){
        throw new NotFoundException(`Producto con el id ${id} no fue encontrado`)
      }
      return product;
    } catch (error) {
      this.handleDBExceptions(error)
      throw error;
    }
  }

  async update(id: string, updateProductDto: UpdateProductDto) {
    try {
      const product = await this.findOne(id);
      
      // Merge updates
      Object.assign(product, updateProductDto);
      
      // Save changes
      await this.productRepository.save(product);
      
      return product;
    } catch (error) {
      this.handleDBExceptions(error);
    }
  }

  async remove(id: string) {
    try {
      const product = await this.findOne(id)
      if(product){
        await this.productRepository.remove(product)
      }
    } catch (error) {
      this.handleDBExceptions(error);
    }
  }

  private handleDBExceptions(error: any){
    if(error.code === '23505'){
        throw new BadRequestException(error.detail)
      }
      this.logger.error(error)
      throw new InternalServerErrorException('Unexpected error, check logs ')
  }
}
