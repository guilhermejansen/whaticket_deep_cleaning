#!/bin/bash

# Diretório base para as pastas das companhias
BASE_DIR="/root/deploy/multi100/backend/public"

# Garantir que o diretório base existe
mkdir -p "$BASE_DIR"

# Loop para criar 10 pastas de companhias
for i in {1..10}; do
  COMPANY_DIR="$BASE_DIR/company$i"
  mkdir -p "$COMPANY_DIR"

  # Dentro de cada pasta da companhia, criar arquivos que variam de 1 a 4 meses de idade
  for j in {1..5}; do
    FILE_PATH="$COMPANY_DIR/file$j.txt"
    echo "Test content for file$j in company$i" > "$FILE_PATH"
    # Define a data de modificação dos arquivos, alternando entre 1 mês e 4 meses
    if [ $((j % 2)) -eq 0 ]; then
      # Arquivos pares: entre 1 e 2 meses atrás
      touch -d "$((1 + j % 2)) months ago" "$FILE_PATH"
    else
      # Arquivos ímpares: entre 3 e 4 meses atrás
      touch -d "$((3 + j % 2)) months ago" "$FILE_PATH"
    fi
  done
done

echo "Pastas das companhias e arquivos de teste criados com sucesso em $BASE_DIR."
