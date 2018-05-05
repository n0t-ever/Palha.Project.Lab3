#!/bin/bash
#ScriptApache.bash  - Adicionar um novo Virtual Hosts ao Apache.
#  Acionado por /srv/Projeto.Palha/ServerWebApp/MenuUser.bash		
# -----------------------------------------------------------------------------------------  #
# Este Programa recebe o nome do site e do dominio, será criado a pasta e atribuido o usuário#
# www-data como dono. Os arquivos do site não será criado.

#  Licença: LGPL v3 (GNU Lesser General Public License v3.0)								 #
#  #######################################################################################   #

echo -n "Entre com o Nome do site: " ; read SiteConf
echo -n "Entre com o dominio (.org, .com)" ; read DomSite

PathSite="/var/www/${SiteConf}"
mkdir $PathSite ; chmod 755 $PathSite; chown -R "www-data:www-data" $PathSite 
touch /etc/apache2/sites-available/$SiteConf.conf
chmod 755 '/etc/apache2/sites-available/'$SiteConf.conf

echo "<VirtualHost *:80>" >> /etc/apache2/sites-available/$SiteConf.conf

echo -n "Email do Web Admin: " ; read WebAdmin
if [ -z "${WebAdmin}" ]; then
    echo "O email está vazio, será incluido um teste@teste.com"
fi  

echo "ServerAdmin ${WebAdmin:-teste@teste.com} " >> /etc/apache2/sites-available/$SiteConf.conf
echo "ServerName ${SiteConf}" >>  /etc/apache2/sites-available/$SiteConf.conf
echo "ServerAlias www.${SiteConf}${DomSite} " >> /etc/apache2/sites-available/$SiteConf.conf
echo "DocumentRoot " $PathSite >> /etc/apache2/sites-available/$SiteConf.conf
echo "ErrorLog ${APACHE_LOG_DIR}/error.log " >> /etc/apache2/sites-available/$SiteConf.conf
echo "CustomLog ${APACHE_LOG_DIR}/access.log combined " >>  /etc/apache2/sites-available/$SiteConf.conf
echo "</VirtualHost>" >>  /etc/apache2/sites-available/$SiteConf.conf
echo "www.${SiteConf}${DomSite}" >> /etc/hosts

# #Vamos mexer mesmo no DNS?
# #echo $SiteConf + " IN 	A 	192.168.34.55"	>> /etc/bind/zones/db.Replicante.org

a2ensite $SiteConf.conf ; service apache2 restart