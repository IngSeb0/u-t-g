import { BeforeInsert, Column, Entity, OneToMany, PrimaryGeneratedColumn } from "typeorm";
import { ProductImage } from "./product-image.entity";

@Entity()
export class Product {

    @PrimaryGeneratedColumn('uuid')
    id: string;

    @Column('text', {
        unique: true
    })
    title: string;

    @Column({
        type: 'text',
        nullable: true
    })
    description: string;

    @Column('text', {
        array: true
    })
    sizes: string[]

    @Column('bool', {
        default: false
    })
    active: boolean;

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
