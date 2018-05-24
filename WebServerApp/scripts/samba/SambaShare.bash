#!/bin/bash
# SambaShare.bash	- Criar um compartilhamento do Samba, não será alterada as opções existente
# Acionado por /srv/Projeto.Palha/ServerWebApp/scripts/MenuSamba.sh
#
# -----------------------------------------------------------------------------------------  #
# Este Programa recebe o nome do compartilhamento cria um breve comentario, pode ser escolhido#
# uma forma expressa ou adcionando as opções uma a uma.
#
# Atualizações
# 23/05/2018 - Agora com interface mais amigavel
#
## Licença: LGPL v3 (GNU Lesser General Public License v3.0)
#  #######################################################################################   #
#Funções
function CopyTemplate() {
echo 'public = yes' ; echo 'writable = yes' ; echo 'guest ok = yes'
echo 'browseable = yes' ; echo '################' ; echo '###Gerado de Forma Automática###'
}

echo "Script para configurar novos compartilhamentos no SAMBA "
DefaultVariavel="no"

echo -n "Entre com o nome do novo compartilhamento "; read FolderShare
mkdir /srv/$FolderShare ; chmod 760 /srv/$FolderShare

echo ""["$FolderShare"]"" >> /etc/samba/smb.conf
echo "Descrição do compartilhamento " ; read CommentFolder
echo "comment = "+ $CommentFolder >> /etc/samba/smb.conf
echo "path = /srv/"$FolderShare >> /etc/samba/smb.conf

echo -n "Usar as configurações expressas, (s)im ou (n)ão " ; read EXPRESS

if [ $EXPRESS == "s" ]; then
		CopyTemplate >> /etc/samba/smb.conf
		echo "###END###" >> /etc/samba/smb.conf
		echo -e " " >> /etc/samba/smb.conf
	else
		echo "Configurar"	
	
proxima=primeira
# Vamos começsr a festa
while : ; do
 case "$proxima" in
  primeira)
  	proxima=browseable
	dialog --backtitle 'Criar Compartilhamento do Samba' --msgbox 'Bem vindo!!' 0 0
	;;
 browseable)
 	proxima=publico	
	dialogb --title 'Browseable' --yesno '\nVai mostrar no explorer digite [no]/[yes]. \
	ou pressione CANCEL para ignorar\n\n' 0 0
		if [ $? -eq 0 ]; then
			echo "browseable = yes ">> /etc/samba/smb.conf
		fi
		if  [ $? -eq 1 ]; then
			echo "browseable = no ">> /etc/samba/smb.conf
		else
			echo "#browseable = yes ">> /etc/samba/smb.conf
		fi
		;;
 publico)
 	proxima=escrita
	"Diretorio publico, digite [no]/[yes] ou pressione enter para ignorar"
	read UserDir
		if [ ! "$UserDir" ]; then
			echo "#public ="$DefaultVariavel >> /etc/samba/smb.conf
		else
            echo "public = "$UserDir >> /etc/samba/smb.conf  
		fi
escrita)

echo "Permitir escrita digite [no]/[yes] ou pressione enter para ignorar"
	read UserWri
		if [ ! "$UserWri" ]; then
			echo "#writable = "$DefaultVariavel >> /etc/samba/smb.conf
		else
			echo "writable = "$UserWri >> /etc/samba/smb.conf
		fi

echo "Permitir Grupos /Colocar o grupo do usuarios validos digite [@Nome do grupo] ou pressione enter para ignorar"
	read UserGrup
		if [ ! "$UserGrup" ]; then
			echo "#force group = "$DefaultVariavel >> /etc/samba/smb.conf
		else
			echo "force group = "$UserGrup >> /etc/samba/smb.conf
			fi	

echo "Grupos Validos/Colocar o grupos dos usuarios: "
	read UserValid
		if [ ! "$UserValid" ]; then
			echo "#valid users = "$DefaultVariavel >> /etc/samba/smb.conf
		else
			echo "valid users = "$UserValid >> /etc/samba/smb.conf
		fi	
	
echo "extenções de arquivos ignorada, digite [ /*.ini ], respeitando o espaço entre cada extenção"
	read UserHide
		if [ ! "$UserHide" ]; then
			echo "#hide files = /*.ini" $DefaultVariavel >> /etc/samba/smb.conf
		else
			echo "hide files = "$UserHide >> /etc/samba/smb.conf
		fi
	
echo -e "Fim das escolhas..." ; echo -e "Adcionando Novo compartilhamento"
echo "###END###" >> /etc/samba/smb.conf ; echo -e " " >> /etc/samba/smb.conf

fi	
esac
done
echo "That's all folks!"
/etc/init.d/samba restart ; bash /srv/Projeto.Palha/ServerWebApp/scripts/MenuSamba.sh
