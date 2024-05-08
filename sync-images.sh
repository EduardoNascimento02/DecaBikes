#!/bin/bash

efs_state=$(aws efs describe-file-systems | jq -r '.FileSystems[].LifeCycleState')
if [[ "$efs_state" != "available" ]]; then
  echo "EFS Não disponível. Pulando sincronização."
  exit 1
fi

echo "Montando o EFS file system..."
sudo aws efs mount file-system-id:fs-0ffa25d8387046409 /efs

echo "Sincronizando imagens com EFS..."
rsync -avz ./images/ /efs/

echo "Desmontando EFS file system..."
sudo aws efs umount /efs

echo "Sincronização concluída."