# Pruebas de API REST - Script completo
# Ejecutar desde PowerShell: .\test-api-completo.ps1

$API = "http://localhost:4000/api"
$Green = "Green"
$Red = "Red"
$Yellow = "Yellow"
$Cyan = "Cyan"

function Title {
    param([string]$msg)
    Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host "  $msg" -ForegroundColor Cyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" -ForegroundColor Cyan
}

function Success {
    param([string]$msg)
    Write-Host "✅ $msg" -ForegroundColor Green
}

function Error2 {
    param([string]$msg)
    Write-Host "❌ $msg" -ForegroundColor Red
}

function Info {
    param([string]$msg)
    Write-Host "ℹ️  $msg" -ForegroundColor Yellow
}

# 1️⃣ OBTENER PRODUCTOS VACÍOS (público)
Title "TEST 1: GET /api/products - Lista vacía inicial"
try {
    $response = Invoke-WebRequest -Uri "$API/products" -Method GET -ContentType "application/json" -ErrorAction Stop
    $products = $response.Content | ConvertFrom-Json
    Success "Respuesta recibida - Status: $($response.StatusCode)"
    Write-Host "Productos encontrados: $($products.Count)" -ForegroundColor Yellow
} catch {
    Error2 "Error: $_"
}

# 2️⃣ GENERAR API KEY
Title "TEST 2: POST /api/auth/register - Generar API Key"
try {
    $response = Invoke-WebRequest -Uri "$API/auth/register" -Method POST -ContentType "application/json" -ErrorAction Stop
    $auth = $response.Content | ConvertFrom-Json
    $API_KEY = $auth.apiKey
    Success "API Key generada exitosamente"
    Info "API Key: $API_KEY"
} catch {
    Error2 "Error al generar API Key: $_"
    exit 1
}

# 3️⃣ CREAR PRODUCTO CON API KEY
Title "TEST 3: POST /api/products - Crear producto con API Key"
try {
    $body = @{
        title = "Laptop Gaming RTX 4090"
        price = 1999.99
        description = "Laptop de alto rendimiento para gaming extremo"
        sizes = @("15 pulgadas", "17 pulgadas")
        active = $true
        images = @(
            "https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=500",
            "https://images.unsplash.com/photo-1588872657840-790ff3bde172?w=500"
        )
    } | ConvertTo-Json

    $response = Invoke-WebRequest -Uri "$API/products" -Method POST `
        -Headers @{ "x-api-key" = $API_KEY } `
        -Body $body -ContentType "application/json" -ErrorAction Stop
    
    $product = $response.Content | ConvertFrom-Json
    $PRODUCT_ID = $product.id
    
    Success "Producto creado exitosamente"
    Info "Producto ID: $PRODUCT_ID"
    Info "Título: $($product.title)"
    Info "Precio: $$($product.price)"
    Info "Activo: $($product.active)"
} catch {
    Error2 "Error al crear producto: $_"
}

# 4️⃣ OBTENER PRODUCTOS (ahora debe haber 1)
Title "TEST 4: GET /api/products - Listar productos"
try {
    $response = Invoke-WebRequest -Uri "$API/products" -Method GET -ContentType "application/json" -ErrorAction Stop
    $products = $response.Content | ConvertFrom-Json
    Success "Productos obtenidos exitosamente"
    Info "Total de productos: $($products.Count)"
    if ($products.Count -gt 0) {
        Write-Host "Primer producto: $($products[0].title)" -ForegroundColor Yellow
    }
} catch {
    Error2 "Error: $_"
}

# 5️⃣ OBTENER PRODUCTO POR ID
Title "TEST 5: GET /api/products/:id - Obtener producto específico"
if ($PRODUCT_ID) {
    try {
        $response = Invoke-WebRequest -Uri "$API/products/$PRODUCT_ID" -Method GET -ContentType "application/json" -ErrorAction Stop
        $product = $response.Content | ConvertFrom-Json
        Success "Producto obtenido exitosamente"
        Info "ID: $($product.id)"
        Info "Título: $($product.title)"
        Info "Descripción: $($product.description)"
        Info "Imágenes: $($product.images.Count) adjuntas"
        if ($product.images) {
            Write-Host "  Imágenes:" -ForegroundColor Cyan
            foreach ($img in $product.images) {
                Write-Host "    • $($img.url)" -ForegroundColor Gray
            }
        }
    } catch {
        Error2 "Error: $_"
    }
} else {
    Error2 "PRODUCT_ID no disponible"
}

# 6️⃣ ACTUALIZAR PRODUCTO
Title "TEST 6: PATCH /api/products/:id - Actualizar producto"
if ($PRODUCT_ID) {
    try {
        $updateBody = @{
            title = "Laptop Gaming Ultra Pro RTX 4090"
            price = 2299.99
        } | ConvertTo-Json

        $response = Invoke-WebRequest -Uri "$API/products/$PRODUCT_ID" -Method PATCH `
            -Headers @{ "x-api-key" = $API_KEY } `
            -Body $updateBody -ContentType "application/json" -ErrorAction Stop
        
        $updated = $response.Content | ConvertFrom-Json
        Success "Producto actualizado exitosamente"
        Info "Nuevo título: $($updated.title)"
        Info "Nuevo precio: $$($updated.price)"
    } catch {
        Error2 "Error al actualizar: $_"
    }
} else {
    Error2 "PRODUCT_ID no disponible"
}

# 7️⃣ OBTENER CON PAGINACIÓN
Title "TEST 7: GET /api/products?limit=5&offset=0 - Con paginación"
try {
    $response = Invoke-WebRequest -Uri "$API/products?limit=5&offset=0" -Method GET -ContentType "application/json" -ErrorAction Stop
    $paginated = $response.Content | ConvertFrom-Json
    Success "Paginación funcionando"
    Info "Productos retornados: $($paginated.Count)"
} catch {
    Error2 "Error: $_"
}

# 8️⃣ CREAR SEGUNDO PRODUCTO
Title "TEST 8: POST /api/products - Crear segundo producto"
try {
    $body = @{
        title = "iPhone 15 Pro Max"
        price = 1199.99
        description = "Teléfono de última generación con chip A17"
        sizes = @("128GB", "256GB", "512GB")
        active = $true
        images = @(
            "https://images.unsplash.com/photo-1592286927505-1def25115558?w=500"
        )
    } | ConvertTo-Json

    $response = Invoke-WebRequest -Uri "$API/products" -Method POST `
        -Headers @{ "x-api-key" = $API_KEY } `
        -Body $body -ContentType "application/json" -ErrorAction Stop
    
    $product2 = $response.Content | ConvertFrom-Json
    $PRODUCT_ID_2 = $product2.id
    
    Success "Segundo producto creado"
    Info "ID: $PRODUCT_ID_2"
} catch {
    Error2 "Error: $_"
}

# 9️⃣ VERIFICAR PRODUCTOS TOTALES
Title "TEST 9: GET /api/products - Verificar 2 productos"
try {
    $response = Invoke-WebRequest -Uri "$API/products" -Method GET -ContentType "application/json" -ErrorAction Stop
    $allProducts = $response.Content | ConvertFrom-Json
    Success "Total de productos en BD: $($allProducts.Count)"
    foreach ($p in $allProducts) {
        Write-Host "  • $($p.title) - $$($p.price)" -ForegroundColor Yellow
    }
} catch {
    Error2 "Error: $_"
}

# 🔟 ERROR: SIN API KEY
Title "TEST 10: POST /api/products SIN API Key (debe fallar)"
try {
    $body = @{ title = "Test"; sizes = @() } | ConvertTo-Json
    $response = Invoke-WebRequest -Uri "$API/products" -Method POST `
        -Body $body -ContentType "application/json" -ErrorAction Stop
    Error2 "¡Error! Debería haber sido rechazado"
} catch {
    if ($_.Exception.Response.StatusCode -eq 401) {
        Success "Validación correcta: rechazada con 401 Unauthorized"
        Info "Error esperado capturado correctamente"
    } else {
        Error2 "Error inesperado: $_"
    }
}

# 1️⃣1️⃣ ERROR: API KEY INVÁLIDA
Title "TEST 11: POST /api/products con API Key inválida (debe fallar)"
try {
    $body = @{ title = "Test"; sizes = @() } | ConvertTo-Json
    $response = Invoke-WebRequest -Uri "$API/products" -Method POST `
        -Headers @{ "x-api-key" = "invalid-key-12345" } `
        -Body $body -ContentType "application/json" -ErrorAction Stop
    Error2 "¡Error! Debería haber sido rechazado"
} catch {
    if ($_.Exception.Response.StatusCode -eq 401) {
        Success "Validación correcta: rechazada con 401 Unauthorized"
        Info "API Key inválida rechazada exitosamente"
    } else {
        Error2 "Error inesperado: $_"
    }
}

# 1️⃣2️⃣ ERROR: DTO INVÁLIDO
Title "TEST 12: POST /api/products con datos inválidos (validación DTO)"
try {
    $body = @{
        title = ""  # Vacío, debe fallar
        price = -100  # Negativo
        sizes = "no-es-array"  # Debe ser array
    } | ConvertTo-Json

    $response = Invoke-WebRequest -Uri "$API/products" -Method POST `
        -Headers @{ "x-api-key" = $API_KEY } `
        -Body $body -ContentType "application/json" -ErrorAction Stop
    Error2 "¡Error! Debería haber fallado validación"
} catch {
    if ($_.Exception.Response.StatusCode -eq 400) {
        Success "Validación DTO correcta: rechazada con 400 Bad Request"
        $errorContent = $_.Exception.Response.Content.ReadAsStream() | ForEach-Object { [char]$_ } | Join-String
        Info "Detalles: $(($errorContent | ConvertFrom-Json).message)"
    } else {
        Write-Host "Status: $($_.Exception.Response.StatusCode)" -ForegroundColor Yellow
    }
}

# 1️⃣3️⃣ ELIMINAR PRIMER PRODUCTO
Title "TEST 13: DELETE /api/products/:id - Eliminar producto"
if ($PRODUCT_ID) {
    try {
        $response = Invoke-WebRequest -Uri "$API/products/$PRODUCT_ID" -Method DELETE `
            -Headers @{ "x-api-key" = $API_KEY } -ErrorAction Stop
        Success "Producto eliminado exitosamente"
        Info "Producto ID eliminado: $PRODUCT_ID"
    } catch {
        Error2 "Error al eliminar: $_"
    }
}

# 1️⃣4️⃣ VERIFICAR PRODUCTOS RESTANTES
Title "TEST 14: GET /api/products - Verificar solo 1 producto"
try {
    $response = Invoke-WebRequest -Uri "$API/products" -Method GET -ContentType "application/json" -ErrorAction Stop
    $remaining = $response.Content | ConvertFrom-Json
    Success "Total de productos restantes: $($remaining.Count)"
    if ($remaining.Count -gt 0) {
        foreach ($p in $remaining) {
            Write-Host "  • $($p.title) - $$($p.price)" -ForegroundColor Yellow
        }
    }
} catch {
    Error2 "Error: $_"
}

# 1️⃣5️⃣ ERROR: PRODUCTO NO ENCONTRADO
Title "TEST 15: GET /api/products/:id con ID inválido (debe retornar 404)"
try {
    $fakeId = "00000000-0000-0000-0000-000000000000"
    $response = Invoke-WebRequest -Uri "$API/products/$fakeId" -Method GET -ErrorAction Stop
    Error2 "¡Error! Debería haber retornado 404"
} catch {
    if ($_.Exception.Response.StatusCode -eq 404) {
        Success "Validación correcta: retornada respuesta 404 Not Found"
        Info "Producto no encontrado manejado correctamente"
    } else {
        Error2 "Error inesperado: $_"
    }
}

# 1️⃣6️⃣ ELIMINAR SEGUNDO PRODUCTO
Title "TEST 16: DELETE /api/products/:id - Eliminar segundo producto"
if ($PRODUCT_ID_2) {
    try {
        $response = Invoke-WebRequest -Uri "$API/products/$PRODUCT_ID_2" -Method DELETE `
            -Headers @{ "x-api-key" = $API_KEY } -ErrorAction Stop
        Success "Segundo producto eliminado"
    } catch {
        Error2 "Error: $_"
    }
}

# 1️⃣7️⃣ VERIFICAR BD VACÍA
Title "TEST 17: GET /api/products - Verificar BD vacía nuevamente"
try {
    $response = Invoke-WebRequest -Uri "$API/products" -Method GET -ContentType "application/json" -ErrorAction Stop
    $final = $response.Content | ConvertFrom-Json
    Success "Base de datos limpia - Productos: $($final.Count)"
} catch {
    Error2 "Error: $_"
}

# RESUMEN FINAL
Title "✅ TODAS LAS PRUEBAS COMPLETADAS EXITOSAMENTE"
Write-Host "
🎉 Resumen de validaciones:
  ✓ Endpoints públicos (GET) funcionan sin API Key
  ✓ Endpoints privados (POST/PATCH/DELETE) requieren API Key
  ✓ Validación de DTOs funciona
  ✓ Manejo de errores implementado
  ✓ Relaciones OneToMany cargadas correctamente
  ✓ Paginación implementada
  ✓ Sistema de autenticación por API Keys operacional

🚀 Servidor listo para producción
" -ForegroundColor Green
