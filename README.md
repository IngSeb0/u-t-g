### GUIA DE ESTUDIO PARCIAL 2 


# POSIBLE PARCIAL 
Creación de API para estudiantes del siguientes semestres
* El usuario se registra y obtiene un API KEY 
* El usuario envia el TOKEN como header para acceder a ciertos recursos
* La API tiene endpoints públicos y privados
* La API retorna recursos multimedia 

Crear proyecto 

```
nest new <project_name>
```

Agregar variables de entorno base de datos para docker
* crea archivo .env
* docker puede acceder al archivo .env asi no este configurado en nest las variables de entorno

```
DB_PASSWORD=clave
DB_NAME=nombre
```
## Levantar base de datos local docker
ejecuta docker compose para desplegar la base de datos
* va buscar el archivo docker-compose.yml 
``` 
docker-compose up -d
```

valida en tu gestor de base de datos preferido si te puedes conectar
* db url y conectarse en tableplus, dbbeaver, etc.. 
```
localhost:5432
user: postgres
password: <la misma del .env>
```

remover carpeta de /postgres en el .gitignore para no subir información
innecesaria al repositorio. 

## Conectar Postgres con Nest

### variables de entorno
Para empezar vamos a preparar Nest para que pueda recibir variables de entorno
* instalar modulo de config 
```npm i @nestjs/config```

* configurar el archivo app.module.ts
```
import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';

@Module({
  imports: [ConfigModule.forRoot()], // módulo de variables de entorno
})
export class AppModule {}
```

### agregar drivers bases de datos
* el último driver va variar dependiendo la base de datos que uses
```
npm i @nestjs/typeorm typeorm pg
```

agregar variables de entorno relacionadas a DB faltantes
```
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
```

* configurar app.module.ts, solamente habrá un forRoot en el proyecto
```
import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';

@Module({
  imports: [
    ConfigModule.forRoot(),
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: process.env.DB_HOST,
      port: +process.env.DB_PORT!,
      database: process.env.DB_NAME,
      username: process.env.DB_USERNAME,
      password: process.env.DB_PASSWORD,
      autoLoadEntities: true,
      synchronize: true, // SOLO EN DESARROLLO
    })
  ],
})
export class AppModule {}
```

