#!/bin/bash
# adduser.bash	- Adiciona um novo usuário ao sistema, incluindo a config de home directory. #
 
#  Acionado por /srv/Projeto.Palha/ServerWebApp/scripts/MenuSamba.sh												 #
# -----------------------------------------------------------------------------------------  #

# Este Programa recebe o nome do login do usuário, será criado a pasta e o usuário			 #
# pode ser criado um grupo novo ou adcionar em grupo que já existe.
 						 #
#  Licença: LGPL v3 (GNU Lesser General Public License v3.0)								 #
#  #######################################################################################   #

HDir="/home" ; echo "Adicionar Usuário ao host $(hostname)"

echo -n "login: " ; read LoginName
HomeDir=$HDir/$LoginName

#echo -n "Nome Completo: " ; read FullName
mkdir $HomeDir ; chmod 755 $HomeDir
useradd --shell /bin/bash --home $HomeDir $LoginName
chown -R ${LoginName}:${LoginName} $HomeDir

echo  "Criar grupo: (s)im ou (n)ão: " ; read RESP
	if [ $RESP == 's' ] || [ $RESP == 'sim' ]; then
	   	echo -n "Nome do grupo: "
    	read GRUP; addgroup $GRUP
    	adduser $LoginName $GRUP ; 
	fi

echo  "Adicionar $(LoginName) a um grupo existente: (s)im ou (n)ão: "; read RESP
	if [ $RESP == "s" ] || [ $RESP == "sim" ]; then
    	echo -n "adcionar usuario em um grupo existente: "
    	read GRUPO; adduser $LoginName $GRUPO
	fi

echo -n "Criar senha..:."; read Pass
echo -e "$Pass\n$Pass" | passwd $LoginName
echo -e "$Pass\n$Pass" | smbpasswd -a $LoginName

echo -e "Fim do processo..." ; bash /srv/Projeto.Palha/ServerWebApp/scripts/MenuSamba.sh