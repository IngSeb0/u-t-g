import { IsArray, IsBoolean, IsNumber, IsOptional, IsPositive, 
    IsString, MinLength } from "class-validator";

export class CreateProductDto {

    @IsString()
    @MinLength(1)
    title: string;

    @IsPositive()
    @IsNumber()
    @IsOptional()
    price?: number;
    
    @IsOptional()
    @IsString()
    description?: string;
    
    @IsString({each: true})
    @IsArray()
    sizes: string[];
    
    @IsOptional()
    @IsBoolean()
    active?: boolean;

    @IsString({each: true})
    @IsArray()
    @IsOptional()
    images?: string[]


}
