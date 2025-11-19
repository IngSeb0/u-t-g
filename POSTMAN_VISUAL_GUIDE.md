# 📺 GUÍA VISUAL - Paso a Paso en Postman

## Paso 1️⃣: Descargar e Instalar Postman

1. Ve a: https://www.postman.com/downloads/
2. Descarga la versión para tu SO (Windows, Mac, Linux)
3. Instala y abre Postman
4. Crea una cuenta (gratis)

---

## Paso 2️⃣: Importar la Colección

### En Postman:

```
1. Haz clic en "Import" (arriba a la izquierda, azul)
   
2. Se abrirá una ventana con opciones:
   - "Upload Files" <- SELECCIONA ESTA
   
3. Busca y selecciona: "Postman_Collection.json"
   (está en la raíz del proyecto)
   
4. Haz clic en "Import"

5. ¡Listo! Verás la colección en el panel izquierdo
```

**Tu colección debería verse así:**
```
API REST - Productos con API Keys
├── 🔐 AUTENTICACIÓN
├── 📋 PRODUCTOS - PÚBLICOS
├── ➕ PRODUCTOS - CREAR
├── ✏️ PRODUCTOS - ACTUALIZAR
├── 🗑️ PRODUCTOS - ELIMINAR
└── ❌ CASOS DE ERROR
```

---

## Paso 3️⃣: Asegúrate que el Servidor está Corriendo

En PowerShell (en la carpeta del proyecto):

```powershell
# Terminal 1: Levantar PostgreSQL
docker-compose up -d

# Terminal 2: Ejecutar servidor NestJS
npm run start:dev
```

**Espera a ver:**
```
[Nest] ... LOG [NestApplication] Nest application successfully started
```

Servidor en: `http://localhost:4000/api`

---

## Paso 4️⃣: Generar API Key

### En Postman:

```
1. Panel izquierdo:
   Expande "🔐 AUTENTICACIÓN"
   
2. Haz clic en:
   "1. Registrar y obtener API Key"
   
3. Verás la petición en el panel central:
   - Método: POST
   - URL: http://localhost:4000/api/auth/register
   - Headers: Content-Type: application/json
   - Body: (vacío - no necesita)

4. Haz clic en "Send" (azul, arriba a la derecha)

5. Abajo verás la respuesta (Response):
   {
     "apiKey": "550e8400-e29b-41d4-a716-446655440000"
   }

6. IMPORTANTE: Copia este valor
```

---

## Paso 5️⃣: Guardar la API Key como Variable

### En Postman:

```
1. Panel izquierdo:
   Haz clic en la colección "API REST - Productos..."
   
2. Arriba a la derecha, verás pestañas:
   [Details] [Authorization] [Pre-request Script] [Tests] [Variables]
   
3. Haz clic en "Variables"

4. Verás una tabla con dos variables:
   - api_key (Current value: vacío)
   - product_id (Current value: vacío)

5. En la fila "api_key":
   - Current value: Pega aquí el UUID que copiaste
   - Ejemplo: 550e8400-e29b-41d4-a716-446655440000

6. Haz clic en "Save" (arriba)

7. ¡Listo! Ahora {{api_key}} funcionará en todas las peticiones
```

---

## Paso 6️⃣: Crear un Producto

### En Postman:

```
1. Panel izquierdo:
   Expande "➕ PRODUCTOS - CREAR (PROTEGIDO)"
   
2. Haz clic en:
   "4. POST - Crear producto con imágenes"

3. Verás la petición con:
   - Método: POST
   - URL: http://localhost:4000/api/products
   - Headers: 
     * Content-Type: application/json
     * x-api-key: {{api_key}}  <- Postman reemplaza esto
   - Body: JSON con los datos del producto

4. OPCIONAL: Personaliza el Body (pestaña Body)
   Puedes cambiar título, precio, descripción, etc.

5. Haz clic en "Send"

6. Respuesta esperada (Status 201 Created):
   {
     "id": "26b071e4-75f9-4897-bec8-0591804360e9",
     "title": "LAPTOP GAMING RTX 4090",
     "price": 1999.99,
     ...
   }

7. IMPORTANTE: Copia el "id" de la respuesta
```

---

## Paso 7️⃣: Guardar el ID del Producto

### En Postman:

```
1. Panel izquierdo:
   Haz clic en la colección "API REST - Productos..."
   
2. Pestaña "Variables"

3. En la fila "product_id":
   - Current value: Pega el ID que copiaste
   - Ejemplo: 26b071e4-75f9-4897-bec8-0591804360e9

4. Haz clic en "Save"

5. ¡Listo! Ahora {{product_id}} funcionará en todas las peticiones
```

---

## Paso 8️⃣: Obtener Producto por ID

### En Postman:

```
1. Panel izquierdo:
   Expande "📋 PRODUCTOS - PÚBLICOS"
   
2. Haz clic en:
   "3. GET - Obtener producto por ID"

3. Verás:
   - Método: GET
   - URL: http://localhost:4000/api/products/{{product_id}}
   
4. Postman reemplaza {{product_id}} con el ID guardado

5. Haz clic en "Send"

6. Respuesta esperada (Status 200 OK):
   {
     "id": "26b071e4-75f9-4897-bec8-0591804360e9",
     "title": "LAPTOP GAMING RTX 4090",
     "price": 1999.99,
     "description": "...",
     "sizes": ["15 pulgadas", "17 pulgadas"],
     "active": true,
     "images": [
       { "id": "...", "url": "https://..." },
       { "id": "...", "url": "https://..." }
     ]
   }

7. ¡El producto se devuelve con sus imágenes!
```

---

## Paso 9️⃣: Actualizar Producto

### En Postman:

```
1. Panel izquierdo:
   Expande "✏️ PRODUCTOS - ACTUALIZAR (PROTEGIDO)"
   
2. Haz clic en:
   "5. PATCH - Actualizar producto"

3. Verás:
   - Método: PATCH
   - URL: http://localhost:4000/api/products/{{product_id}}
   - Headers: x-api-key: {{api_key}}
   - Body: JSON con campos a actualizar

4. Cambia los valores en Body, ejemplo:
   {
     "title": "Laptop Gaming Ultra Pro RTX 4090",
     "price": 2299.99
   }

5. Haz clic en "Send"

6. Respuesta esperada (Status 200 OK):
   El producto actualizado con los nuevos valores
```

---

## Paso 🔟: Listar Productos

### En Postman:

```
1. Panel izquierdo:
   Expande "📋 PRODUCTOS - PÚBLICOS"
   
2. Haz clic en:
   "2. GET - Listar todos los productos"

3. Verás:
   - Método: GET
   - URL: http://localhost:4000/api/products
   
4. OPCIONAL - Usar paginación:
   Modifica la URL a:
   http://localhost:4000/api/products?limit=5&offset=0
   
   Significa: Obtén 5 productos, saltando los primeros 0

5. Haz clic en "Send"

6. Respuesta esperada (Status 200 OK):
   Array con todos los productos:
   [
     {
       "id": "...",
       "title": "LAPTOP GAMING RTX 4090",
       ...
     }
   ]
```

---

## Paso 1️⃣1️⃣: Eliminar Producto

### En Postman:

```
1. Panel izquierdo:
   Expande "🗑️ PRODUCTOS - ELIMINAR (PROTEGIDO)"
   
2. Haz clic en:
   "6. DELETE - Eliminar producto"

3. Verás:
   - Método: DELETE
   - URL: http://localhost:4000/api/products/{{product_id}}
   - Headers: x-api-key: {{api_key}}

4. Haz clic en "Send"

5. Respuesta esperada (Status 200 OK):
   {}

6. ¡El producto ha sido eliminado!
```

---

## Paso 1️⃣2️⃣: Probar Casos de Error

### Error 1: Sin API Key

```
1. Panel izquierdo:
   Expande "❌ CASOS DE ERROR"
   
2. Haz clic en:
   "Error: Sin API Key"

3. Verás que NO hay el header "x-api-key"

4. Haz clic en "Send"

5. Respuesta esperada (Status 401 Unauthorized):
   {
     "message": "Missing API key in x-api-key header",
     "error": "Unauthorized",
     "statusCode": 401
   }
```

### Error 2: API Key Inválida

```
1. En "❌ CASOS DE ERROR":
   Haz clic en "Error: API Key inválida"

2. Verás el header con: x-api-key: invalid-key-12345

3. Haz clic en "Send"

4. Respuesta esperada (Status 401 Unauthorized):
   {
     "message": "Invalid API key",
     "error": "Unauthorized",
     "statusCode": 401
   }
```

### Error 3: Datos Inválidos

```
1. En "❌ CASOS DE ERROR":
   Haz clic en "Error: DTO Inválido (Validación fallida)"

2. Body contiene datos incorrectos:
   - title: "" (vacío)
   - price: -100 (negativo)
   - sizes: "invalid" (no es array)

3. Haz clic en "Send"

4. Respuesta esperada (Status 400 Bad Request):
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

### Error 4: Producto No Encontrado

```
1. En "❌ CASOS DE ERROR":
   Haz clic en "Error: Producto no encontrado (404)"

2. URL es: http://localhost:4000/api/products/00000000-0000-0000-0000-000000000000
   (ID que no existe)

3. Haz clic en "Send"

4. Respuesta esperada (Status 404 Not Found):
   {
     "message": "Producto con el id ... no fue encontrado",
     "error": "Not Found",
     "statusCode": 404
   }
```

---

## 🎯 Resumen del Flujo Completo

```
1. Generar API Key          → POST /auth/register
2. Listar productos         → GET /products (debe estar vacío)
3. Crear producto           → POST /products (necesita API Key)
4. Obtener ese producto     → GET /products/:id
5. Actualizar producto      → PATCH /products/:id (necesita API Key)
6. Listar nuevamente        → GET /products (debe tener 1)
7. Eliminar producto        → DELETE /products/:id (necesita API Key)
8. Listar nuevamente        → GET /products (debe estar vacío)
```

---

## 💡 Tips Útiles en Postman

### Ver la respuesta formateada
```
En el panel de respuesta (abajo), haz clic en "Pretty" (JSON formateado)
```

### Copiar valor de respuesta a variable
```
1. Haz clic derecho en el valor de la respuesta
2. Selecciona "Set as variable"
3. Elige la variable (api_key o product_id)
```

### Cambiar el Color de la carpeta
```
1. Haz clic derecho en la carpeta
2. "Edit" -> elige un color
```

### Duplicar una petición
```
1. Haz clic derecho en la petición
2. "Duplicate request"
3. Modifica según necesites
```

### Historial de peticiones
```
En el panel izquierdo, hay una pestaña "History"
Ves todas las peticiones que ejecutaste
```

---

## ✅ Checklist Final

- [ ] Postman instalado
- [ ] Colección importada
- [ ] API Key generada y guardada en variable
- [ ] Docker corriendo (docker-compose up -d)
- [ ] Servidor Nest corriendo (npm run start:dev)
- [ ] Producto creado exitosamente
- [ ] Producto obtenido por ID
- [ ] Producto actualizado
- [ ] Producto eliminado
- [ ] Errores validados (401, 404, 400)
- [ ] Documentación leída

---

## 🎉 ¡LISTO!

Ahora tienes una **API REST completamente funcional** y puedes:

✅ Crear, leer, actualizar y eliminar productos  
✅ Adjuntar múltiples imágenes a productos  
✅ Controlar acceso con API Keys  
✅ Testear todos los casos de error  
✅ Ver la documentación en Swagger  

---

## 📞 Ayuda Rápida

| Problema | Solución |
|----------|----------|
| "Cannot reach localhost:4000" | Ejecuta `npm run start:dev` |
| "API Key inválida" | Regenera desde POST /auth/register |
| "Producto no encontrado" | Verifica que el ID es correcto |
| "Missing header" | Asegúrate que x-api-key está en headers |

---

**¡Diviértete probando la API!** 🚀
