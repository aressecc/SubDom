#!/bin/bash

echo "🔍 Instalador automático de shsc"

# Función para verificar instalación de paquetes
check_pkg() {
    dpkg -s "$1" &> /dev/null
}

# Verificar figlet
if check_pkg figlet; then
    echo "✔ figlet ya está instalado."
else
    echo "📦 Instalando figlet..."
    sudo apt install -y figlet
fi

# Verificar curl
if check_pkg curl; then
    echo "✔ curl ya está instalado."
else
    echo "📦 Instalando curl..."
    sudo apt install -y curl
fi

# Verificar Go
if ! command -v go &> /dev/null; then
    echo "❌ Go no está instalado. Por favor instalá Go desde:"
    echo "👉 https://go.dev/doc/install"
    exit 1
else
    echo "✔ Go está instalado."
fi

# Verificar subfinder
if ! command -v subfinder &> /dev/null; then
    echo "📦 Instalando subfinder..."
    go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
else
    echo "✔ subfinder ya está instalado."
fi

# Verificar nuclei (opcional)
if ! command -v nuclei &> /dev/null; then
    echo "📦 Instalando nuclei..."
    go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
else
    echo "✔ nuclei ya está instalado."
fi

# Agregar $HOME/go/bin al PATH si no está
if [[ ":$PATH:" != *":$HOME/go/bin:"* ]]; then
    echo "🛠 Agregando \$HOME/go/bin al PATH..."
    echo 'export PATH=$PATH:$HOME/go/bin' >> ~/.bashrc
    source ~/.bashrc
fi

# Clonar repositorio
echo "📁 Clonando repositorio shsc..."
git clone https://github.com/aressecc/shsc.git
cd shsc || exit

# Permisos de ejecución
chmod +x shsc.sh

echo "✅ Instalación completada con éxito."
echo "👉 Ejecutá la herramienta con: ./shsc.sh <dominio> <codigo_http> [--no-protocol]"
