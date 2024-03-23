#!/bin/bash

# Help menu
help(){
    echo "Configuración de Porteus v5.0 (OPENBOX) en los clientes ligeros"
    echo ""
    echo "Uso:"
    echo "  $(basename $0) [-l <ip-servidor>] [-w <ip-servidor>] [-m <ip-servidor>]"
    echo "  $(basename $0) -h"
    echo "  $(basename $0) -v"
    echo ""
    echo "Opciones:"
    echo "  -l <ip-servidor>   Dirección IP del servidor Linux     [Default: 0.0.0.0]"
    echo "  -w <ip-servidor>   Dirección IP del servidor Windows   [Default: 0.0.0.0]"
    echo "  -m <ip-servidor>   Dirección IP del servidor Mac       [Default: 0.0.0.0]"
    echo "  -h                 Muestra este menú"
    echo "  -v                 Muestra la versión"
    echo ""
    echo "Este script realiza las siguientes acciones:"
    echo "   1) Establece la nueva contraseña de root"
    echo "   2) Establece el servidor que se usará para las actualizaciones de Porteus"
    echo "   3) Instala los fondos de pantalla"
    echo "   4) Establece la distribución del teclado por defecto"
    echo "   5) Instala y configura Remmina con sus respectivos perfiles de conexión"
    echo "   6) Configura la barra de tareas"
    echo "   7) Configura el firewall"
    echo ""
    echo "Notas:Es necesario seleccionar al menos una opción de servidor con su "
    echo "      respectiva dirección IP, de lo contrario se abortará la ejecución "
    echo "      del script."
    echo "      Este script debe de ser ejecutado con permisos de superusuario."
    echo "      Antes de ejecutar el script verifique que tiene una conexión a"
    echo "      internet."
    echo ""
    echo "Autor: William Alexander"
}

SERVER_LINUX="server=0.0.0.0"
PROFILE_LINUX="/home/guest/.local/share/remmina/servidor-linux.remmina"

SERVER_WINDOWS="server=0.0.0.0"
PROFILE_WINDOWS="/home/guest/.local/share/remmina/servidor-windows.remmina"

SERVER_MAC="server=0.0.0.0"
PROFILE_MAC="/home/guest/.local/share/remmina/servidor-mac.remmina"

SERVER_SELECTED=0

# Check the options
while getopts ":l:w:m:hv" OPTIONS; do
    case "${OPTIONS}" in
        l)
            SERVER_LINUX="server="${OPTARG}
            SERVER_SELECTED=1
            ;;
        w)
            SERVER_WINDOWS="server="${OPTARG}
            SERVER_SELECTED=1
            ;;
        m)
            SERVER_MAC="server="${OPTARG}
            SERVER_SELECTED=1
            ;;
        h)
            help
            exit 0
            ;;
        v)
            echo -n "Versión: "
            cat VERSION
            exit 0
            ;;
        :)
            echo "ERROR: La opción '-${OPTARG}' requiere de una dirección IP"
            help
            exit 1
            ;;
        *)
            echo "ERROR: La opción '-${OPTARG}' es incorrecta"
            help
            exit 1
            ;;
    esac
done

# Abort the execution if the user didn't enter a server option
if [ "$SERVER_SELECTED" == "0" ]; then
    echo "ERROR: El usuario no ingresó ninguna opción de servidor"
    help
    exit 1
fi

# Abort the execution if the user didn't run the script with root privileges
if [ "$EUID" != "0" ]; then
    echo "ERROR: El script debe de ser ejecutado con permisos de superusuario"
    help
    exit 1
fi

# Configure the root password; abort if the passwords don't match
setxkbmap latam
passwd root || exit 1

# Configure the nearest Porteus server for updates
echo 'y' | fastest-mirror

# Install the wallpapers
install wallpapers/porteus_boot.png /mnt/sda1/boot/syslinux/porteus.png
install wallpapers/porteus_wallpaper.png /usr/share/wallpapers/porteus.jpg

# Configure the keyboard layout
install keyboard/gxkb.cfg /home/guest/.config/gxkb/gxkb.cfg
install keyboard/latam.png /usr/share/gxkb/flags/latam.png

# Install the server icons
install icons/*.png /usr/share/icons/Paper/24x24/places/

# Install and configure Remmina with the server connection profiles
install remmina/remmina*.xzm /mnt/sda1/porteus/modules/
activate /mnt/sda1/porteus/modules/remmina*.xzm && remmina &
sleep 5s
killall remmina
mkdir -p /home/guest/.local/share/remmina
install remmina/*.remmina /home/guest/.local/share/remmina/
echo $SERVER_LINUX >> $PROFILE_LINUX
echo $SERVER_WINDOWS >> $PROFILE_WINDOWS
echo $SERVER_MAC >> $PROFILE_MAC

# Configure the dock
install dock/tint2rc /home/guest/.config/tint2/tint2rc
install dock/*.desktop /usr/share/applications/

# Configure the firewall (iptables)
install firewall/rc.FireWall /etc/rc.d/rc.FireWall
chmod u+x /etc/rc.d/rc.FireWall
cd /etc/rc.d/
./rc.FireWall start

# Poweroff the system
poweroff