# 🔍 Subdomain HTTP Status Checker - Dev by: 𝘼𝙍𝙀𝙎𝙎𝙀𝘾

**shsc** es una herramienta sencilla pero potente para descubrir subdominios de un dominio y verificar su estado HTTP. Utiliza `subfinder` para el descubrimiento de subdominios y `curl` para verificar el código de estado HTTP de esos subdominios. Además, tiene integración con **Nuclei** para hacer un escaneo de vulnerabilidades sobre los subdominios activos.

![image](https://github.com/user-attachments/assets/ff4d7597-4014-4449-87e4-e049da54da64)
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

Puedes instalar `subfinder` y `nuclei` usando los siguientes comandos, obvio teniendo go instalado:

```bash
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest


