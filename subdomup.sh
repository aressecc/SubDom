#!/bin/bash

# Verificación de dependencias
if ! command -v subfinder &> /dev/null; then
    echo "Error: subfinder no está instalado."
    exit 1
fi

if ! command -v curl &> /dev/null; then
    echo "Error: curl no está instalado."
    exit 1
fi

if ! command -v figlet &> /dev/null; then
    echo "Error: figlet no está instalado."
    exit 1
fi

# Mostrar banner
clear
figlet "CREADO POR ARESSEC"

# Variables de entrada
TARGET="$1"
FILTER_CODE="$2"
SUBDOMAINS_FILE="subdomains.txt"
ACTIVE_HTTP_FILE="http_active.txt"

# Validación de entrada
if [ -z "$TARGET" ] || [ -z "$FILTER_CODE" ]; then
    echo "Uso: $0 <dominio> <codigo_http>"
    echo "Ejemplo: $0 example.com 200"
    exit 1
fi

# Limpiar archivos anteriores si existen
> "$SUBDOMAINS_FILE"
> "$ACTIVE_HTTP_FILE"

echo "[*] Buscando subdominios para: $TARGET"
subfinder -d "$TARGET" -silent > "$SUBDOMAINS_FILE"

echo "[*] Analizando HTTP en subdominios encontrados (filtrando por código $FILTER_CODE)..."

# Procesar cada subdominio
while read -r subdomain; do
    for proto in http https; do
        status_code=$(curl -o /dev/null -s -w "%{http_code}" --max-time 5 "$proto://$subdomain")
        
        if [[ "$status_code" -eq "$FILTER_CODE" ]]; then
            echo "$proto://$subdomain" >> "$ACTIVE_HTTP_FILE"
            echo "[+] Activo ($FILTER_CODE): $proto://$subdomain"
            break
        fi
    done
done < "$SUBDOMAINS_FILE"

echo "[*] Proceso finalizado. Subdominios activos (HTTP $FILTER_CODE) guardados en '$ACTIVE_HTTP_FILE'."
