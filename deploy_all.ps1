# -------------------------------------------------
# deploy_all.ps1 – despliegue completo del proyecto
# -------------------------------------------------
# 1️⃣  Añadir la carpeta global de npm al PATH (persistente)
$npmGlobal = "$env:APPDATA\npm"                         # C:\Users\Sena\AppData\Roaming\npm
# Añadir al PATH del usuario (lo guarda en el registro de Windows)
[Environment]::SetEnvironmentVariable(
    "Path",
    [Environment]::GetEnvironmentVariable("Path","User") + ";$npmGlobal",
    "User"
)
# Refrescar la variable en la sesión actual
$env:Path = $env:Path + ";$npmGlobal"

# -------------------------------------------------
# 2️⃣  Backend – Railway
# -------------------------------------------------
Write-Host "`n=== Deploying Backend to Railway ===" -ForegroundColor Cyan

# Asegurarse de que la CLI está disponible
if (-not (Test-Path "$npmGlobal\railway.cmd")) {
    Write-Error "Railway CLI no está disponible. Instálala con: npm i -g @railway/cli"
    exit 1
}

# Si el proyecto aún no está enlazado, inicializarlo (solo la primera vez)
if (-not (Test-Path ".\Railway.toml")) {
    Write-Host "Inicializando proyecto Railway..."
    & "$npmGlobal\railway.cmd" init --service node --path ./node
}

# Deploy
& "$npmGlobal\railway.cmd" up
if ($LASTEXITCODE -ne 0) {
    Write-Error "Fallo al desplegar en Railway."
    exit $LASTEXITCODE
}

# -------------------------------------------------
# 3️⃣  Frontend – Vercel
# -------------------------------------------------
Write-Host "`n=== Deploying Frontend to Vercel ===" -ForegroundColor Cyan

# Entrar al directorio del frontend (asumiendo que está bajo ./frontend)
$frontendPath = Join-Path $PSScriptRoot "frontend"
if (-not (Test-Path $frontendPath)) {
    Write-Error "Directorio frontend no encontrado en $frontendPath"
    exit 1
}
Set-Location $frontendPath

# Instalar dependencias (solo la primera vez)
if (-not (Test-Path "node_modules")) {
    npm ci
}

# Build
npm run build

# Subir a Vercel
& "$npmGlobal\vercel.cmd" --prod --yes

# Mostrar status final
Write-Host "`n=== URLs de despliegue ===" -ForegroundColor Cyan
& "$npmGlobal\railway.cmd" status
Write-Host "`nFrontend Vercel:"
& "$npmGlobal\vercel.cmd" ls
