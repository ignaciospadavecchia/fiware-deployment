
## Flujo de Datos en FIWARE 

Explicación desde que los datos llegan al IoT Agent hasta que se almacenan en las bases de datos:

1. **Dispositivo IoT → IoT Agent JSON (puerto 7896)**
    - Los datos del dispositivo (plaza de aparcamiento) se envían al puerto sur (SOUTH_PORT=7896) del IoT Agent JSON
    - La API key (`api-key-empresa-parking-1`) y el ID del dispositivo (`parking-spot-001`) son usados para identificar el dispositivo
2. **IoT Agent JSON → Orion Context Broker (puerto 1026)**
    - El IoT Agent procesa los datos y los envía al Context Broker Orion en el puerto 1026
    - Los datos se transforman al formato NGSI v2
3. **Orion Context Broker → Cygnus (puerto 5055)**
    - Gracias a la suscripción configurada, Orion notifica a Cygnus en el puerto 5055 (URL: `http://cygnus:5055/notify`)
    - Esto ocurre cuando hay cambios en entidades que coincidan con el patrón `urn:ngsi-ld:ParkingSpot:pamplona:parkings:.*`
4. **Cygnus → Bases de Datos**
    - Cygnus recibe las notificaciones y las procesa para cada sink configurado:
        - **Para MongoDB**: Cygnus está configurado correctamente y crea las colecciones y documentos
        - **Para PostgreSQL**: Debería conectar al puerto 5432 y crear tablas con un esquema basado en `dm-by-service-path`
        - **Para MySQL**: Debería conectar al puerto 3306 y crear tablas con un esquema basado en `dm-by-entity`

## Posibles Causas del Problema

### 1. Problemas de Configuración en Cygnus

- **Falta de agente activo**: Aunque `CYGNUS_POSTGRESQL_ENABLE=true` está definido, es posible que el agente PostgreSQL no esté correctamente activado en la configuración interna.
- **Modelo de datos incorrecto**: Para PostgreSQL usas `dm-by-service-path` y para MySQL `dm-by-entity`. Esto influye en cómo se nombran las tablas.

### 2. Problemas de Conectividad

- **Resolución de nombres**: En la suscripción usas `http://cygnus:5055/notify`, pero dentro del contenedor Cygnus necesita resolver correctamente los nombres `postgres-db` y `mysql`.
- **Puertos incorrectos**: Aunque los puertos externos están mapeados (5432 para PostgreSQL y 3306 para MySQL), dentro de la red de Docker, Cygnus debe conectarse a estos mismos puertos internos.

### 3. Problemas de Autenticación

- Las credenciales en las variables de entorno podrían no ser correctas o haber algún problema con los permisos en las bases de datos.

## Solución Recomendada

1. **Verifica los logs de Cygnus**:
    - Ejecuta `docker logs fiware-cygnus` para ver si hay errores específicos durante la conexión a PostgreSQL o MySQL.
2. **Comprueba que las tablas no existan ya**:
    - Conéctate a PostgreSQL con: `docker exec -it fiware-postgres psql -U postgres -d fiware-postgres`
    - Ejecuta: `\\dt` para listar todas las tablas
    - La tabla debería llamarse `pamplona_parkings_ParkingSpot` según tu configuración de service y servicePath
3. **Ajusta el archivo de configuración de Cygnus**:
    - Puede ser necesario crear un archivo `agent.conf` personalizado para asegurar que todos los sinks están correctamente configurados.
    - Asegúrate de que los sinks de PostgreSQL y MySQL estén correctamente activados.
4. **Prueba con una configuración más simple**:
    - Configura primero solo MongoDB y PostgreSQL para simplificar la depuración.
    - Luego agrega MySQL una vez que PostgreSQL funcione.
5. **Verifica los namespaces**:
    - Asegúrate de usar las mismas cabeceras `fiware-service` y `fiware-servicepath` en todas las solicitudes (notificación a IoT Agent, suscripción a Orion, etc.)

## Nombre Correcto de la Tabla en PostgreSQL

Según tu configuración con:

- `fiware-service: pamplona`
- `fiware-servicepath: /parkings`
- `CYGNUS_POSTGRESQL_DATA_MODEL=dm-by-service-path`

La tabla en PostgreSQL debería llamarse:

```
pamplona_parkings_parkingspot

```

Y en MySQL con `CYGNUS_MYSQL_DATA_MODEL=dm-by-entity`:

```
pamplona_parkingspot

```

El hecho de que solo esté funcionando con MongoDB podría indicar que hay un problema específico con la configuración de los sinks para PostgreSQL y MySQL en Cygnus.

¿Has intentado revisar los logs de Cygnus para ver si hay errores específicos de conexión a estas bases de datos?