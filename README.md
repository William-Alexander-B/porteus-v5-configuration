# porteus-v5-configuration

## Descripción

Este script está pensado para la configuración de clientes ligeros, los cuales
tendrán instalado Porteus (v5.0) como sistema operativo, debido a que esta distro
junto con el entorno de escritorio OPENBOX consumen pocos recursos.

Los clientes ligeros serán configurados para que estos se puedan conectar, 
mediante el protocolo RDP, a los distintos servidores ubicados en el mismo 
laboratorio. Además, este script también permite la personalización de Porteus
de una manera rápida y sencilla.

## Acciones realizadas por el script

Después de la correcta instalación de Porteus en el cliente ligero, es necesario
configurarlo y personalizarlo. Esto se logra mediante la ejecución de este
script, el cual realiza las siguientes acciones:

- Establece la nueva contraseña de `root`
- Establece la dirección IP del servidor para las futuras actualizaciones de 
Porteus
- Instala los fondos de pantalla de booteo y del escritorio
- Establece la distribución del teclado por defecto
- Instala el módulo `remmina` junto con los perfiles de conexión para los
distintos servidores
- Configura la barra de tareas, de manera que para conectarse a un determinado
servidor basta con darle click al ícono del servidor deseado
- Configura el firewall (iptables)

## Ejecución del script

Se recomienda consultar el menú de ayuda para conocer las opciones disponibles y
saber cómo ejecutar el script de manera correcta. Lo anterior se logra ejecutando
el script de la siguiente manera:

    ./porteus-v5-configuration.sh -h

Si solo desea configurar Porteus, debe ejecutar el script de la siguiente manera
con permisos de super usuario (`root`):

    ./porteus-v5-configuration.sh [-l <ip-servidor>] [-w <ip-servidor>] [-m <ip-servidor>]

Donde `-l <ip-servidor>`, `-w <ip-servidor>` y `-m <ip-servidor>`, son las
opciones de servidor junto con sus respectivas direcciones IP. Es necesario que 
al menos se introduzca una opción de servidor, de lo contrario la ejecución
terminará con un error. 

Las opciones no seleccionadas tendrán la siguiente dirección IP `0.0.0.0`.
Esto se puede modificar editando la línea que contenga la siguiente cadena de
texto `server=` del archivo ubicado en `/home/guest/.local/share/remmina/
servidor-<SERVIDOR>.remmina`.

Una vez ejecutado el script, deberá de introducir la nueva contraseña de `root`.
Si las contraseñas no coinciden, el script terminará con un error y tendrá que
ejecutarlo de nuevo.

Finalmente, el script apagará al cliente ligero, quedando ya el sistema 
configurado.