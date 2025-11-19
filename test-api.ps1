# Script de pruebas automatizadas para la API
# Ejecutar: .\test-api.ps1

$BASE_URL = "http://localhost:4000/api"
$ErrorActionPreference = "Continue"

function Write-Header {
    param([string]$message)
    Write-Host "`n" -ForegroundColor Black
    Write-Host "=== $message ===" -ForegroundColor Cyan
    Write-Host ""
}

function Write-Success {
    param([string]$message)
    Write-Host "✅ $message" -ForegroundColor Green
}

function Write-Error2 {
    param([string]$message)
    Write-Host "❌ $message" -ForegroundColor Red
}

function Convert-Json2 {
    param([string]$json)
    try {
        return $json | ConvertFrom-Json | ConvertTo-Json -Depth 10
    }
    catch {
        return $json
    }
}

# Test 1: Obtener productos (debe estar vacío inicialmente)
Write-Header "TEST 1: GET /api/products (Público - Debe estar vacío)"
try {
    $response = curl -s -X GET "$BASE_URL/products" -H "Content-Type: application/json"
    Write-Success "Respuesta recibida:"
    Write-Host (Convert-Json2 $response) -ForegroundColor Yellow
} catch {
    Write-Error2 "Error en GET /products: $_"
}

# Test 2: Registrar API Key
Write-Header "TEST 2: POST /api/auth/register (Generar API Key)"
try {
    $authResponse = curl -s -X POST "$BASE_URL/auth/register" -H "Content-Type: application/json"
    $authJson = $authResponse | ConvertFrom-Json
    $API_KEY = $authJson.apiKey
    
    if ($API_KEY) {
        Write-Success "API Key generada: $API_KEY"
    } else {
        Write-Error2 "No se pudo generar API Key"
        exit 1
    }
} catch {
    Write-Error2 "Error en POST /auth/register: $_"
    exit 1
}

# Test 3: Intentar crear producto sin API Key (debe fallar)
Write-Header "TEST 3: POST /api/products SIN API Key (Debe fallar con 401)"
try {
    $response = curl -s -X POST "$BASE_URL/products" `
        -H "Content-Type: application/json" `
        -d '{"title":"Test","sizes":[]}'
    
    if ($response -match "Unauthorized" -or $response -match "Missing") {
        Write-Success "Validación correcta: rechazada sin API Key"
        Write-Host (Convert-Json2 $response) -ForegroundColor Yellow
    } else {
        Write-Error2 "La solicitud debería haber sido rechazada"
    }
} catch {
    Write-Error2 "Error inesperado: $_"
}

# Test 4: Crear producto CON API Key válida
Write-Header "TEST 4: POST /api/products CON API Key (Debe crear producto)"
try {
    $createPayload = @{
        title = "Laptop Gaming Premium"
        price = 1299.99
        description = "Laptop de alto rendimiento con RTX 4090"
        sizes = @("15 pulgadas", "17 pulgadas")
        active = $true
        images = @(
            "https://example.com/laptop-front.jpg",
            "https://example.com/laptop-side.jpg"
        )
    } | ConvertTo-Json

    $response = curl -s -X POST "$BASE_URL/products" `
        -H "Content-Type: application/json" `
        -H "x-api-key: $API_KEY" `
        -d $createPayload
    
    $productJson = $response | ConvertFrom-Json
    $PRODUCT_ID = $productJson.id
    
    if ($PRODUCT_ID) {
        Write-Success "Producto creado con ID: $PRODUCT_ID"
        Write-Host (Convert-Json2 $response) -ForegroundColor Yellow
    } else {
        Write-Error2 "No se pudo crear el producto"
        Write-Host (Convert-Json2 $response) -ForegroundColor Yellow
    }
} catch {
    Write-Error2 "Error en POST /products: $_"
}

# Test 5: Listar productos (ahora debe haber uno)
Write-Header "TEST 5: GET /api/products (Público - Debe mostrar 1 producto)"
try {
    $response = curl -s -X GET "$BASE_URL/products" -H "Content-Type: application/json"
    $products = $response | ConvertFrom-Json
    
    Write-Success "Total de productos: $($products.Count)"
    Write-Host (Convert-Json2 $response) -ForegroundColor Yellow
} catch {
    Write-Error2 "Error en GET /products: $_"
}

# Test 6: Obtener producto específico
Write-Header "TEST 6: GET /api/products/:id (Público - Obtener producto específico)"
try {
    if ($PRODUCT_ID) {
        $response = curl -s -X GET "$BASE_URL/products/$PRODUCT_ID" -H "Content-Type: application/json"
        
        if ($response -match $PRODUCT_ID) {
            Write-Success "Producto encontrado"
            Write-Host (Convert-Json2 $response) -ForegroundColor Yellow
        } else {
            Write-Error2 "Producto no encontrado o respuesta inválida"
        }
    } else {
        Write-Error2 "PRODUCT_ID no disponible"
    }
} catch {
    Write-Error2 "Error en GET /products/:id: $_"
}

# Test 7: Actualizar producto
Write-Header "TEST 7: PATCH /api/products/:id (Requiere API Key)"
try {
    if ($PRODUCT_ID) {
        $updatePayload = @{
            title = "Laptop Gaming Ultra Premium"
            price = 1599.99
        } | ConvertTo-Json

        $response = curl -s -X PATCH "$BASE_URL/products/$PRODUCT_ID" `
            -H "Content-Type: application/json" `
            -H "x-api-key: $API_KEY" `
            -d $updatePayload
        
        Write-Success "Producto actualizado"
        Write-Host (Convert-Json2 $response) -ForegroundColor Yellow
    } else {
        Write-Error2 "PRODUCT_ID no disponible"
    }
} catch {
    Write-Error2 "Error en PATCH /products/:id: $_"
}

# Test 8: Eliminar producto
Write-Header "TEST 8: DELETE /api/products/:id (Requiere API Key)"
try {
    if ($PRODUCT_ID) {
        $response = curl -s -X DELETE "$BASE_URL/products/$PRODUCT_ID" `
            -H "x-api-key: $API_KEY"
        
        Write-Success "Producto eliminado"
        Write-Host $response -ForegroundColor Yellow
    } else {
        Write-Error2 "PRODUCT_ID no disponible"
    }
} catch {
    Write-Error2 "Error en DELETE /products/:id: $_"
}

# Test 9: Verificar que producto fue eliminado
Write-Header "TEST 9: GET /api/products (Verificar que está vacío nuevamente)"
try {
    $response = curl -s -X GET "$BASE_URL/products" -H "Content-Type: application/json"
    Write-Success "Respuesta recibida:"
    Write-Host (Convert-Json2 $response) -ForegroundColor Yellow
} catch {
    Write-Error2 "Error: $_"
}

# Test 10: API Key inválida
Write-Header "TEST 10: Usar API Key inválida (Debe fallar con 401)"
try {
    $response = curl -s -X POST "$BASE_URL/products" `
        -H "Content-Type: application/json" `
        -H "x-api-key: invalid-key-12345" `
        -d '{"title":"Test","sizes":[]}'
    
    if ($response -match "Invalid" -or $response -match "Unauthorized") {
        Write-Success "Validación correcta: rechazada con API Key inválida"
        Write-Host (Convert-Json2 $response) -ForegroundColor Yellow
    } else {
        Write-Error2 "La solicitud debería haber sido rechazada"
    }
} catch {
    Write-Error2 "Error: $_"
}

Write-Header "✅ TODAS LAS PRUEBAS COMPLETADAS"
