#!/bin/bash

echo "🔍 Instalador de shsc"

# Verificar si ya fue instalado
if [[ -f "$HOME/.shsc_installed" ]]; then
    echo "✅ shsc ya fue instalado anteriormente. Saliendo..."
    exit 0
fi

# Opción para omitir instalaciones fallidas
skip_all=false
for arg in "$@"; do
    if [[ "$arg" == "--skip" ]]; then
        skip_all=true
        echo "⚠️  Modo omitir habilitado: se continuará si algo falla o falta."
    fi
done

# Verificar si Go está instalado
if ! command -v go &>/dev/null; then
    echo "⚠️  Go no está instalado."
    if [[ "$skip_all" == false ]]; then
        read -p "¿Querés continuar sin Go (no se podrá instalar subfinder y nuclei)? [s/N]: " continuar
        if [[ "$continuar" != "s" && "$continuar" != "S" ]]; then
            echo "Instalación cancelada."
            exit 1
        fi
    fi
    skip_go=true
fi

# Verificar e instalar figlet
if ! dpkg -s figlet &>/dev/null; then
    echo "🛠 Instalando figlet..."
    if ! sudo apt update && sudo apt install figlet -y; then
        echo "❌ Error instalando figlet."
        if [[ "$skip_all" == false ]]; then
            read -p "¿Querés continuar sin figlet? [s/N]: " continuar
            if [[ "$continuar" != "s" && "$continuar" != "S" ]]; then
                echo "Instalación cancelada."
                exit 1
            fi
        fi
    fi
fi

# Verificar e instalar curl
if ! dpkg -s curl &>/dev/null; then
    echo "🛠 Instalando curl..."
    if ! sudo apt update && sudo apt install curl -y; then
        echo "❌ Error instalando curl."
        if [[ "$skip_all" == false ]]; then
            read -p "¿Querés continuar sin curl? [s/N]: " continuar
            if [[ "$continuar" != "s" && "$continuar" != "S" ]]; then
                echo "Instalación cancelada."
                exit 1
            fi
        fi
    fi
fi

# Instalar subfinder si Go está disponible
if [[ "$skip_go" != true && ! -f "$HOME/go/bin/subfinder" ]]; then
    echo "📥 Instalando subfinder..."
    if ! go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest; then
        echo "❌ Error instalando subfinder."
        [[ "$skip_all" == false ]] && read -p "¿Querés continuar sin subfinder? [s/N]: " r && [[ "$r" != "s" && "$r" != "S" ]] && exit 1
    fi
fi

# Instalar nuclei si Go está disponible
if [[ "$skip_go" != true && ! -f "$HOME/go/bin/nuclei" ]]; then
    echo "📥 Instalando nuclei..."
    if ! go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest; then
        echo "❌ Error instalando nuclei."
        [[ "$skip_all" == false ]] && read -p "¿Querés continuar sin nuclei? [s/N]: " r && [[ "$r" != "s" && "$r" != "S" ]] && exit 1
    fi
fi

# Dar permisos de ejecución
chmod +x ~/shsc/shsc.sh

# Marcar instalación completada
touch "$HOME/.shsc_installed"

echo -e "\n✅ Instalación completa. Podés ejecutar shsc con:"
echo "~/shsc/shsc.sh <dominio> <codigo_http> [--no-protocol]"

