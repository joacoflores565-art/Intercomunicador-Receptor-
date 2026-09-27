<#
    build-instaladores.ps1
    ------------------------------------------------------------------
    Compila Intercomunicador.java y Receptor.java, y genera un
    instalador .msi para cada uno usando jpackage.

    Cada .msi resultante incluye adentro su propio runtime de Java
    (jpackage lo empaqueta automaticamente), asi que se puede instalar
    en una PC que NO tenga Java instalado. El instalador crea acceso
    directo en el Escritorio y en el Menu Inicio, con su icono.

    REQUISITOS EN ESTA PC (la que genera los instaladores):
      1) JDK 17 o superior, completo (no solo un JRE). Debe incluir
         "javac" y "jpackage". Por ejemplo Eclipse Temurin:
         https://adoptium.net/es/temurin/releases/
      2) WiX Toolset v3.11 instalado, con candle.exe/light.exe en el PATH.
         Descarga: https://wixtoolset.org/releases/
         (jpackage lo necesita para poder construir el .msi)

    La PC del usuario final donde se INSTALE el .msi no necesita nada
    de esto: el instalador ya trae el runtime de Java adentro.

    USO:
      Abrir PowerShell en esta carpeta y ejecutar:
        .\build-instaladores.ps1
      Si Windows bloquea la ejecucion de scripts, usar en su lugar:
        powershell -ExecutionPolicy Bypass -File .\build-instaladores.ps1
------------------------------------------------------------------#>

$ErrorActionPreference = "Stop"

# ----------------- Datos editables del instalador -----------------
$Version = "1.0.0"
$Vendor  = "Intercomunicador"
$GrupoMenuInicio = "Intercomunicador"
# --------------------------------------------------------------------

$Raiz  = $PSScriptRoot
$Build = Join-Path $Raiz "build"
$Dist  = Join-Path $Raiz "dist"

function Salir-ConError($mensaje) {
    Write-Host ""
    Write-Host "ERROR: $mensaje" -ForegroundColor Red
    Write-Host ""
    Read-Host "Presiona Enter para cerrar"
    exit 1
}

Write-Host "== Verificando herramientas ==" -ForegroundColor Cyan

if (-not (Get-Command javac -ErrorAction SilentlyContinue)) {
    Salir-ConError "No se encontro 'javac'. Instala un JDK 17+ completo (por ejemplo Eclipse Temurin, https://adoptium.net) y volve a intentar. Ojo: un JRE no alcanza, hace falta el JDK."
}
if (-not (Get-Command jpackage -ErrorAction SilentlyContinue)) {
    Salir-ConError "No se encontro 'jpackage'. Viene incluido en el JDK 17+ (no en un JRE); revisa tu instalacion."
}
if (-not ((Get-Command candle.exe -ErrorAction SilentlyContinue) -or (Get-Command wix -ErrorAction SilentlyContinue))) {
    Write-Host "AVISO: no se detecto WiX Toolset en el PATH." -ForegroundColor Yellow
    Write-Host "       jpackage lo necesita para armar el .msi. Si el paso de abajo falla," -ForegroundColor Yellow
    Write-Host "       instala WiX 3.11 desde https://wixtoolset.org/releases/ y agregalo al PATH." -ForegroundColor Yellow
}

Write-Host "OK: javac y jpackage disponibles" -ForegroundColor Green
Write-Host ""

if (Test-Path $Build) { Remove-Item $Build -Recurse -Force }
if (Test-Path $Dist)  { Remove-Item $Dist  -Recurse -Force }
New-Item -ItemType Directory -Path $Build | Out-Null
New-Item -ItemType Directory -Path $Dist  | Out-Null

function Compilar-Y-Empaquetar-Jar($NombreClase) {
    $ClasesDir = Join-Path $Build "$NombreClase\classes"
    $JarDir    = Join-Path $Build "$NombreClase\jar"
    New-Item -ItemType Directory -Path $ClasesDir -Force | Out-Null
    New-Item -ItemType Directory -Path $JarDir -Force | Out-Null

    Write-Host "-> Compilando $NombreClase.java..."
    & javac -encoding UTF-8 -d $ClasesDir (Join-Path $Raiz "$NombreClase.java")
    if ($LASTEXITCODE -ne 0) { Salir-ConError "Fallo la compilacion de $NombreClase.java" }

    $JarPath = Join-Path $JarDir "$NombreClase.jar"
    Write-Host "-> Empaquetando $NombreClase.jar..."
    & jar cfe $JarPath $NombreClase -C $ClasesDir .
    if ($LASTEXITCODE -ne 0) { Salir-ConError "Fallo al crear $NombreClase.jar" }

    return $JarDir
}

function Generar-Instalador($NombreApp, $CarpetaJar, $Icono, $Descripcion) {
    Write-Host ""
    Write-Host "-> Generando instalador .msi para $NombreApp..." -ForegroundColor Cyan

    $argumentos = @(
        "--type", "msi",
        "--name", $NombreApp,
        "--input", $CarpetaJar,
        "--main-jar", "$NombreApp.jar",
        "--main-class", $NombreApp,
        "--icon", $Icono,
        "--app-version", $Version,
        "--vendor", $Vendor,
        "--description", $Descripcion,
        "--win-shortcut",
        "--win-menu",
        "--win-menu-group", $GrupoMenuInicio,
        "--dest", $Dist
    )

    & jpackage @argumentos
    if ($LASTEXITCODE -ne 0) {
        Salir-ConError "jpackage fallo generando el instalador de $NombreApp (revisa que WiX este instalado y en el PATH)"
    }
}

$carpetaIntercom = Compilar-Y-Empaquetar-Jar "Intercomunicador"
Generar-Instalador "Intercomunicador" $carpetaIntercom (Join-Path $Raiz "icons\intercomunicador.ico") "Llama al Receptor por la red local"

$carpetaReceptor = Compilar-Y-Empaquetar-Jar "Receptor"
Generar-Instalador "Receptor" $carpetaReceptor (Join-Path $Raiz "icons\receptor.ico") "Sala de espera que recibe llamadas del Intercomunicador"

Write-Host ""
Write-Host "======================================================" -ForegroundColor Green
Write-Host " Listo. Los instaladores quedaron en:" -ForegroundColor Green
Write-Host " $Dist" -ForegroundColor Green
Write-Host "======================================================" -ForegroundColor Green
Write-Host ""
Get-ChildItem $Dist -Filter *.msi | ForEach-Object { Write-Host " - $($_.Name)" }
Write-Host ""
Write-Host "Cada .msi ya incluye el runtime de Java: se puede instalar"
Write-Host "en una PC sin JDK/JRE instalado. Al instalar, se crea el"
Write-Host "acceso directo en el Escritorio y en el Menu Inicio, con su icono."
Write-Host ""
Read-Host "Presiona Enter para cerrar"
