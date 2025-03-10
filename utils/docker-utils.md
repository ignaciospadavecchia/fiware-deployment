# Levantar servicios 
  
    docker-compose -f docker-compose-orion.yaml up -d

# Deneter servicios
    
    docker-compose down

    docker stop docker-iot-agent-ul-1

# Borrar servicios
  
    docker rm docker-iot-agent-ul-1

# Acceder al interior de contendores
 
    docker exec -it cygnus /bin/bash
    docker exec -it fiware-iot-agent /bin/bash

    docker exec -it cygnus /bin/bash
    /etc/cygnus/cygnus.conf

 # Troubleshooting

 docker logs <nombre_del_contenedor> 2>&1 | grep -i "error\|fail\|exception\|warning"

- Este comando obtiene los registros del contenedor especificado.
- 2>&1: Redirige los errores estándar (stderr) a la salida estándar (stdout), lo que permite que grep procese ambos tipos de salida.

- grep -i "error\|fail\|exception\|warning": Filtra las líneas que contienen las palabras "error", "fail", "exception" o "warning", sin importar si están en mayúsculas o minúsculas.