
Este repositorio contiene la configuración de una plataforma FIWARE completa utilizando Docker Compose. La plataforma incluye componentes esenciales para la gestión de contexto, persistencia histórica y conexión de dispositivos IoT.

## Componentes incluidos

### Componentes Core
- **Orion Context Broker**: Gestiona la información de contexto en tiempo real
- **MongoDB**: Base de datos para Orion Context Broker

### Componentes de Persistencia Histórica
- **Cygnus**: Conector para persistencia histórica de datos
- **PostgreSQL**: Base de datos para almacenamiento histórico
- **MySQL**: Base de datos alternativa para almacenamiento histórico
- **STH-Comet**: Componente para series temporales históricas

### Agentes IoT
- **IoT Agent JSON**: Para dispositivos que utilizan formato JSON
- **IoT Agent Ultralight**: Para dispositivos que utilizan formato Ultralight 2.0

## Versiones de los componentes

Las versiones de los componentes están definidas en el archivo `.env`. En entornos de producción, se recomienda utilizar versiones específicas en lugar de `latest` para garantizar la estabilidad y reproducibilidad del despliegue.

| Componente | Variable | Versión recomendada |
|------------|----------|---------------------|
| Orion Context Broker | ORION_VERSION | 3.10.1 |
| MongoDB | MONGO_VERSION | 4.4 |
| Cygnus | CYGNUS_VERSION | 2.18.0 |
| PostgreSQL | POSTGRES_VERSION | 14-alpine |
| IoT Agents | IOTA_VERSION | latest |
| MySQL | MYSQL_VERSION | 8.0 |
| STH-Comet | - | 2.8.0 |

Para verificar las versiones disponibles de un componente, puede utilizar:

```bash
# Listar las etiquetas disponibles para un componente
docker run --rm curlimages/curl -s https://registry.hub.docker.com/v2/repositories/fiware/orion/tags | jq -r '.results[].name'
```

## Requisitos previos

- Docker Engine (versión 19.03.0+)
- Docker Compose (versión 1.27.0+)
- Al menos 4GB de RAM disponible
- Al menos 10GB de espacio en disco

## Instalación y configuración

1. Clona este repositorio:
   ```bash
   git clone <url-del-repositorio>
   cd <directorio-del-repositorio>
   ```

2. Configura las variables de entorno (opcional):
   - Revisa el archivo `.env` y modifica los valores según tus necesidades
   - **IMPORTANTE**: Cambia las contraseñas predeterminadas antes de usar en producción

3. Crea los directorios para los volúmenes persistentes:
   ```bash
   mkdir -p data/mongodb data/postgresql data/mysql
   ```

4. Inicia la plataforma:
   ```bash
   docker-compose up -d
   ```

5. Verifica que todos los servicios estén funcionando:
   ```bash
   docker-compose ps
   ```

## Uso básico

### Verificar el estado de Orion Context Broker

```bash
curl -X GET http://localhost:1026/version
```

### Crear una entidad en Orion

```bash
curl -X POST http://localhost:1026/v2/entities \
  -H 'Content-Type: application/json' \
  -d '{
  "id": "Room1",
  "type": "Room",
  "temperature": {
    "value": 23,
    "type": "Float"
  },
  "humidity": {
    "value": 45,
    "type": "Float"
  }
}'
```

### Consultar entidades

```bash
curl -X GET http://localhost:1026/v2/entities \
  -H 'Accept: application/json'
```

### Registrar un dispositivo IoT (JSON)

```bash
curl -X POST http://localhost:4041/iot/devices \
  -H 'Content-Type: application/json' \
  -H 'fiware-service: openiot' \
  -H 'fiware-servicepath: /' \
  -d '{
  "devices": [
    {
      "device_id": "sensor01",
      "entity_name": "Sensor01",
      "entity_type": "Sensor",
      "protocol": "JSON",
      "transport": "HTTP",
      "attributes": [
        { "object_id": "t", "name": "temperature", "type": "Float" },
        { "object_id": "h", "name": "humidity", "type": "Float" }
      ]
    }
  ]
}'
```

## Estructura de directorios

```
.
├── docker-compose.yaml    # Configuración de servicios Docker
├── .env                   # Variables de entorno
├── data/                  # Datos persistentes
│   ├── mongodb/           # Datos de MongoDB
│   ├── postgresql/        # Datos de PostgreSQL
│   └── mysql/             # Datos de MySQL
└── README.md              # Este archivo
```

## Seguridad

Por defecto, esta configuración está pensada para entornos de desarrollo. Para entornos de producción, se recomienda:

1. Cambiar todas las contraseñas predeterminadas en el archivo `.env`
2. Configurar HTTPS para todas las comunicaciones externas
3. Implementar autenticación y autorización con Keyrock IDM
4. Restringir el acceso a los puertos expuestos mediante firewalls

## Solución de problemas

### Verificar logs de un servicio

```bash
docker-compose logs <nombre-servicio>
```

### Reiniciar un servicio específico

```bash
docker-compose restart <nombre-servicio>
```

### Problemas comunes

- **Orion no puede conectarse a MongoDB**: Verifica que MongoDB esté funcionando correctamente
- **IoT Agent no puede registrar dispositivos**: Asegúrate de que Orion esté funcionando y accesible
- **Error al descargar imágenes**: Si aparece un error como `manifest for fiware/iotagent-json:X.Y.Z not found`, significa que la versión especificada no existe. Modifica el archivo `.env` para usar una versión disponible o `latest`.

### Errores de versiones de imágenes

Si encuentra errores como:
```
Error response from daemon: manifest for fiware/iotagent-json:1.22.0 not found: manifest unknown: manifest unknown
```

Siga estos pasos:

1. Verifique las versiones disponibles:
   ```bash
   docker run --rm curlimages/curl -s https://registry.hub.docker.com/v2/repositories/fiware/iotagent-json/tags | jq -r '.results[].name'
   ```

2. Actualice el archivo `.env` con una versión disponible o use `latest`:
   ```
   IOTA_VERSION=latest
   ```

3. Reconstruya los contenedores:
   ```bash
   docker-compose down
   docker-compose up -d
   ```

## Referencias

- [Documentación oficial de FIWARE](https://www.fiware.org/developers/)
- [Tutoriales de FIWARE](https://fiware-tutorials.readthedocs.io/en/latest/)
- [Catálogo de componentes FIWARE](https://www.fiware.org/developers/catalogue/)

## Licencia

Este proyecto está licenciado bajo [MIT License](LICENSE). 
