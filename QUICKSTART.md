# ⚡ QUICK START - 5 Minutos

## Antes de comenzar

✅ Docker instalado  
✅ Node.js v18+  
✅ Postman descargado

---

## 1. Iniciar Base de Datos (30 seg)

```powershell
docker-compose up -d
```

Espera a que aparezca: `✔ Container dev-estudio Started`

---

## 2. Instalar Dependencias (1 min)

```powershell
npm install
```

---

## 3. Iniciar Servidor (1 min)

```powershell
npm run start:dev
```

Espera a: `Nest application successfully started`

---

## 4. Importar en Postman (1 min)

1. Postman → "Import"
2. Elige: `Postman_Collection.json`
3. ¡Listo!

---

## 5. Hacer Primera Petición (1 min)

1. **Panel izquierdo → "1. Registrar y obtener API Key"**
2. **"Send"** (botón azul)
3. **Copia el `apiKey` de la respuesta**
4. **Colección → Variables → Pega en `api_key`**

---

## ¡LISTO! 🎉

Ahora puedes:

```
✅ POST /api/products         → Crear producto (usa API Key)
✅ GET /api/products          → Listar productos
✅ GET /api/products/:id      → Obtener uno
✅ PATCH /api/products/:id    → Actualizar (usa API Key)
✅ DELETE /api/products/:id   → Eliminar (usa API Key)
```

---

## URLs Importantes

```
🌐 Servidor:     http://localhost:4000
📚 Swagger:      http://localhost:4000/api
🔗 API Base:     http://localhost:4000/api
```

---

## Próximas Guías

Después de esto, lee:

1. **POSTMAN_VISUAL_GUIDE.md** - Paso a paso con imágenes
2. **TEST_API.md** - Ejemplos de cURL
3. **README_SETUP.md** - Setup completo
4. **SUMMARY.md** - Resumen técnico

---

**¡Ahora a probar!** 🚀
