#!/bin/bash
set -e

echo "=========================================="
echo "  Nubesti Recorder - Setup Script"
echo "=========================================="

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Verificar que se ejecuta como root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Por favor ejecuta como root (sudo)${NC}"
    exit 1
fi

echo -e "${YELLOW}[1/5] Actualizando sistema...${NC}"
apt update && apt upgrade -y

echo -e "${YELLOW}[2/5] Instalando Docker...${NC}"
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com | sh
    systemctl enable docker
    systemctl start docker
else
    echo "Docker ya está instalado"
fi

echo -e "${YELLOW}[3/5] Instalando Docker Compose...${NC}"
if ! command -v docker-compose &> /dev/null; then
    apt install -y docker-compose-plugin
else
    echo "Docker Compose ya está instalado"
fi

echo -e "${YELLOW}[4/5] Instalando Wasabi CLI (aws-cli)...${NC}"
if ! command -v aws &> /dev/null; then
    apt install -y awscli
else
    echo "AWS CLI ya está instalado"
fi

echo -e "${YELLOW}[5/5] Configurando firewall...${NC}"
if command -v ufw &> /dev/null; then
    ufw allow 22/tcp
    ufw allow 80/tcp
    ufw allow 443/tcp
    ufw --force enable
fi

echo ""
echo -e "${GREEN}=========================================="
echo "  ✅ Instalación completada!"
echo "==========================================${NC}"
echo ""
echo "Próximos pasos:"
echo "1. Copia .env.example a .env y configura las variables"
echo "2. Configura Wasabi con: aws configure --profile wasabi"
echo "3. Ejecuta: docker compose up -d"
echo ""
