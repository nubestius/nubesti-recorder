# Despliegue en Contabo + Wasabi

## Requisitos

- VPS Contabo (Ubuntu 22.04 recomendado)
- Cuenta Wasabi con Access Key y Secret Key
- Dominio apuntando al IP del VPS

## Guía Rápida

### 1. Preparar el servidor (Contabo)

```bash
# Conectar al VPS
ssh root@tu-ip-contabo

# Clonar el repositorio
git clone https://github.com/nubestius/nubesti-recorder.git
cd nubesti-recorder/deploy/contabo

# Ejecutar script de instalación
chmod +x setup.sh
./setup.sh
```

### 2. Configurar variables de entorno

```bash
# Copiar ejemplo
cp .env.example .env

# Editar con tus valores
nano .env
```

**Generar secrets seguros:**
```bash
# NEXTAUTH_SECRET
openssl rand -hex 32

# DATABASE_ENCRYPTION_KEY
openssl rand -hex 32

# MYSQL_PASSWORD
openssl rand -base64 24

# MYSQL_ROOT_PASSWORD
openssl rand -base64 32
```

### 3. Configurar Wasabi

```bash
chmod +x wasabi-setup.sh
./wasabi-setup.sh
```

**Crear cuenta Wasabi:**
1. Ve a https://wasabi.com y crea cuenta
2. Crea un Access Key en: Console → Access Keys → Create New Access Key
3. Guarda el Access Key ID y Secret Access Key

**Regiones Wasabi disponibles:**
- `us-east-1` - Virginia (US)
- `us-east-2` - Virginia (US)
- `us-west-1` - Oregon (US)
- `eu-central-1` - Ámsterdam (EU) ⭐ Recomendado si usas Contabo EU
- `eu-central-2` - Frankfurt (EU)
- `eu-west-1` - Londres (EU)
- `eu-west-2` - París (EU)
- `ap-northeast-1` - Tokio (Asia)
- `ap-northeast-2` - Osaka (Asia)
- `ap-southeast-1` - Singapur (Asia)
- `ap-southeast-2` - Sydney (Australia)

### 4. Configurar DNS

Apunta tu dominio al IP de Contabo:

```
Tipo: A
Nombre: recorder (o @ para raíz)
Valor: tu-ip-contabo
TTL: 300
```

### 5. Desplegar

```bash
# Construir y levantar
docker compose up -d --build

# Ver logs
docker compose logs -f

# Verificar estado
docker compose ps
```

### 6. Ejecutar migraciones de BD

```bash
docker compose exec web pnpm db:push
```

## Comandos útiles

```bash
# Reiniciar servicios
docker compose restart

# Ver logs de un servicio
docker compose logs -f web
docker compose logs -f mysql

# Parar todo
docker compose down

# Parar y eliminar volúmenes (¡CUIDADO! Borra datos)
docker compose down -v

# Actualizar a nueva versión
git pull
docker compose up -d --build
```

## Wasabi CLI

```bash
# Listar buckets
aws s3 ls --endpoint-url https://s3.eu-central-1.wasabisys.com --profile wasabi

# Listar contenido del bucket
aws s3 ls s3://nubesti-recordings --endpoint-url https://s3.eu-central-1.wasabisys.com --profile wasabi

# Ver espacio usado
aws s3 ls s3://nubesti-recordings --recursive --summarize --endpoint-url https://s3.eu-central-1.wasabisys.com --profile wasabi
```

## Backup

```bash
# Backup de MySQL
docker compose exec mysql mysqldump -u root -p nubesti_recorder > backup.sql

# Restaurar
docker compose exec -i mysql mysql -u root -p nubesti_recorder < backup.sql
```

## Costos estimados

| Servicio | Especificaciones | Costo/mes |
|----------|------------------|-----------|
| Contabo VPS S | 4 vCPU, 8GB RAM, 200GB SSD | ~€5.99 |
| Contabo VPS M | 6 vCPU, 16GB RAM, 400GB SSD | ~€10.99 |
| Wasabi | 1TB almacenamiento | $6.99 |
| **Total** | | **~$13-18/mes** |

## Solución de problemas

### Certificado SSL no funciona
```bash
# Ver logs de Caddy
docker compose logs caddy

# Reiniciar Caddy
docker compose restart caddy
```

### MySQL no inicia
```bash
# Ver logs
docker compose logs mysql

# Verificar permisos
ls -la mysql-data/
```

### La app no conecta a Wasabi
```bash
# Probar conexión
aws s3 ls --endpoint-url https://s3.eu-central-1.wasabisys.com --profile wasabi

# Verificar CORS
aws s3api get-bucket-cors --bucket nubesti-recordings --endpoint-url https://s3.eu-central-1.wasabisys.com --profile wasabi
```
