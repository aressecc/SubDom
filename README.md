# 🔍 Subdomain HTTP Status Checker

Este es un script en Bash creado por **ARESSEC** 
**shsc** es una herramienta sencilla pero potente para descubrir subdominios de un dominio y verificar su estado HTTP. Utiliza `subfinder` para el descubrimiento de subdominios y `curl` para verificar el código de estado HTTP de esos subdominios. Además, tiene integración con **Nuclei** para hacer un escaneo de vulnerabilidades sobre los subdominios activos.

![image](https://github.com/user-attachments/assets/1df6d8d4-5345-4680-9f15-81218b0b091e)

## Características

- Descubre subdominios utilizando `subfinder`.
- Verifica el código de estado HTTP de los subdominios encontrados.
- Filtra subdominios por un código de estado HTTP específico (e.g., 200 OK).
- Soporta múltiples protocolos (http/https).
- Modo **verbose** para obtener información detallada durante la ejecución.
- Interrupción con `Ctrl+C` para pausar, cambiar el código de estado o guardar los subdominios encontrados hasta el momento.
- Integración con **Nuclei** para escanear vulnerabilidades en los subdominios activos.

## Requisitos

- **subfinder**: Herramienta para descubrir subdominios.
- **curl**: Herramienta para realizar solicitudes HTTP.
- **figlet**: Para mostrar banners visuales.
- **nuclei** (opcional): Para escanear vulnerabilidades en los subdominios activos.

Puedes instalar `subfinder` y `nuclei` usando los siguientes comandos:

```bash
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest


