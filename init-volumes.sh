#!/bin/bash

# Crear directorios para los volúmenes
mkdir -p data/{mongodb,postgresql,grafana,prometheus,keyrock}

# Crear directorios para las configuraciones
mkdir -p config/grafana/provisioning/{datasources,dashboards}
mkdir -p config/prometheus

# Establecer permisos correctos
chmod -R 777 data/mongodb
chmod -R 777 data/postgresql
chmod -R 777 data/grafana
chmod -R 777 data/prometheus
chmod -R 777 data/keyrock

# Crear archivo de configuración básico para Prometheus si no existe
if [ ! -f config/prometheus/prometheus.yml ]; then
    cat > config/prometheus/prometheus.yml << EOF
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
EOF
fi

echo "Estructura de directorios creada correctamente"
echo "Recuerde ejecutar este script con permisos de administrador si es necesario" 