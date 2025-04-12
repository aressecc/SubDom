# 🔍 Subdomain HTTP Status Checker - Dev by: `𝘼𝙍𝙀𝙎𝙎𝙀𝘾`

𝒔𝒉𝒔𝒄 𝒆𝒔 𝒖𝒏𝒂 𝒉𝒆𝒓𝒓𝒂𝒎𝒊𝒆𝒏𝒕𝒂 𝒔𝒆𝒏𝒄𝒊𝒍𝒍𝒂 𝒑𝒆𝒓𝒐 𝒑𝒐𝒕𝒆𝒏𝒕𝒆 𝒑𝒂𝒓𝒂 𝒅𝒆𝒔𝒄𝒖𝒃𝒓𝒊𝒓 𝒔𝒖𝒃𝒅𝒐𝒎𝒊𝒏𝒊𝒐𝒔 𝒚 𝒗𝒆𝒓𝒊𝒇𝒊𝒄𝒂𝒓 𝒔𝒖 𝒆𝒔𝒕𝒂𝒅𝒐 𝑯𝑻𝑻𝑷. 𝑼𝒕𝒊𝒍𝒊𝒛𝒂 𝒔𝒖𝒃𝒇𝒊𝒏𝒅𝒆𝒓 𝒑𝒂𝒓𝒂 𝒆𝒍 𝒅𝒆𝒔𝒄𝒖𝒃𝒓𝒊𝒎𝒊𝒆𝒏𝒕𝒐 𝒅𝒆 𝒔𝒖𝒃𝒅𝒐𝒎𝒊𝒏𝒊𝒐𝒔 𝒚 𝒄𝒖𝒓𝒍 𝒑𝒂𝒓𝒂 𝒗𝒆𝒓𝒊𝒇𝒊𝒄𝒂𝒓 𝒆𝒍 𝒄ó𝒅𝒊𝒈𝒐 𝒅𝒆 𝒆𝒔𝒕𝒂𝒅𝒐 𝑯𝑻𝑻𝑷 𝒅𝒆 𝒆𝒔𝒐𝒔 𝒔𝒖𝒃𝒅𝒐𝒎𝒊𝒏𝒊𝒐𝒔. 𝑨𝒅𝒆𝒎á𝒔, 𝒕𝒊𝒆𝒏𝒆 𝒊𝒏𝒕𝒆𝒈𝒓𝒂𝒄𝒊ó𝒏 𝒄𝒐𝒏 `𝑵𝒖𝒄𝒍𝒆𝒊` 𝒑𝒂𝒓𝒂 𝒉𝒂𝒄𝒆𝒓 𝒖𝒏 𝒆𝒔𝒄𝒂𝒏𝒆𝒐 𝒅𝒆 𝒗𝒖𝒍𝒏𝒆𝒓𝒂𝒃𝒊𝒍𝒊𝒅𝒂𝒅𝒆𝒔 𝒔𝒐𝒃𝒓𝒆 𝒍𝒐𝒔 𝒔𝒖𝒃𝒅𝒐𝒎𝒊𝒏𝒊𝒐𝒔 𝒂𝒄𝒕𝒊𝒗𝒐𝒔.

![image](https://github.com/user-attachments/assets/ff4d7597-4014-4449-87e4-e049da54da64)
## Características

- Descubre subdominios utilizando `subfinder`.
- Verifica el código de estado HTTP de los subdominios encontrados.
- Filtra subdominios por un código de estado HTTP específico (e.g., 200 OK).
- Soporta múltiples protocolos (http/https).
- Modo **verbose** para obtener información detallada durante la ejecución.
- Interrupción con `Ctrl+C` para pausar, cambiar el código de estado o guardar los subdominios encontrados hasta el momento.
- Integración con **Nuclei** para escanear vulnerabilidades en los subdominios activos.
- El --no-protocol para filtrar:
- Con protocolo:
- https://sub.ejemplo.com
- Sin protocolo (--no-protocol): sub.ejemplo.com
## Requisitos

- **subfinder**: Herramienta para descubrir subdominios.
- **curl**: Herramienta para realizar solicitudes HTTP.
- **figlet**: Para mostrar banners visuales.
- **nuclei** (opcional): Para escanear vulnerabilidades en los subdominios activos.

Puedes instalar `subfinder` y `nuclei` usando los siguientes comandos, obvio teniendo go instalado:

```bash
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest     # OPCIONAL (solo si se requiere instalar)
go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest           # OPCIONAL (solo si se requiere instalar)

## Instalación

1. Clona el repositorio en tu máquina local:

   ```bash
   git clone https://github.com/aressecc/shsc.git
   cd shsc
   chmod +x shsc.sh
   Uso: ./shsc.sh <dominio> <codigo_http> [--no-protocol]
  ./shsc.sh example.com 200
  ./shsc.sh example.com 200 --no-protocol



