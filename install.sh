#!/bin/bash

echo "📥 Clonando el repositorio shsc..."
git clone https://github.com/aressecc/shsc.git || {
    echo "❌ Error al clonar el repositorio."
    exit 1
}

cd shsc || {
    echo "❌ No se pudo acceder al directorio shsc."
    exit 1
}

echo "🔐 Dando permisos de ejecución al instalador..."
chmod +x install.sh

echo "🚀 Ejecutando el instalador..."
./install.sh

