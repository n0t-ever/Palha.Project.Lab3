#!/bin/bash
#ScriptApache.bash  - Adicionar um novo Virtual Hosts ao Apache.
#  Acionado por /srv/Projeto.Palha/ServerWebApp/MenuUser.bash		
# -----------------------------------------------------------------------------------------  #
# Este Programa recebe o nome do site e do dominio, será criado a pasta e atribuido o usuário#
# www-data como dono. Os arquivos do site não será criado.
#
## Atualizações
# 23/05/2018 - Agora com interface mais amigavel
#
#  Licença: LGPL v3 (GNU Lesser General Public License v3.0)								 #
#  #######################################################################################   #
# Vamos pegar algumas informações com o usuario.
SiteConf=$( dialog --stdout --inputbox 'Entre com o Nome do site: '
DomSite=$( dialog --stdout --inputbox 'Entre com o dominio' 0 0 "(.org, .com)"
WebAdmin=$( dialog --stdout --inputbox 'Email do Web Admin:' 0 0
if [ -z "${WebAdmin}" ]; then
    dialog --title 'Email' --msgbox 'O email está vazio, será incluido um teste@teste.com' 6 40
fi  
# Define o caminho do sitio
PathSite="/var/www/${SiteConf}"
# A pasta será criada e o usuario www-data será o dono.
mkdir $PathSite ; chmod 755 $PathSite; chown -R "www-data:www-data" $PathSite 
# Criar o arquivo com as configurações do virtual hosts
touch /etc/apache2/sites-available/$SiteConf.conf
# Atribuir permisão para os arquivos
chmod 755 '/etc/apache2/sites-available/'$SiteConf.conf

# Vamos construir o arquivo com as opções...
echo "<VirtualHost *:80>" >> /etc/apache2/sites-available/$SiteConf.conf
# Se a variavel WebAdmin estiver vazia, será inerido teste@teste.com
echo "ServerAdmin ${WebAdmin:-teste@teste.com} " >> /etc/apache2/sites-available/$SiteConf.conf
echo "ServerName ${SiteConf}" >>  /etc/apache2/sites-available/$SiteConf.conf
echo "ServerAlias www.${SiteConf}${DomSite} " >> /etc/apache2/sites-available/$SiteConf.conf
echo "DocumentRoot " $PathSite >> /etc/apache2/sites-available/$SiteConf.conf
echo "ErrorLog ${APACHE_LOG_DIR}/error.log " >> /etc/apache2/sites-available/$SiteConf.conf
echo "CustomLog ${APACHE_LOG_DIR}/access.log combined " >>  /etc/apache2/sites-available/$SiteConf.conf
echo "</VirtualHost>" >>  /etc/apache2/sites-available/$SiteConf.conf
# Colocando o nome do site no arquivo hosts.
echo "www.${SiteConf}${DomSite}" >> /etc/hosts

# #Vamos mexer mesmo no DNS?
# #echo $SiteConf + " IN 	A 	192.168.34.55"	>> /etc/bind/zones/db.Replicante.org
#Vamos habilitar o site.
a2ensite $SiteConf.conf
#Reiniciando o serviço
service apache2 stop && service apache2 start
#Voltamos a prancheta de lançamento.
bash /srv/Projeto.Palha/WebServerApp/MenuUser.bash
