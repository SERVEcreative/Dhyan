# Creates android/upload-keystore.jks and android/key.properties for Play Store release.
$ErrorActionPreference = "Stop"
$androidDir = Join-Path $PSScriptRoot "..\android" | Resolve-Path
$keystore = Join-Path $androidDir "upload-keystore.jks"
$keyProps = Join-Path $androidDir "key.properties"

if (Test-Path $keystore) {
    Write-Host "Keystore already exists: $keystore"
    exit 0
}

$storePass = Read-Host "Enter keystore password (save this safely!)"
$keyPass = Read-Host "Enter key password (often same as keystore)"
$dname = "CN=Serve Creative, OU=Mobile, O=Serve Creative, L=India, ST=India, C=IN"

keytool -genkeypair -v `
    -keystore $keystore `
    -storetype JKS `
    -alias upload `
    -keyalg RSA `
    -keysize 2048 `
    -validity 10000 `
    -storepass $storePass `
    -keypass $keyPass `
    -dname $dname

@"
storePassword=$storePass
keyPassword=$keyPass
keyAlias=upload
storeFile=../upload-keystore.jks
"@ | Set-Content -Path $keyProps -Encoding UTF8

Write-Host ""
Write-Host "Created: $keystore"
Write-Host "Created: $keyProps (gitignored — back up passwords!)"
Write-Host "Build release AAB: flutter build appbundle --release"
