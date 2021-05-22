# terraform-jenkins1
Ejemplo de ejecucion de teraform desde jenkins para aws

Crea o destruye con un pipeline en jenkins una infraestructura en AWS que consiste en:

1. 1 VPC
2. 3 subnet en diferente zona de disponibilidad
3. 3 grupos de seguridad
4. 1 Gateway que comunica la VPC con el exterior
5. 3 instancias EC2 cada una en una zona de disponibilidad

El estado de terraform se guarda en un bucket s3 que se configura en el archivo backend.tf

## Entorno de ejecucion

El desarrollo y pruebas se realizó con el siguiente entorno:

Jenkins 2.293 en lenguaje español ejecutado como docker con:
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
5. Crear un usuario en la cuenta de AWS con permisos de creacion de instancias EC2, VPC, IGW, Subnet, security groups, en el archivo policy.js se listan los permisos que se usaron para el usuario creado, descargar las credenciales del usuario creado
6. Configurar las credenciales del usuario AWS en jenkins por la opcion Administrar Jenkins-->Manage Credentials-->Global-->ADD Credentials --> Kind: secret text crear dos variables: AWS_ACCESS_KEY_ID y AWS_SECRET_ACCESS_KEY, las credenciales van en el campo Secret
7. Crear un bucket s3 en la cuenta de aws por linea de comandos, el comando para crear el bucket es: **aws s3api create-bucket --bucket <nombre_del_bucket>**
8. Guardar el **nombre_del_bucket** en el archivo backend.tf linea 12 

# Creacion del Job en jenkins

1. Click en nueva tarea dar un nombre por ejemplo "Terraform-AWS" 
2. Seleccionar Pipeline, click en OK
3. En Pipeline seleccionar "Pipeline script from SCM"
4. En SCM seleccionar GIT
5. En repository url copiar la url del repositorio Github (https://github.com/erwindaniel/terraform-jenkins1.git) o el que corresponda si es un fork
6. En credentials dejar en blanco, por ser un proyecto público no necesita credenciales
7. En Branch Specifier digitar "*/main" (sin comillas)
8. en script Path digitar: "Jenkinsfile" (sin comillas)
9. Click en guardar
10. Click en Construir Ahora

## Ejecucion del Job

Si todo se ha configurado correctamente en la opcion status se verá la ejecucion del job
El stage Aproval requiere accion del usuario, dar click sobre el y saldrá un cuadro de dialogo con las opciones apply o destroy y los botones Execute o abort
Si se selecciona apply y Execute se creará la infraestrcutura o los cambios
Si se selecciona destroy y Execute se destruirá la infraestructura
Si se selecciona Abort con cualquier opcion no se ejecuta ningun comando terraform y se termina el Job
