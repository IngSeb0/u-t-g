import { BeforeInsert, Column, Entity, OneToMany, PrimaryGeneratedColumn } from "typeorm";
import { ProductImage } from "./product-image.entity";
import { ApiProperty } from "@nestjs/swagger";

@Entity()
export class Product {

    @ApiProperty({
        example: '26b071e4-75f9-4897-bec8-0591804360e9',
        description: 'Product id',
        uniqueItems: true
    })
    @PrimaryGeneratedColumn('uuid')
    id: string;
    
    @ApiProperty()
    @Column('text', {
        unique: true
    })
    title: string;
    
    @ApiProperty()
    @Column({
        type: 'text',
        nullable: true
    })
    description: string;
    
    @ApiProperty()
    @Column('text', {
        array: true
    })  
    sizes: string[]
    
    @ApiProperty()
    @Column('bool', {
        default: false
    })
    active: boolean;
    
    
    @ApiProperty()
    @OneToMany(
        ()=> ProductImage,
        (productImage) => productImage.product,
        {cascade: true} //evitar true para q no haya huerfanos
    )
    images?: ProductImage[]

    
    @BeforeInsert()
    checkTitleInsert(){
        this.title = this.title.toUpperCase()
    }

}
