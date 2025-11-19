# 📮 Guía de Uso - Postman

## 🚀 Importar la Colección

1. **Abre Postman** (descárgate desde https://www.postman.com/downloads/)

2. **Haz clic en "Import"** (esquina superior izquierda)

3. **Selecciona "Upload Files"** y carga: `Postman_Collection.json`

4. ✅ **La colección "API REST - Productos con API Keys" aparecerá en tu lista**

---

## 🔧 Configurar Variables de Entorno

Postman usa variables para almacenar valores dinámicos. La colección incluye dos variables:

- `{{api_key}}` - Tu API Key (se obtiene del endpoint de registro)
- `{{product_id}}` - ID del producto (se guarda después de crear uno)

### Opción 1: Variables de Colección (Recomendado)

1. Abre la colección **"API REST - Productos con API Keys"**
2. Ve a la pestaña **"Variables"**
3. Verás dos variables: `api_key` y `product_id` (ambas vacías)
4. **No necesitas hacer nada**, se llenarán automáticamente

---

## 📋 Flujo Recomendado de Pruebas

### PASO 1️⃣: Generar API Key

1. En la colección, abre la carpeta **"🔐 AUTENTICACIÓN"**
2. Haz clic en **"1. Registrar y obtener API Key"**
3. Presiona **"Send"** (azul, arriba a la derecha)
4. **Respuesta esperada:**
   ```json
   {
     "apiKey": "550e8400-e29b-41d4-a716-446655440000"
   }
   ```
5. **Guarda esta API Key:**
   - Haz clic en la pestaña **"Tests"** (abajo)
   - Postman ejecutará un script que guarda automáticamente en `{{api_key}}`

---

### PASO 2️⃣: Listar Productos (Público)

1. Abre la carpeta **"📋 PRODUCTOS - PÚBLICOS"**
2. Haz clic en **"2. GET - Listar todos los productos"**
3. Presiona **"Send"**
4. **Respuesta esperada:** `[]` (array vacío, por ahora no hay productos)

---

### PASO 3️⃣: Crear Primer Producto (Protegido)

1. Abre la carpeta **"➕ PRODUCTOS - CREAR (PROTEGIDO)"**
2. Haz clic en **"4. POST - Crear producto con imágenes"**
3. **Verifica que el header tenga:**
   ```
   x-api-key: {{api_key}}
   ```
   *(Postman reemplazará {{api_key}} con tu valor guardado)*
4. Presiona **"Send"**
5. **Respuesta esperada (201 Created):**
   ```json
   {
     "id": "26b071e4-75f9-4897-bec8-0591804360e9",
     "title": "LAPTOP GAMING RTX 4090",
     "price": 1999.99,
     "description": "Laptop de alto rendimiento...",
     "sizes": ["15 pulgadas", "17 pulgadas"],
     "active": true,
     "images": [
       "https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=500",
       "https://images.unsplash.com/photo-1588872657840-790ff3bde172?w=500"
     ]
   }
   ```
6. **Guarda el ID:**
   - Copia el valor de `id` de la respuesta
   - Abre la colección → "Variables"
   - Pega el ID en el campo `product_id` (Current value)
   - Presiona "Save"

---

### PASO 4️⃣: Obtener Producto por ID (Público)

1. Abre **"3. GET - Obtener producto por ID"**
2. La URL ya contiene `{{product_id}}` (Postman lo reemplazará)
3. Presiona **"Send"**
4. **Respuesta esperada (200 OK):** El producto completo con imágenes

---

### PASO 5️⃣: Listar Productos Nuevamente

1. Abre **"2. GET - Listar todos los productos"**
2. Presiona **"Send"**
3. **Respuesta esperada:** Array con 1 producto

---

### PASO 6️⃣: Actualizar Producto (Protegido)

1. Abre **"✏️ PRODUCTOS - ACTUALIZAR (PROTEGIDO)"**
2. Haz clic en **"5. PATCH - Actualizar producto"**
3. **En el Body, cambia los valores que quieras actualizar:**
   ```json
   {
     "title": "Laptop Gaming Ultra Pro RTX 4090",
     "price": 2299.99
   }
   ```
4. Presiona **"Send"**
5. **Respuesta esperada (200 OK):** El producto actualizado

---

### PASO 7️⃣: Eliminar Producto (Protegido)

1. Abre **"🗑️ PRODUCTOS - ELIMINAR (PROTEGIDO)"**
2. Haz clic en **"6. DELETE - Eliminar producto"**
3. Presiona **"Send"**
4. **Respuesta esperada (200 OK):** `{}`

---

### PASO 8️⃣: Verificar que está eliminado

1. Abre **"2. GET - Listar todos los productos"**
2. Presiona **"Send"**
3. **Respuesta esperada:** `[]` (array vacío nuevamente)

---

## ❌ Pruebas de Error

En la carpeta **"❌ CASOS DE ERROR"** hay 4 peticiones para validar manejo de errores:

### Error 1: Sin API Key
```
POST /api/products (SIN el header x-api-key)
Respuesta esperada: 401 Unauthorized - "Missing API key in x-api-key header"
```

### Error 2: API Key Inválida
```
POST /api/products (con x-api-key: invalid-key-12345)
Respuesta esperada: 401 Unauthorized - "Invalid API key"
```

### Error 3: Datos Inválidos (DTO)
```
POST /api/products (con title vacío, price negativo, sizes como string)
Respuesta esperada: 400 Bad Request - Lista de errores de validación
```

### Error 4: Producto no encontrado
```
GET /api/products/00000000-0000-0000-0000-000000000000
Respuesta esperada: 404 Not Found - "Producto con el id ... no fue encontrado"
```

---

## 💡 Tips de Postman

### Guardar variables desde respuestas
Si quieres automatizar, en la pestaña **"Tests"** puedes usar:

```javascript
// Guardar API Key automáticamente
var jsonData = pm.response.json();
pm.collectionVariables.set("api_key", jsonData.apiKey);

// Guardar ID de producto automáticamente
pm.collectionVariables.set("product_id", jsonData.id);
```

### Ver variables guardadas
- Ve a la colección → pestaña "Variables"
- En "Current value" ves el valor actual
- En "Initial value" ves el valor por defecto

### Limpiar variables
- Abre la colección → "Variables"
- Borra los valores de "Current value"
- Presiona "Save"

### Crear nuevas peticiones
- Dentro de una carpeta, haz clic en "Add request"
- Configura el método, URL, headers y body
- Las variables {{api_key}} y {{product_id}} funcionan en cualquier lugar

---

## 🔗 Estructura de la Colección

```
API REST - Productos con API Keys
├── 🔐 AUTENTICACIÓN
│   └── 1. Registrar y obtener API Key
├── 📋 PRODUCTOS - PÚBLICOS
│   ├── 2. GET - Listar todos los productos
│   └── 3. GET - Obtener producto por ID
├── ➕ PRODUCTOS - CREAR (PROTEGIDO)
│   └── 4. POST - Crear producto con imágenes
├── ✏️ PRODUCTOS - ACTUALIZAR (PROTEGIDO)
│   └── 5. PATCH - Actualizar producto
├── 🗑️ PRODUCTOS - ELIMINAR (PROTEGIDO)
│   └── 6. DELETE - Eliminar producto
└── ❌ CASOS DE ERROR
    ├── Error: Sin API Key
    ├── Error: API Key inválida
    ├── Error: DTO Inválido
    └── Error: Producto no encontrado (404)
```

---

## 📊 Ejemplos de Peticiones

### Crear producto
```
POST http://localhost:4000/api/products
Headers:
  Content-Type: application/json
  x-api-key: tu-api-key-aqui

Body:
{
  "title": "Monitor Gaming 4K",
  "price": 799.99,
  "description": "Monitor 4K de 144Hz para gaming",
  "sizes": ["27 pulgadas", "32 pulgadas"],
  "active": true,
  "images": [
    "https://images.unsplash.com/photo-1598327105666-5b89351aff97?w=500"
  ]
}
```

### Actualizar producto
```
PATCH http://localhost:4000/api/products/uuid-del-producto
Headers:
  Content-Type: application/json
  x-api-key: tu-api-key-aqui

Body:
{
  "price": 899.99,
  "title": "Monitor Gaming 4K Ultra"
}
```

### Listar con paginación
```
GET http://localhost:4000/api/products?limit=5&offset=0
```

---

## 🐛 Troubleshooting

### "Cannot read property 'apiKey' of undefined"
**Problema:** El servidor no responde o devuelve error  
**Solución:** Verifica que:
1. El servidor Nest está corriendo: `npm run start:dev`
2. PostgreSQL está corriendo: `docker-compose up -d`

### "Missing API key in x-api-key header"
**Problema:** Olvidaste el header en una petición protegida  
**Solución:** Añade el header:
```
x-api-key: {{api_key}}
```

### "Invalid API key"
**Problema:** La API Key guardada no es válida  
**Solución:** 
1. Genera una nueva en "1. Registrar y obtener API Key"
2. Actualiza la variable {{api_key}}

### URL muestra "localhost:4000" pero no conecta
**Problema:** El servidor no está en puerto 4000  
**Solución:** Verifica `.env`:
```env
PORT=4000
```

---

## ✅ Checklist de Verificación

- [ ] Colección importada en Postman
- [ ] Variables {{api_key}} y {{product_id}} creadas
- [ ] Servidor Nest corriendo (`npm run start:dev`)
- [ ] PostgreSQL corriendo (`docker-compose up -d`)
- [ ] API Key generada desde endpoint de registro
- [ ] Producto creado exitosamente
- [ ] Endpoints públicos accesibles sin API Key
- [ ] Endpoints privados requieren API Key válida
- [ ] Errores manejados correctamente (401, 404, 400)

---

## 📚 Recursos

- [Documentación de Postman](https://learning.postman.com/docs/getting-started/introduction/)
- [Variables en Postman](https://learning.postman.com/docs/sending-requests/variables/)
- [Scripting en Postman (Tests)](https://learning.postman.com/docs/writing-scripts/test-scripts/)
- [Documentación de la API](./TEST_API.md)
- [Guía de Setup completa](./README_SETUP.md)

---

**¡Listo! Ahora puedes probar todos los endpoints desde Postman.** 🎉
