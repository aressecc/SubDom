#!/bin/bash

# Verificación de dependencias
for cmd in subfinder curl figlet; do
    if ! command -v $cmd &> /dev/null; then
        echo -e "\e[31m[ERROR]\e[0m $cmd no está instalado."
        exit 1
    fi
done

# Mostrar banner en azul
clear
echo -e "\e[34m$(figlet 'CREADO POR ARESSEC')\e[0m"

# Variables de entrada
TARGET="$1"
FILTER_CODE="$2"
NO_PROTOCOL="$3"
SUBDOMAINS_FILE="subdomains.txt"
ACTIVE_HTTP_FILE="http_active.txt"

# Validación de entrada
if [ -z "$TARGET" ] || [ -z "$FILTER_CODE" ]; then
    echo -e "\e[33mUso:\e[0m $0 <dominio> <codigo_http> [--no-protocol]"
    echo "Ejemplo:"
    echo "  $0 example.com 200"
    echo "  $0 example.com 200 --no-protocol"
    exit 1
fi

# Limpiar archivos anteriores si existen
> "$SUBDOMAINS_FILE"
> "$ACTIVE_HTTP_FILE"

echo -e "\e[36m[*]\e[0m Buscando subdominios para: $TARGET"
subfinder -d "$TARGET" -silent > "$SUBDOMAINS_FILE"

echo -e "\e[36m[*]\e[0m Analizando HTTP en subdominios encontrados (filtrando por código $FILTER_CODE)..."

# Procesar cada subdominio
while read -r subdomain; do
    for proto in http https; do
        status_code=$(curl -o /dev/null -s -w "%{http_code}" --max-time 5 "$proto://$subdomain")
        
        if [[ "$status_code" -eq "$FILTER_CODE" ]]; then
            if [[ "$NO_PROTOCOL" == "--no-protocol" ]]; then
                echo "$subdomain" >> "$ACTIVE_HTTP_FILE"
                echo -e "\e[32m[+]\e[0m Activo ($FILTER_CODE): $subdomain"
            else
                echo "$proto://$subdomain" >> "$ACTIVE_HTTP_FILE"
                echo -e "\e[32m[+]\e[0m Activo ($FILTER_CODE): $proto://$subdomain"
            fi
            break
        fi
    done
done < "$SUBDOMAINS_FILE"

echo -e "\e[36m[*]\e[0m Proceso finalizado. Subdominios activos (HTTP $FILTER_CODE) guardados en \e[1m$ACTIVE_HTTP_FILE\e[0m."
