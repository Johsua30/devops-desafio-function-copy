# Creación de dos storage account y una app para copiar de uno a otro

En este desafío se debe usar Terraform para crear en Azure dos storage account y luego mediante una Azure function app que los archivos subidos a uno se copien en el otro.

###  Requisitos previos

Instalar:
- Azure CLI
- Terraform
- Python
- Azure Functions Core Tools

### Estructura del Proyecto
azure-function-copy/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
├── function/
│   ├── BlobTriggerFunction/
│   │   ├── __init__.py
│   │   ├── function.json
│   ├── requirements.txt
│   ├── host.json

### Autenticarse en Azure
``` az login ```

### Despliegue
``` cd terraform ```

Inicializamos o actializamos el directorio de trabajo para terraform.
``` terraform init ```

Formateamos los archivos .tf para asegurar consistencia.
``` terraform fmt ```

Validamos los archivos en el directorio.
``` terraform validate ```

Obtenemos una vista previa de las acciones a realizar.
``` terraform plan ```

Ejecutamos las acciones planificadas.
``` terraform apply ```

### Empaquetar/Publicar la Azure Function

Nos movemos a la carpeta function.
``` cd ../function ```

Publicamos la función cambiando 12345 por el número al azar que se asignó al ejecutar el comando terraform apply. Ese número se muestra en el output.
``` func azure functionapp publish func-copy-12345 --python ```