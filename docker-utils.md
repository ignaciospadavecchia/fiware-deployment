Levantar servicios 
    docker-compose -f docker-compose-orion.yaml up -d

Parar servicios
    docker-compose down

    docker stop docker-iot-agent-ul-1

Borrar servicios
    docker rm docker-iot-agent-ul-1


Acceder al interior de contendores
 docker exec -it cygnus /bin/bash
 docker exec -it fiware-iot-agent /bin/bash

 docker exec -it cygnus /bin/bash
 /etc/cygnus/cygnus.conf