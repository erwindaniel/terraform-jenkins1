# terraform-jenkins1
Ejemplo de ejecucion de teraform desde jenkins para aws

Crea o destruye con un pipeline en jenkins una infraestructura en AWS que consiste en:

1. 1 VPC
2. 3 subnet en diferente zona de disponibilidad
3. 3 grupos de seguridad
4. 1 Gateway que comunica la VPC con el exterior
5. 3 instancias EC2 cada una en una zona de disponibilidad

## Entorno de ejecucion

Jenkins 2.293 ejecutado como docker con:
docker run -d -p 8081:8080 -p 50000:50000 --name jenkinsver -v jenkins:/var/jenkins_home -e TZ=America/Bogota -it jenkins/jenkins

Terraform v0.15.3
on linux_amd64

S.O Red Hat Enterprise Linux release 8.2 (Ootpa)

Docker version 19.03.13, build 4484c46d9d


## Configuraciones Previas

1. Instalar los plugins recomendados al instalar jenkins
2. Instalr plugin Terraform
3. Configurar instalacion de terraform por Administrar jenkins-->Global Tools Configuration dar nombre terraform
4. Generar una clave keygen para las llaves de las instancias con el comando ssh-keygen -t rsa (este paso es opcional) reemplazar el contenido del archivo .ssh/id_rsa.pub en la linea 11 del archivo instances.tf
5. Crear un usuario en la cuenta de AWS con permisos de creacion de instancias EC2, VPC, IGW, Subnet, security groups

