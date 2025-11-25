#!/bin/bash
set -e

echo "=========================================="
echo "  Wasabi S3 - Configuración"
echo "=========================================="

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Cargar variables de entorno
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo "Error: No se encontró el archivo .env"
    exit 1
fi

WASABI_ENDPOINT="https://s3.${WASABI_REGION}.wasabisys.com"

echo -e "${YELLOW}[1/3] Configurando perfil Wasabi en AWS CLI...${NC}"
aws configure set aws_access_key_id "$WASABI_ACCESS_KEY" --profile wasabi
aws configure set aws_secret_access_key "$WASABI_SECRET_KEY" --profile wasabi
aws configure set region "$WASABI_REGION" --profile wasabi

echo -e "${YELLOW}[2/3] Creando bucket: ${WASABI_BUCKET}...${NC}"
aws s3 mb "s3://${WASABI_BUCKET}" \
    --endpoint-url "$WASABI_ENDPOINT" \
    --profile wasabi 2>/dev/null || echo "Bucket ya existe o error al crear"

echo -e "${YELLOW}[3/3] Configurando CORS...${NC}"
cat > /tmp/cors.json << EOF
{
    "CORSRules": [
        {
            "AllowedHeaders": ["*"],
            "AllowedMethods": ["GET", "HEAD", "PUT", "POST", "DELETE"],
            "AllowedOrigins": ["${WEB_URL}", "https://${DOMAIN}"],
            "ExposeHeaders": ["ETag", "x-amz-meta-custom-header"],
            "MaxAgeSeconds": 3600
        }
    ]
}
EOF

aws s3api put-bucket-cors \
    --bucket "$WASABI_BUCKET" \
    --cors-configuration file:///tmp/cors.json \
    --endpoint-url "$WASABI_ENDPOINT" \
    --profile wasabi

rm /tmp/cors.json

echo ""
echo -e "${GREEN}=========================================="
echo "  ✅ Wasabi configurado correctamente!"
echo "==========================================${NC}"
echo ""
echo "Bucket: ${WASABI_BUCKET}"
echo "Region: ${WASABI_REGION}"
echo "Endpoint: ${WASABI_ENDPOINT}"
echo ""
