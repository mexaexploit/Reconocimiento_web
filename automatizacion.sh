#!/bin/bash

if [ -z $1 ]; then
        echo "Introduzca ip o dominio:  $0 una ip/dominio"
        exit 1
fi

target=$1

echo "Objetivo: $target"

dns_enum() {
echo "[*]Iniciando reconocimiento DNS con dig"
output_file="dns_scan_$target.txt"
dig $target
echo "[*]Finalizacion de reconocimiento de host"
}

escaneo_puertos() {
echo "Iniciando escaneo de puertos"
scan_file="scan_file_$target.txt"
nmap -vvv -Pn -sV  $target > "$scan_file"
echo "Finalizando escaneo de puertos abiertos"
}

enum_subdominios() {
subd_file="subd_$target.txt"
echo "Iniciando busqueda de subdominios con sublist3r"
if command -v sublist3r &> /dev/null; then
        sublist3r -d $target -o $subd_file
        echo "Enumeracion de subdominios completado"
else
        echo "sublist3r no esta instalado. instala sudo apt install sublist3r"
fi
}

echo "=============Introduzca la opcion a ejecutar=========="

echo "Resolucion DNS(1)"
echo "Escaneo de puertos(2)"
echo "Enumeracion de subdominios(3)"
echo "Hacer reconocimiento completo(4)"

read -p "Ingrese la opcion a ejecutar (1-4: )" option

case $option in 
        1)dns_enum;;
        2)escaneo_puertos;;
        3)enum_subdominios;;
        4)
          dns_enum
          escaneo_puertos
          enum_subdominios
          ;;
        *)
        echo "Opcion seleccionada correctamente"
        exit 1
        ;;
esac
echo "======Reconocimiento finalizado==========="
