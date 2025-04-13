#!/bin/bash

REPO_URL="https://github.com/aressecc/shsc.git"
INSTALL_DIR="$HOME/shsc"

# Evitar reejecución si ya fue instalado
if [[ -d "$INSTALL_DIR" && -f "$HOME/.shsc_installed" ]]; then
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

# Dar permisos y ejecutar el instalador
if [[ -f install.sh ]]; then
    echo "🔐 Dando permisos al instalador..."
    chmod +x install.sh
    echo "🚀 Ejecutando el instalador..."
    ./install.sh "$@"
else
    echo "❌ No se encontró install.sh"
    exit 1
fi

# Asegurar permisos a shsc.sh después de instalar
if [[ -f shsc.sh ]]; then
    echo "🔐 Dando permisos a shsc.sh..."
    chmod +x shsc.sh
else
    echo "⚠️  Advertencia: shsc.sh no fue encontrado después de la instalación."
fi
