#!/bin/bash

# Función que maneja el Ctrl+C (SIGINT)
handle_interrupt() {
    local interrupt_handled=false
    while [ "$interrupt_handled" = false ]; do
        echo -e "\n\e[33m[!]\e[0m Interrumpido. ¿Quieres pausar, cambiar el código de estado, guardar los resultados, o salir?"
        echo -e "\e[36m[*]\e[0m Opciones: [pausar/cambiar/tomar/salir]"
        read -r -p $'\e[35mElige una opción: \e[0m' opcion
        case "$opcion" in
            pausar|Pausar)
                echo -e "\e[36m[*]\e[0m Pausado. Puedes reanudar el script cuando desees."
                read -p $'\e[35mPresiona [Enter] para continuar... \e[0m'
                interrupt_handled=true
                ;;
            cambiar|Cambiar)
                read -r -p $'\e[35mIngresa el nuevo código de estado HTTP a filtrar: \e[0m' nuevo_codigo
                FILTER_CODE="$nuevo_codigo"
                echo -e "\e[36m[*]\e[0m Filtrando con el nuevo código: $FILTER_CODE"
                interrupt_handled=true
                ;;
            tomar|Tomar)
                echo -e "\e[36m[*]\e[0m Guardando subdominios encontrados hasta ahora..."
                cp "$SUBDOMAINS_FILE" "$DOMAIN_DIR/subdominios_parciales.txt"
                echo -e "\e[32m[✔]\e[0m Subdominios guardados en \e[1m$DOMAIN_DIR/subdominios_parciales.txt\e[0m"
                interrupt_handled=true
                ;;
            salir|Salir)
                echo -e "\e[31m[!]\e[0m Saliendo del script. ¡Hasta luego!"
                exit 0
                ;;
            *)
                echo -e "\e[31m[ERROR]\e[0m Opción no válida. Por favor, elige una opción válida."
                ;;
        esac
    done
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

# Procesar las opciones
VERBOSE=false

# Validar los argumentos restantes
if [ $# -lt 2 ]; then
    echo -e "\e[33mUso:\e[0m $0 <dominio> <codigo_http>"
    echo "Ejemplo:"
    echo "  $0 example.com 200"
    exit 1
fi

# Asignar argumentos
TARGET="$1"
FILTER_CODE="$2"

# Validar que TARGET no esté vacío
if [ -z "$TARGET" ]; then
    echo -e "\e[31m[ERROR]\e[0m El dominio objetivo (TARGET) no puede estar vacío. Proporcione un dominio válido."
    exit 1
fi

# Crear carpeta para el dominio
DOMAIN_DIR="${TARGET//http:\/\//}"
DOMAIN_DIR="${DOMAIN_DIR//https:\/\//}"
DOMAIN_DIR="${DOMAIN_DIR//\//}"

# Validar que DOMAIN_DIR no sea vacío
if [ -z "$DOMAIN_DIR" ]; then
    echo -e "\e[31m[ERROR]\e[0m No se pudo construir la ruta del directorio para el dominio: $TARGET"
    exit 1
fi

# Crear el directorio
mkdir -p "$DOMAIN_DIR" || {
    echo -e "\e[31m[ERROR]\e[0m No se pudo crear el directorio: $DOMAIN_DIR"
    exit 1
}

# Archivos con ruta completa
SUBDOMAINS_FILE="$DOMAIN_DIR/subdomains.txt"
ACTIVE_HTTP_FILE="$DOMAIN_DIR/http_active.txt"

# Limpiar archivos anteriores si existen
> "$SUBDOMAINS_FILE"
> "$ACTIVE_HTTP_FILE"

# Ejecución de subfinder en modo verbose siempre
verbose "\e[36m[*]\e[0m Buscando subdominios para: $TARGET"
subfinder -d "$TARGET" -v > "$SUBDOMAINS_FILE" || {
    echo -e "\e[31m[ERROR]\e[0m Error al ejecutar subfinder. Verifica que esté instalado correctamente."
    exit 1
}

# Verificar si el archivo tiene contenido
if [[ -s "$SUBDOMAINS_FILE" ]]; then
    echo -e "\e[32m[✔]\e[0m Subdominios guardados correctamente en $SUBDOMAINS_FILE"

    # Preguntar si se desea usar nuclei directamente
    read -p $'\e[35m¿Deseas usar los subdominios encontrados con nuclei? (s/n): \e[0m' use_nuclei
    if [[ "$use_nuclei" =~ ^[Ss]$ ]]; then
        if ! command -v nuclei &> /dev/null; then
            echo -e "\e[31m[ERROR]\e[0m nuclei no está instalado. Instálalo con:"
            echo "  go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest"
            exit 1
        fi

        echo -e "\e[36m[1]\e[0m Ejecutar nuclei para un solo host/url"
        echo -e "\e[36m[2]\e[0m Ejecutar nuclei para TODOS los subdominios encontrados"
        echo -e "\e[36m[3]\e[0m Cancelar"

        read -p $'\e[35mElige una opción (1/2/3): \e[0m' opcion

        case "$opcion" in
            1)
                read -p $'\e[35mIngresa el host o URL a analizar con nuclei: \e[0m' nuc_url
                verbose "\e[36m[*]\e[0m Ejecutando nuclei para: \e[1m$nuc_url\e[0m"
                nuclei -u "$nuc_url" -v
                ;;
            2)
                verbose "\e[36m[*]\e[0m Ejecutando nuclei para todos los subdominios en $SUBDOMAINS_FILE..."
                nuclei -l "$SUBDOMAINS_FILE" -v
                ;;
            3)
                echo -e "\e[33m[!]\e[0m Operación cancelada."
                ;;
            *)
                echo -e "\e[31m[ERROR]\e[0m Opción no válida."
                ;;
        esac
    fi
else
    echo -e "\e[31m[ERROR]\e[0m No se encontraron subdominios o hubo un problema con subfinder."
fi

verbose "\e[36m[*]\e[0m Analizando HTTP en subdominios encontrados (filtrando por código $FILTER_CODE)..."

# Procesar cada subdominio
while read -r subdomain; do
    for proto in http https; do
        status_code=$(curl -o /dev/null -s -w "%{http_code}" --max-time 5 "$proto://$subdomain")
        if [[ "$status_code" -eq "$FILTER_CODE" ]]; then
            echo "$proto://$subdomain" >> "$ACTIVE_HTTP_FILE"
            verbose "\e[32m[+]\e[0m Activo ($FILTER_CODE): $proto://$subdomain"
            break
        fi
    done
done < "$SUBDOMAINS_FILE"

verbose "\e[36m[*]\e[0m Proceso finalizado. Subdominios activos (HTTP $FILTER_CODE) guardados en \e[1m$ACTIVE_HTTP_FILE\e[0m."
