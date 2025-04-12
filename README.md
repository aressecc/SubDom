# 🔍 Subdomain HTTP Status Checker

Este es un script en Bash creado por **ARESSEC** para automatizar el proceso de descubrimiento de subdominios y verificar cuáles están activos a nivel de HTTP/HTTPS, filtrando por un código de respuesta específico como `200`, `403`, `302`, etc.

![image](https://github.com/user-attachments/assets/1df6d8d4-5345-4680-9f15-81218b0b091e)


---

## 📦 Requisitos

Antes de ejecutar el script, asegurate de tener instaladas las siguientes herramientas:

- [`subfinder`](https://github.com/projectdiscovery/subfinder) - Para enumerar subdominios.
- [`curl`](https://curl.se/) - Para realizar peticiones HTTP/S.
- [`figlet`](http://www.figlet.org/) - Solo para mostrar un banner bonito (opcional).

Uso.

```bash
git clone https://github.com/aressecc/shsc/
cd shsc
chmod +x shsc.sh
./shsc.sh example.com 200
---------------------------
Si quieres solamente los host y no la url completa usa el parametro --no-protocol
./shsc.sh example.com 200 --no-protocol

