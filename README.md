# 🔍 Subdomain HTTP Status Checker

𝒔𝒉𝒔𝒄 es una herramienta sencilla pero potente para descubrir subdominios y verificar su estado HTTP.  
Utiliza **subfinder** para el descubrimiento de subdominios y **curl** para verificar el código de estado HTTP de esos subdominios.  
Además, tiene integración con `Nuclei` para hacer un escaneo de vulnerabilidades sobre los subdominios activos.

![image](https://github.com/user-attachments/assets/ff4d7597-4014-4449-87e4-e049da54da64)

---

## ✨ Características

- 🔎 Descubre subdominios utilizando `subfinder`.
- 🌐 Verifica el código de estado HTTP de los subdominios encontrados.
- 🎯 Filtra subdominios por un código de estado HTTP específico (e.g., 200 OK).
- 🔄 Soporta múltiples protocolos (http/https).
- 🗣️ Modo **verbose** para obtener información detallada durante la ejecución.
- ⏸️ Interrupción con `Ctrl+C` para pausar, cambiar el código de estado o guardar los subdominios encontrados hasta el momento.
- 🛡️ Integración con **Nuclei** para escanear vulnerabilidades en los subdominios activos.
- 🧩 Opción `--no-protocol` para omitir el prefijo `http://` o `https://`.

---

## ⚙️ ¿Qué hace `--no-protocol`?

El flag `--no-protocol` evita que se anteponga `http://` o `https://` a los subdominios listados.

| Con protocolo            | Sin protocolo (`--no-protocol`) |
|--------------------------|----------------------------------|
| `https://admin.ejemplo.com` | `admin.ejemplo.com`              |
| `http://api.ejemplo.com`   | `api.ejemplo.com`                |

Esto es útil para integrarse con otras herramientas como `ffuf`, `nuclei`, o para generar wordlists limpias.

---

## 📦 Requisitos

- [`subfinder`](https://github.com/projectdiscovery/subfinder): Descubrimiento de subdominios.
- [`curl`](https://curl.se/): Peticiones HTTP.
- [`figlet`](http://www.figlet.org/): Mostrar banners.
- [`nuclei`](https://github.com/projectdiscovery/nuclei) *(opcional)*: Escaneo de vulnerabilidades.

> 💡 Asegúrate de tener **Go** instalado para poder usar `go install`.

```bash
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest

🛠 Instalación automática
Podés instalar shsc fácilmente con el siguiente comando:

bash
Copiar
Editar
curl -sSL https://raw.githubusercontent.com/aressecc/shsc/main/install.sh | bash
Este instalador:

Verifica si tenés instalados figlet, curl, subfinder, y nuclei.

Comprueba si Go está instalado.

Clona el repositorio oficial de shsc.

Le da permisos de ejecución al script principal shsc.sh.

⚠️ Nota: Asegurate de tener instalado Go previamente, ya que subfinder y nuclei se instalan con go install.


