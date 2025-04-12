#!/bin/bash

# Función que maneja el Ctrl+C (SIGINT)
handle_interrupt() {
    echo -e "\n\e[33m[!]\e[0m Interrumpido. ¿Quieres pausar, cambiar el código de estado, o guardar los resultados?"
    read -p $'\e[35mElige una opción (pausar/cambiar/tomar): \e[0m' opcion;
    if [[ "$opcion" =~ ^[Pp]ausar$ ]]; then
        echo -e "\e[36m[*]\e[0m Pausado. Puedes reanudar el script cuando desees.";
        read -p $'\e[35mPresiona [Enter] para continuar... \e[0m';
    elif [[ "$opcion" =~ ^[Cc]ambiar$ ]]; then
        read -p $'\e[35mIngresa el nuevo código de estado HTTP a filtrar: \e[0m' nuevo_codigo;
        FILTER_CODE="$nuevo_codigo";
        echo -e "\e[36m[*]\e[0m Filtrando con el nuevo código: $FILTER_CODE";
    elif [[ "$opcion" =~ ^[Tt]omar$ ]]; then
        echo -e "\e[36m[*]\e[0m Guardando subdominios encontrados hasta ahora...";
        cp "$SUBDOMAINS_FILE" "$DOMAIN_DIR/subdominios_parciales.txt";
        echo -e "\e[32m[✔]\e[0m Subdominios guardados en \e[1m$DOMAIN_DIR/subdominios_parciales.txt\e[0m";
    else
        echo -e "\e[31m[ERROR]\e[0m Opción no válida. El script continuará normalmente.";
    fi
}

# Captura de la señal SIGINT (Ctrl+C)
trap handle_interrupt SIGINT

# Función para imprimir mensajes en modo verbose
verbose() {
    if [[ "$VERBOSE" == true ]]; then
        echo -e "$1"
    fi
}

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
VERBOSE=false

# Procesar las opciones
while getopts ":v" opt; do
    case $opt in
        v)
            VERBOSE=true
            verbose "\e[36m[*]\e[0m Modo verbose activado."
            ;;
        \?)
            echo -e "\e[31m[ERROR]\e[0m Opción no válida: -$OPTARG" >&2
            exit 1
            ;;
    esac
done
shift $((OPTIND - 1))

# Validación de entrada
if [ -z "$TARGET" ] || [ -z "$FILTER_CODE" ]; then
    echo -e "\e[33mUso:\e[0m $0 <dominio> <codigo_http> [--no-protocol]"
    echo "Ejemplo:"
    echo "  $0 example.com 200"
    echo "  $0 example.com 200 --no-protocol"
    exit 1
fi

# Crear carpeta para el dominio
DOMAIN_DIR="${TARGET//http:\/\//}"
DOMAIN_DIR="${DOMAIN_DIR//https:\/\//}"
DOMAIN_DIR="${DOMAIN_DIR//\//}"
mkdir -p "$DOMAIN_DIR"

# Archivos con ruta completa
SUBDOMAINS_FILE="$DOMAIN_DIR/subdomains.txt"
ACTIVE_HTTP_FILE="$DOMAIN_DIR/http_active.txt"

# Limpiar archivos anteriores si existen
> "$SUBDOMAINS_FILE"
> "$ACTIVE_HTTP_FILE"

verbose "\e[36m[*]\e[0m Buscando subdominios para: $TARGET"
if $VERBOSE; then
    subfinder -d "$TARGET" -silent -v > "$SUBDOMAINS_FILE"
else
    subfinder -d "$TARGET" -silent > "$SUBDOMAINS_FILE"
fi

verbose "\e[36m[*]\e[0m Analizando HTTP en subdominios encontrados (filtrando por código $FILTER_CODE)..."

# Procesar cada subdominio
while read -r subdomain; do
    for proto in http https; do
        status_code=$(curl -o /dev/null -s -w "%{http_code}" --max-time 5 "$proto://$subdomain")
        
        if [[ "$status_code" -eq "$FILTER_CODE" ]]; then
            if [[ "$NO_PROTOCOL" == "--no-protocol" ]]; then
                echo "$subdomain" >> "$ACTIVE_HTTP_FILE"
                verbose "\e[32m[+]\e[0m Activo ($FILTER_CODE): $subdomain"
            else
                echo "$proto://$subdomain" >> "$ACTIVE_HTTP_FILE"
                verbose "\e[32m[+]\e[0m Activo ($FILTER_CODE): $proto://$subdomain"
            fi
            break
        fi
    done
done < "$SUBDOMAINS_FILE"

verbose "\e[36m[*]\e[0m Proceso finalizado. Subdominios activos (HTTP $FILTER_CODE) guardados en \e[1m$ACTIVE_HTTP_FILE\e[0m."

# Preguntar si se desea usar nuclei
read -p $'\e[35m¿Deseas ejecutar nuclei? (s/n): \e[0m' use_nuclei
if [[ "$use_nuclei" =~ ^[Ss]$ ]]; then
    if ! command -v nuclei &> /dev/null; then
        echo -e "\e[31m[ERROR]\e[0m nuclei no está instalado. Instálalo con:"
        echo "  go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest"
        exit 1
    fi

    echo -e "\e[36m[1]\e[0m Ejecutar nuclei para un solo host/url"
    echo -e "\e[36m[2]\e[0m Ejecutar nuclei para TODOS los activos"
    echo -e "\e[36m[3]\e[0m Cancelar"

    read -p $'\e[35mElige una opción (1/2/3): \e[0m' opcion

    case "$opcion" in
        1)
            read -p $'\e[35mIngresa el host o URL a analizar con nuclei: \e[0m' nuc_url
            verbose "\e[36m[*]\e[0m Ejecutando nuclei para: \e[1m$nuc_url\e[0m"
            if $VERBOSE; then
                output=$(nuclei -u "$nuc_url" -v)
            else
                output=$(nuclei -u "$nuc_url")
            fi
            ;;
        2)
            verbose "\e[36m[*]\e[0m Ejecutando nuclei para todos los activos en $ACTIVE_HTTP_FILE..."
            if $VERBOSE; then
                output=$(nuclei -l "$ACTIVE_HTTP_FILE" -v)
            else
                output=$(nuclei -l "$ACTIVE_HTTP_FILE")
            fi
            ;;
        3)
            echo -e "\e[33m[!]\e[0m Operación cancelada."
            exit 0
            ;;
        *)
            echo -e "\e[31m[ERROR]\e[0m Opción no válida."
            exit 1
            ;;
    esac

    # Mostrar output
    if [ -z "$output" ]; then
        echo -e "\e[33m[!]\e[0m Nuclei no encontró resultados."
    else
        echo -e "\e[32m[✔]\e[0m Resultados de nuclei:\n"
        echo "$output"
    fi

    # Preguntar si se quiere guardar el output
    read -p $'\e[35m¿Deseas guardar el output de nuclei en un archivo? (s/n): \e[0m' save_output
    if [[ "$save_output" =~ ^[Ss]$ ]]; then
        read -p $'\e[35mNombre del archivo (enter para usar timestamp automático): \e[0m' filename
        if [ -z "$filename" ]; then
            timestamp=$(date +"%Y-%m-%d_%H-%M")
            filename="nuclei_output_$timestamp.txt"
        fi
        echo "$output" > "$DOMAIN_DIR/$filename"
        echo -e "\e[32m[✔]\e[0m Output guardado en \e[1m$DOMAIN_DIR/$filename\e[0m"
    fi
fi

