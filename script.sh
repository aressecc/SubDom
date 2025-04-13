#!/bin/bash

REPO_URL="https://github.com/aressecc/shsc.git"
INSTALL_DIR="$HOME/shsc"

# Evitar que se vuelva a ejecutar si ya existe
if [[ -d "$INSTALL_DIR" && -f "$INSTALL_DIR/.shsc_installed" ]]; then
    echo "✅ shsc ya fue instalado anteriormente en $INSTALL_DIR. Saliendo..."
    exit 0
fi

echo "📥 Clonando el repositorio shsc..."
git clone "$REPO_URL" "$INSTALL_DIR" || {
    echo "❌ Error al clonar el repositorio."
    exit 1
}

cd "$INSTALL_DIR" || {
    echo "❌ No se pudo acceder al directorio $INSTALL_DIR."
    exit 1
}

echo "🔐 Dando permisos al instalador..."
chmod +x install.sh

echo "🚀 Ejecutando el instalador..."
./install.sh "$@"
