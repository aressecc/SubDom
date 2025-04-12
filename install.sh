#!/bin/bash

echo "🔍 Instalador de shsc"

# Verificar si Go está instalado
if ! command -v go &>/dev/null; then
    echo "⚠️  Go no está instalado."
    read -p "¿Querés continuar sin Go (no se podrá instalar subfinder y nuclei)? [s/N]: " continuar
    if [[ "$continuar" != "s" && "$continuar" != "S" ]]; then
        echo "Instalación cancelada."
        exit 1
    else
        skip_go=true
    fi
fi

# Verificar e instalar figlet
if ! dpkg -s figlet &>/dev/null; then
    echo "🛠 Instalando figlet..."
    sudo apt update && sudo apt install figlet -y
fi

# Verificar e instalar curl
if ! dpkg -s curl &>/dev/null; then
    echo "🛠 Instalando curl..."
    sudo apt update && sudo apt install curl -y
fi

# Instalar subfinder si Go está disponible
if [[ "$skip_go" != true && ! -f "$HOME/go/bin/subfinder" ]]; then
    echo "📥 Instalando subfinder..."
    go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
fi

# Instalar nuclei si Go está disponible
if [[ "$skip_go" != true && ! -f "$HOME/go/bin/nuclei" ]]; then
    echo "📥 Instalando nuclei..."
    go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
fi

# Clonar el repositorio de shsc
echo "📂 Clonando el repositorio..."
git clone https://github.com/aressecc/shsc.git ~/shsc

# Dar permisos de ejecución
chmod +x ~/shsc/shsc.sh

echo -e "\n✅ Instalación completa. Podés ejecutar shsc con:"
echo "~/shsc/shsc.sh <dominio> <codigo_http> [--no-protocol]"
