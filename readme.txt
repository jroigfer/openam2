IMPORTANT!!!!
=============

-La DNS para esta instancia de openam debe ser distinta a la otra, pero solo la cadena openam, el resto (bancsabadell.com) debe ser igual o fallara al intentar logarse con amadmin por el cookie domain
-En la configuracion del docker-compose hay que especificar la DNS, que debea ser distinta a la otra instancia de openam
-En el docker compose el puerto expuesto y el de docker debe ser distinto al de la otra instancia
-Hay que ejecutar los siguientes comandos especificando la nueva dns para que modifique los ficheros necesarios:
find ./config/template/xml -type f -exec sed -i 's/openam.bancsabadell.com/nuevo_openam..bancsabadell.empleados.com/g' {} +
find ./config/config/xml -type f -exec sed -i 's/openam.bancsabadell.com/nuevo_openam.bancsabadell.empleados.com/g' {} +

-Hay que modificar el fichero onfig/bootstrap y especifiar el nombre y puerti corrrecto de la iagen de opendj y la nueva DNs de openam

USERS
======
Default User [amAdmin] -> Forgerock
Default Policy Agent [UrlAccessAgent] -> Forgerock1
config directory:  /root/openam

About the docker image
======================
The docker image downloads a stable version of openam (13) 
As we keep the config of openam in a mounted volume and we store it and version it in Git we need to take into 
account that the config works for a particular version. It is likely that in newer snapshots something has changed.
In this case we would need to config openam from scratch (knowing exactly how we did it before) to generate a brand new compatible 
config.

Troubleshooting generating a config the first time
==================================================
For some reason the generation of a config the first time you want to do an install from scratch (without having working config files already)
when you try to start with docker-compose you get an error that aborts the setup (so you can't get proper setup config files).
I guess this has something to do with the fact that docker-compose mounts a directory for the setup.
The workaround for the first time is NOT to use docker-compose, use the docker-file instead. Do the setup and then you will have
the proper config files inside the container (however you will not be able to access to them because you don't use a docker-compose
and so the volume is not mounted this time). Use docker export to export all the content of the container outside and then copy the
/root/openam folder holding the setup to your external mounted folder. Then you can start with docker-compose again and this 
setup will be used.
This is a way to share and version the setup (config files).


