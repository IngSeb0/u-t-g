# 📋 API Testing Guide

## Servidor corriendo en: `http://localhost:4000`

---

## 1️⃣ **Endpoints Públicos** (sin API Key requerida)

### GET /api/products
Obtiene todos los productos con paginación.

```bash
# Sin parámetros (defaults: limit=10, offset=0)
curl -X GET http://localhost:4000/api/products

# Con paginación
curl -X GET "http://localhost:4000/api/products?limit=5&offset=0"
```

**Respuesta esperada:**
```json
[]
```

---

### GET /api/products/:id
Obtiene un producto específico por ID (con imágenes).

```bash
curl -X GET http://localhost:4000/api/products/26b071e4-75f9-4897-bec8-0591804360e9
```

**Respuesta esperada (si existe):**
```json
{
  "id": "26b071e4-75f9-4897-bec8-0591804360e9",
  "title": "PRODUCTO EJEMPLO",
  "description": "Descripción del producto",
  "sizes": ["S", "M", "L"],
  "active": true,
  "images": [
    {
      "id": "img-uuid-1",
      "url": "https://example.com/image1.jpg"
    }
  ]
}
```

---

## 2️⃣ **Endpoints Protegidos** (requieren API Key)

### Primero: Registrar API Key

```bash
curl -X POST http://localhost:4000/api/auth/register
```

**Respuesta esperada:**
```json
{
  "apiKey": "550e8400-e29b-41d4-a716-446655440000"
}
```

**Guarda este valor para las siguientes peticiones.**

---

### POST /api/products
Crea un nuevo producto (requiere API Key).

```bash
# Guarda tu apiKey en una variable (reemplaza con tu valor real)
$apiKey = "TU_API_KEY_AQUI"

curl -X POST http://localhost:4000/api/products \
  -H "Content-Type: application/json" \
  -H "x-api-key: $apiKey" \
  -d '{
    "title": "Laptop Gaming",
    "price": 1299.99,
    "description": "Laptop de alto rendimiento",
    "sizes": ["15 pulgadas", "17 pulgadas"],
    "active": true,
    "images": [
      "https://example.com/laptop1.jpg",
      "https://example.com/laptop2.jpg"
    ]
  }'
```

**Respuesta esperada:**
```json
{
  "id": "generated-uuid",
  "title": "LAPTOP GAMING",
  "price": 1299.99,
  "description": "Laptop de alto rendimiento",
  "sizes": ["15 pulgadas", "17 pulgadas"],
  "active": true,
  "images": [
    "https://example.com/laptop1.jpg",
    "https://example.com/laptop2.jpg"
  ]
}
```

---

### PATCH /api/products/:id
Actualiza un producto existente (requiere API Key).

```bash
$apiKey = "TU_API_KEY_AQUI"
$productId = "generated-uuid-del-paso-anterior"

curl -X PATCH "http://localhost:4000/api/products/$productId" \
  -H "Content-Type: application/json" \
  -H "x-api-key: $apiKey" \
  -d '{
    "title": "Laptop Gaming Pro",
    "price": 1499.99,
    "active": true
  }'
```

---

### DELETE /api/products/:id
Elimina un producto (requiere API Key).

```bash
$apiKey = "TU_API_KEY_AQUI"
$productId = "generated-uuid-del-paso-anterior"

curl -X DELETE "http://localhost:4000/api/products/$productId" \
  -H "x-api-key: $apiKey"
```

---

## 3️⃣ **Casos de Error**

### Sin API Key en endpoint protegido
```bash
curl -X POST http://localhost:4000/api/products \
  -H "Content-Type: application/json" \
  -d '{"title": "Test"}'
```

**Respuesta esperada (401):**
```json
{
  "message": "Missing API key in x-api-key header",
  "error": "Unauthorized",
  "statusCode": 401
}
```

---

### Con API Key inválida
```bash
curl -X POST http://localhost:4000/api/products \
  -H "Content-Type: application/json" \
  -H "x-api-key: invalid-key-123" \
  -d '{"title": "Test"}'
```

**Respuesta esperada (401):**
```json
{
  "message": "Invalid API key",
  "error": "Unauthorized",
  "statusCode": 401
}
```

---

### Validación de DTO fallida
```bash
$apiKey = "TU_API_KEY_AQUI"

curl -X POST http://localhost:4000/api/products \
  -H "Content-Type: application/json" \
  -H "x-api-key: $apiKey" \
  -d '{
    "price": -100,
    "sizes": "invalid"
  }'
```

**Respuesta esperada (400):**
```json
{
  "message": [
    "title should not be empty",
    "price must be a positive number",
    "sizes must be an array"
  ],
  "error": "Bad Request",
  "statusCode": 400
}
```

---

## 📊 Swagger Documentation

Accede a la documentación interactiva de Swagger en:
```
http://localhost:4000/api
```

Desde allí puedes probar todos los endpoints con interfaz gráfica.

---

## 🔗 Flujo Completo de Prueba

1. **Registrar API Key:**
   ```bash
   curl -X POST http://localhost:4000/api/auth/register
   ```
   Guarda el `apiKey` devuelto.

2. **Listar productos (público):**
   ```bash
   curl -X GET http://localhost:4000/api/products
   ```

3. **Crear producto (con API Key):**
   ```bash
   curl -X POST http://localhost:4000/api/products \
     -H "Content-Type: application/json" \
     -H "x-api-key: TU_API_KEY" \
     -d '{"title": "Test", "sizes": ["S"], "images": []}'
   ```
   Guarda el `id` devuelto.

4. **Obtener producto específico (público):**
   ```bash
   curl -X GET http://localhost:4000/api/products/ID_GUARDADO
   ```

5. **Actualizar producto (con API Key):**
   ```bash
   curl -X PATCH http://localhost:4000/api/products/ID_GUARDADO \
     -H "Content-Type: application/json" \
     -H "x-api-key: TU_API_KEY" \
     -d '{"title": "Actualizado"}'
   ```

6. **Eliminar producto (con API Key):**
   ```bash
   curl -X DELETE http://localhost:4000/api/products/ID_GUARDADO \
     -H "x-api-key: TU_API_KEY"
   ```

---

## ✅ Resumen de Implementación

| Característica | Estado |
|---|---|
| Base de datos PostgreSQL con Docker | ✅ |
| Validación de DTOs con class-validator | ✅ |
| Endpoints públicos (GET productos) | ✅ |
| Endpoints privados (POST/PATCH/DELETE) | ✅ |
| Sistema de API Keys | ✅ |
| Relaciones OneToMany/ManyToOne | ✅ |
| Paginación | ✅ |
| Manejo de errores | ✅ |
| Swagger/OpenAPI | ✅ |
