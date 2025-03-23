#!/bin/bash

# URL do Portainer e token de autenticação
PORTAINER_URL="http://arm.sostrader.com.br:9000"
TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwidXNlcm5hbWUiOiJ0cmFkZXJwZWRyb3NvIiwicm9sZSI6MSwic2NvcGUiOiJkZWZhdWx0IiwiZm9yY2VDaGFuZ2VQYXNzd29yZCI6ZmFsc2UsImV4cCI6MTc0MTc4NjI4OSwiaWF0IjoxNzQxNzU3NDg5LCJqdGkiOiI5MDFiYjVmMi1jZTM4LTQzYTMtYjE2NC1hMTYwMGI0NTVhMDYifQ.zaJndPCUiPlY1iUFwOl14r6OKjY6hibLLnuko0TsRxo"
ENDPOINT_ID=1
# Caminho base onde estão os arquivos docker-compose.yml
BASE_PATH="/var/lib/docker/volumes/portainer_data/_data/compose"

# Array com IDs dos stacks
STACK_IDS=(18 40 41 42 43 44 45 46 47 48 49)

# Loop para cada ID de stack
for STACK_ID in "${STACK_IDS[@]}"; do
  # Lê o conteúdo do docker-compose.yml para o stack atual
  STACK_FILE_PATH="$BASE_PATH/$STACK_ID/docker-compose.yml"
  if [[ -f "$STACK_FILE_PATH" ]]; then
    # Lê o conteúdo do arquivo e o formata corretamente para JSON
    STACK_FILE_CONTENT=$(jq -Rs . < "$STACK_FILE_PATH")

    # Envia a solicitação para reassociar o stack com o conteúdo do docker-compose.yml
    # Adicionamos o campo "Type" com valor 2 para definir que o stack é do tipo compose.
    curl -X PUT "$PORTAINER_URL/api/stacks/$STACK_ID?endpointId=$ENDPOINT_ID" \
      -H "Authorization: Bearer $TOKEN" \
      -H "Content-Type: application/json" \
      -d "{\"StackFileContent\": $STACK_FILE_CONTENT, \"Type\": 2}"

    echo -e "\nReassociado stack com ID: $STACK_ID"
  else
    echo "Arquivo docker-compose.yml não encontrado para o stack com ID: $STACK_ID"
  fi
done




#!/bin/bash

# URL do Portainer e token de autenticação
PORTAINER_URL="http://arm.sostrader.com.br:9000"
TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwidXNlcm5hbWUiOiJ0cmFkZXJwZWRyb3NvIiwicm9sZSI6MSwic2NvcGUiOiJkZWZhdWx0IiwiZm9yY2VDaGFuZ2VQYXNzd29yZCI6ZmFsc2UsImV4cCI6MTc0MTc4NjI4OSwiaWF0IjoxNzQxNzU3NDg5LCJqdGkiOiI5MDFiYjVmMi1jZTM4LTQzYTMtYjE2NC1hMTYwMGI0NTVhMDYifQ.zaJndPCUiPlY1iUFwOl14r6OKjY6hibLLnuko0TsRxo"
ENDPOINT_ID=1

# Caminho base onde estão os arquivos docker-compose.yml
BASE_PATH="/var/lib/docker/volumes/portainer_data/_data/compose"

# Array com IDs dos stacks
STACK_IDS=(18  40  41  42  43  44  45  46  47  48  49)

# Loop para cada ID de stack
for STACK_ID in "${STACK_IDS[@]}"; do
  # Lê o conteúdo do docker-compose.yml para o stack atual
  STACK_FILE_PATH="$BASE_PATH/$STACK_ID/docker-compose.yml"
  if [[ -f "$STACK_FILE_PATH" ]]; then
    # Lê o conteúdo do arquivo e o formata corretamente para JSON
    STACK_FILE_CONTENT=$(jq -Rs . < "$STACK_FILE_PATH")

    # Envia a solicitação para reassociar o stack com o conteúdo do docker-compose.yml
    curl -X PUT "$PORTAINER_URL/api/stacks/$STACK_ID?endpointId=$ENDPOINT_ID" \
      -H "Authorization: Bearer $TOKEN" \
      -H "Content-Type: application/json" \
      -d "{\"StackFileContent\": $STACK_FILE_CONTENT}"

    echo -e "\nReassociado stack com ID: $STACK_ID"
  else
    echo "Arquivo docker-compose.yml não encontrado para o stack com ID: $STACK_ID"
  fi
done



#!/bin/bash

# URL do Portainer e token de autenticação
PORTAINER_URL="http://arm.sostrader.com.br:9000"
TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwidXNlcm5hbWUiOiJ0cmFkZXJwZWRyb3NvIiwicm9sZSI6MSwic2NvcGUiOiJkZWZhdWx0IiwiZm9yY2VDaGFuZ2VQYXNzd29yZCI6ZmFsc2UsImV4cCI6MTc0MTc4NjI4OSwiaWF0IjoxNzQxNzU3NDg5LCJqdGkiOiI5MDFiYjVmMi1jZTM4LTQzYTMtYjE2NC1hMTYwMGI0NTVhMDYifQ.zaJndPCUiPlY1iUFwOl14r6OKjY6hibLLnuko0TsRxo"
ENDPOINT_ID=1

# Array com IDs dos stacks
STACK_IDS=(18 40 41 42 43 44 45 46 47 48 49)

for STACK_ID in "${STACK_IDS[@]}"; do
  echo "Removendo o stack $STACK_ID sem apagar containers e volumes..."
  curl -X DELETE "$PORTAINER_URL/api/stacks/$STACK_ID?endpointId=$ENDPOINT_ID&external=1" \
    -H "Authorization: Bearer $TOKEN"
  
  echo "Recriando o stack $STACK_ID como compose..."
  
  # Caminho para o arquivo docker-compose.yml do stack
  STACK_FILE_PATH="/var/lib/docker/volumes/portainer_data/_data/compose/$STACK_ID/docker-compose.yml"
  
  if [[ -f "$STACK_FILE_PATH" ]]; then
    # Lê e formata o conteúdo do arquivo para JSON
    STACK_FILE_CONTENT=$(jq -Rs . < "$STACK_FILE_PATH")
    
    # Cria o stack como compose (Type 2)
    curl -X POST "$PORTAINER_URL/api/stacks?endpointId=$ENDPOINT_ID" \
      -H "Authorization: Bearer $TOKEN" \
      -H "Content-Type: application/json" \
      -d "{
            \"Name\": \"stack_$STACK_ID\",
            \"SwarmID\": \"\",
            \"StackFileContent\": $STACK_FILE_CONTENT,
            \"Type\": 2,
            \"Env\": []
          }"
    
    echo "Stack $STACK_ID recriado com sucesso!"
  else
    echo "Arquivo docker-compose.yml não encontrado para o stack com ID: $STACK_ID"
  fi
done








#!/bin/bash

# URL do Portainer e token de autenticação
PORTAINER_URL="http://arm.sostrader.com.br:9000"
TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwidXNlcm5hbWUiOiJ0cmFkZXJwZWRyb3NvIiwicm9sZSI6MSwic2NvcGUiOiJkZWZhdWx0IiwiZm9yY2VDaGFuZ2VQYXNzd29yZCI6ZmFsc2UsImV4cCI6MTczMDQ4Nzg4NCwianRpIjoiMjYzNmJkMjItYzU2MS00ZWI4LTkwODEtMzdjYzVkZGRiMzk5IiwiaWF0IjoxNzMwNDU5MDg0fQ$"
ENDPOINT_ID=1
SWARM_ID="hm1la57ukti77h54buqb77lty"  # Atualize com o Swarm ID correto

# Caminho onde estão os arquivos docker-compose.yml
BASE_PATH="/var/lib/docker/volumes/portainer_data/_data/compose"

# Mapeamento dos nomes dos stacks para os diretórios corretos
declare -A STACK_DIRS
STACK_DIRS=(
  ["redis"]="41"
  ["postgres"]="18"
  ["rabbitmq"]="48"
  ["n8n"]="40"
  ["oneapi"]="43"
  ["langfuse"]="42"
  ["pgadmin"]="43"
  ["erp"]="44"
  ["cloudflare"]="45"
  ["oneapi"]="46"
  ["chatllm"]="47"
  ["proxy"]="49"
)

for STACK_NAME in "${!STACK_DIRS[@]}"; do
  DIR="${STACK_DIRS[$STACK_NAME]}"
  STACK_FILE_PATH="$BASE_PATH/$DIR/docker-compose.yml"

  if [[ ! -f "$STACK_FILE_PATH" ]]; then
    echo "Arquivo docker-compose.yml não encontrado para o stack $STACK_NAME no diretório $DIR"
    continue
  fi

  # Lê e formata o conteúdo do arquivo compose
  STACK_FILE_CONTENT=$(jq -Rs . < "$STACK_FILE_PATH")

  # Verifica se o stack já existe no Portainer
  STACK_ID=$(curl -s -X GET "$PORTAINER_URL/api/stacks" \
    -H "Authorization: Bearer $TOKEN" | jq -r ".[] | select(.Name==\"$STACK_NAME\") | .Id")

  if [[ -n "$STACK_ID" ]]; then
    echo "Stack $STACK_NAME já existe (ID: $STACK_ID). Atualizando..."
    # Atualiza o stack via PUT (certifique-se de que sua versão do Portainer suporta essa operação)
    curl -s -X PUT "$PORTAINER_URL/api/stacks/$STACK_ID?endpointId=$ENDPOINT_ID" \
      -H "Authorization: Bearer $TOKEN" \
      -H "Content-Type: application/json" \
      -d "{
            \"StackFileContent\": $STACK_FILE_CONTENT,
            \"Prune\": true
          }"
    echo "Stack $STACK_NAME atualizado com sucesso."
  else
    echo "Stack $STACK_NAME não existe. Criando..."
    # Cria o stack via POST
    curl -s -X POST "$PORTAINER_URL/api/stacks?type=1&method=string&endpointId=$ENDPOINT_ID" \
      -H "Authorization: Bearer $TOKEN" \
      -H "Content-Type: application/json" \
      -d "{
            \"Name\": \"$STACK_NAME\",
            \"SwarmID\": \"$SWARM_ID\",
            \"StackFileContent\": $STACK_FILE_CONTENT,
            \"Prune\": true
          }"
    echo "Stack $STACK_NAME criado com sucesso."
  fi

  echo -e "\n---------------------------------\n"
done
