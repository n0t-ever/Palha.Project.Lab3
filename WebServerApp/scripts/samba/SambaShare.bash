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
function LoadStart () {
( echo 40 ; sleep 1; echo 75 ; sleep 1; echo 100; sleep 1 ) | dialog --title 'Samba' --gauge '\nAdcionando Novo compartilhamento' 8 40 60 
}
function CopyTemplate() {
echo 'public = yes' ; echo 'writable = yes' ; echo 'guest ok = yes'
echo 'browseable = yes' ; echo '################' ; echo '###Gerado de Forma Automática###'
}

dialog --title 'Samba' --infobox '\nScript para configurar novos compartilhamentos ' 0 0
#Criar o nome e o diretorio.
FolderShare=$( dialog --inputbox --stdout 'Entre com o nome do novo compartilhamento' 0 0 )
mkdir /srv/$FolderShare ; chmod 760 /srv/$FolderShare
echo ""["$FolderShare"]"" >> /etc/samba/smb.conf
#Descrição do compartilhamento
CommentFolder=$( dialog --stdout --inputbox 'Descrição do compartilhamento ' 0 0 )
echo "comment = "+ $CommentFolder >> /etc/samba/smb.conf
echo "path = /srv/"$FolderShare >> /etc/samba/smb.conf

dialog --title 'public' --yesno "\nUsar as configurações expressas\n\n" 0 0

	if [ $? -eq 0 ]; then
		CopyTemplate >> /etc/samba/smb.conf
		echo "###END###" >> /etc/samba/smb.conf
		echo -e " " >> /etc/samba/smb.conf
		LoadStart
	else
	
#A variavel proximo faz ir a proxima tela. Escolhido entre sim ou não, o botão Cancel inclui a opção comentada.
#A tecla ESC sai do programa.
proxima=primeira
while : ; do
 case "$proxima" in
 primeira)
  	proxima=browseable
	dialog --backtitle 'Criar Compartilhamento do Samba' --msgbox 'Bem vindo!!' 0 0
	;;
 browseable)
 	proxima=publico	
	dialog --title 'Browseable' --yesno '\nVai mostrar no explorer [no]/[yes]. \
	ou pressione CANCEL para ignorar\n\n' --help-button --help-label 'CANCEL' 0 0
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
	dialog --title 'public' --yesno '\nDiretorio publico, [no]/[yes] ou pressione CANCEL para ignorar\n\n' \
	--help-button --help-label 'CANCEL' 0 0
		if [ $? -eq 0 ]; then
			echo 'public = yes' >> /etc/samba/smb.conf
		fi
		if  [ $? -eq 1 ]; then
			echo 'public = no' >> /etc/samba/smb.conf
		else
            		echo '#public = yes'  >> /etc/samba/smb.conf  
		fi
		;;
 escrita)
	proxima=grupo
	dialog --title 'writable' --yesno 'Permitir escrita digite [no]/[yes] ou pressione enter para ignorar' \
	--help-button --help-label 'CANCEL' 0 0
		if [ $? -eq 0 ]; then
			echo "writable = yes " >> /etc/samba/smb.conf
		fi
		if  [ $? -eq 1 ]; then
			echo "writable = no " >> /etc/samba/smb.conf
		else
			echo "#writable = no" >> /etc/samba/smb.conf
		fi
		;;
 grupo)
	proxima=user
	nome=$( dialog --stdout --inputbox 'Colocar o grupo do usuarios validos ou pressione CANCEL para ignorar: ' \
	0 0 "digite @Nome do grupo")
		if [ ! "$nome"]; then
			echo "#force group = " >> /etc/samba/smb.conf
		else
			echo "force group = "$nome >> /etc/samba/smb.conf
		fi	
		;;
 user)
	proxima=exten
	nome2=$( dialog --stdout --inputbox 'Usuarios Validos ou pressione CANCEL para ignorar: ' 0 0 )
		if [ ! "$nome2"]; then
			echo "#valid users = " >> /etc/samba/smb.conf
		else
			echo "valid users = "$nome2 >> /etc/samba/smb.conf
		fi	
		;;
exten)
	UserHide=$( dialog  --stdout --inputbox 'extenções de arquivos ignorada: ' 0 0 "digite *.ini ")
		if [ ! "$UserHide" ]; then
			echo "#hide files = /*.ini" >> /etc/samba/smb.conf
		else
			echo "hide files = "$UserHide >> /etc/samba/smb.conf
		fi
		;;
		
echo "###END###" >> /etc/samba/smb.conf ; echo -e " " >> /etc/samba/smb.conf
LoadStart

fi
	retorno=$?
	[ $retorno -eq 255 ] && break	#ESC
esac; done
dialog --title 'Parabens' --msgbox 'That's all folks!' 6 40
/etc/init.d/samba stop && /etc/init.d/samba start
