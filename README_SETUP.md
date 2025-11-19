# 🚀 API REST con NestJS, PostgreSQL y API Keys

## 📋 Descripción del Proyecto

API REST completa para gestionar productos con imágenes, implementando:
- ✅ Base de datos PostgreSQL con Docker
- ✅ Endpoints públicos (GET) y privados (POST/PATCH/DELETE)
- ✅ Sistema de autenticación por API Keys
- ✅ Validación de DTOs con class-validator
- ✅ Relaciones OneToMany/ManyToOne entre entidades
- ✅ Paginación de resultados
- ✅ Documentación automática con Swagger
- ✅ Manejo robusto de errores

---

## ⚙️ Requisitos Previos

- **Node.js** v18+ 
- **npm** o **yarn**
- **Docker** y **Docker Compose**
- **Git**

---

## 🔧 Instalación y Configuración

### 1️⃣ Clonar el repositorio

```bash
git clone https://github.com/IngSeb0/u-t-g.git
cd u-t-g
```

### 2️⃣ Instalar dependencias

```bash
npm install
```

### 3️⃣ Configurar variables de entorno

Crea o edita el archivo `.env` en la raíz del proyecto:

```env
# Database
DB_HOST=localhost
DB_PORT=5433
DB_USERNAME=postgres
DB_PASSWORD=postgres
DB_NAME=be_study

# Application
PORT=4000
```

**Nota:** El puerto `5433` evita conflictos si ya tienes PostgreSQL en `5432`.

### 4️⃣ Levantar la base de datos con Docker

```bash
docker-compose up -d
```

Verifica que el contenedor está corriendo:
```bash
docker ps
```

Deberías ver un contenedor llamado `dev-estudio` corriendo en el puerto `5433`.

---

## 🚀 Ejecutar la Aplicación

### Modo Desarrollo (con hot reload)

```bash
npm run start:dev
```

El servidor se iniciará en `http://localhost:4000`

**Logs esperados:**
```
[Nest] ... LOG [NestApplication] Nest application successfully started
```

### Compilación para Producción

```bash
npm run build
npm run start:prod
```

---

## 🧪 Pruebas de API

### Opción 1: Script de Pruebas Automático (PowerShell)

```bash
.\test-api.ps1
```

Este script ejecuta automáticamente:
1. GET /products (público)
2. POST /auth/register (generar API Key)
3. POST /products sin API Key (validar seguridad)
4. POST /products con API Key (crear producto)
5. GET /products/:id (obtener uno)
6. PATCH /products/:id (actualizar)
7. DELETE /products/:id (eliminar)
8. Validaciones de errores

### Opción 2: Documentación Interactiva (Swagger)

Abre en tu navegador:
```
http://localhost:4000/api
```

Desde Swagger puedes:
- Ver todos los endpoints documentados
- Probar las APIs directamente
- Visualizar esquemas de request/response

### Opción 3: Manual con cURL

Ver archivo [`TEST_API.md`](./TEST_API.md) para ejemplos completos.

**Flujo rápido:**

1. **Obtener productos (público):**
```bash
curl -X GET http://localhost:4000/api/products
```

2. **Generar API Key:**
```bash
curl -X POST http://localhost:4000/api/auth/register
```

3. **Crear producto (protegido):**
```bash
curl -X POST http://localhost:4000/api/products \
  -H "Content-Type: application/json" \
  -H "x-api-key: YOUR_API_KEY_HERE" \
  -d '{
    "title": "Laptop Gaming",
    "price": 1299.99,
    "description": "Laptop de alto rendimiento",
    "sizes": ["15p", "17p"],
    "active": true,
    "images": ["https://example.com/laptop.jpg"]
  }'
```

---

## 📁 Estructura del Proyecto

```
u-t-g/
├── src/
│   ├── auth/                      # Módulo de autenticación
│   │   ├── auth.module.ts
│   │   ├── auth.service.ts
│   │   ├── auth.controller.ts
│   │   ├── api-key.guard.ts       # Guard para proteger rutas
│   │   └── entities/
│   │       └── api-key.entity.ts  # Entidad para API Keys
│   │
│   ├── products/                  # Módulo de productos
│   │   ├── products.module.ts
│   │   ├── products.service.ts
│   │   ├── products.controller.ts
│   │   ├── dto/
│   │   │   ├── create-product.dto.ts
│   │   │   └── update-product.dto.ts
│   │   └── entities/
│   │       ├── product.entity.ts
│   │       └── product-image.entity.ts
│   │
│   ├── common/                    # Utilidades compartidas
│   │   └── dtos/
│   │       └── pagination.dto.ts
│   │
│   ├── app.module.ts              # Módulo raíz
│   └── main.ts                    # Punto de entrada
│
├── postgres/                      # Datos de PostgreSQL (gitignored)
├── .env                           # Variables de entorno
├── docker-compose.yml             # Configuración de Docker
├── package.json
├── tsconfig.json
├── TEST_API.md                    # Guía de pruebas manual
└── test-api.ps1                   # Script de pruebas automático
```

---

## 🔐 Sistema de Autenticación

### Cómo Funciona

1. **Registro (Público):**
   - Endpoint: `POST /api/auth/register`
   - Respuesta: `{ "apiKey": "uuid-aqui" }`
   - La API Key se guarda en la base de datos

2. **Acceso a Rutas Protegidas:**
   - Envía el header: `x-api-key: TU_API_KEY`
   - El `ApiKeyGuard` valida la key en cada petición
   - Si es inválida o está ausente, devuelve `401 Unauthorized`

### Rutas Protegidas vs Públicas

| Ruta | Método | Público | Requiere API Key |
|------|--------|---------|------------------|
| `/api/products` | GET | ✅ | ❌ |
| `/api/products/:id` | GET | ✅ | ❌ |
| `/api/products` | POST | ❌ | ✅ |
| `/api/products/:id` | PATCH | ❌ | ✅ |
| `/api/products/:id` | DELETE | ❌ | ✅ |
| `/api/auth/register` | POST | ✅ | ❌ |

---

## 📊 Base de Datos

### Tablas Principales

#### `product`
```sql
id (UUID) - Primary Key
title (TEXT) - Unique
description (TEXT) - Nullable
sizes (TEXT[]) - Array
active (BOOLEAN) - Default: false
```

#### `product_image`
```sql
id (UUID) - Primary Key
url (TEXT)
product_id (UUID) - Foreign Key → product.id
```

#### `api_key`
```sql
id (UUID) - Primary Key
key (TEXT) - Unique
createdAt (TIMESTAMP) - Auto-generated
```

---

## 🛠️ Troubleshooting

### Error: "EADDRINUSE: address already in use :::4000"
**Solución:** Cambia el puerto en `.env` a uno disponible (ej: `5000`), o mata procesos Node:
```bash
Get-Process -Name node | Stop-Process -Force
```

### Error: "Port 5433 already in use"
**Solución:** Usa un puerto diferente o detén el contenedor:
```bash
docker-compose down
docker-compose up -d
```

### Error: "connect ECONNREFUSED 127.0.0.1:5433"
**Solución:** Verifica que Docker está corriendo y la BD está lista:
```bash
docker logs dev-estudio
```

### Error: "Nest can't resolve dependencies"
**Solución:** Verifica que los módulos están importados correctamente en `app.module.ts`.

---

## 📝 Variables de Entorno Explicadas

```env
# PostgreSQL
DB_HOST=localhost              # Dirección del servidor
DB_PORT=5433                  # Puerto expuesto (contenedor: 5432)
DB_USERNAME=postgres          # Usuario de BD
DB_PASSWORD=postgres          # Contraseña
DB_NAME=be_study              # Nombre de la BD

# NestJS
PORT=4000                     # Puerto donde corre la app
```

---

## 🧹 Limpiar

### Detener contenedores de Docker
```bash
docker-compose down
```

### Remover volúmenes (datos de BD)
```bash
docker-compose down -v
```

### Limpiar node_modules
```bash
rm -r node_modules
npm install
```

---

## 📚 Recursos Útiles

- [Documentación NestJS](https://docs.nestjs.com)
- [TypeORM Docs](https://typeorm.io)
- [PostgreSQL Docs](https://www.postgresql.org/docs)
- [Docker Docs](https://docs.docker.com)
- [Swagger OpenAPI](https://swagger.io)

---

## 👨‍💼 Autor

**Sebastián Ingeniería**  
GitHub: [@IngSeb0](https://github.com/IngSeb0)

---

## 📄 Licencia

UNLICENSED

---

## ✅ Checklist de Implementación

- [x] Configuración de TypeORM con PostgreSQL
- [x] Entidades: Product, ProductImage, ApiKey
- [x] DTOs con validación (CreateProductDto, UpdateProductDto)
- [x] Relaciones OneToMany/ManyToOne
- [x] Sistema de API Keys
- [x] ApiKeyGuard para proteger rutas
- [x] Paginación con limit/offset
- [x] Manejo de errores (404, 400, 401)
- [x] Swagger/OpenAPI
- [x] Docker Compose con PostgreSQL
- [x] Variables de entorno
- [x] Scripts de prueba

---

**Última actualización:** 19 de Noviembre, 2025

Construido con ❤️ usando NestJS
