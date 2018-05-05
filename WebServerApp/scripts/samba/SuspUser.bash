#!/bin/bash
# SuspUser.bash	- Bloqueia o acesso de um usuario ao sistema, incluindo home directory.      #
 
#  Acionado por /srv/Projeto.Palha/ServerWebApp/scripts/MenuSamba.sh												 #
# -----------------------------------------------------------------------------------------  #

# Este Programa recebe o login e procura se login existem, caso positivo o programa verifica 
# se o usuario está logado, se sim exibe uma mensagem para o usuario e encerra os processos
# a pasta do usuario será fechada para negar escrita e leitura. A senha seráá alterada.

#  Licença: LGPL v3 (GNU Lesser General Public License v3.0)								 #
#  #######################################################################################   #

HomeDir='/home'; Secs=10
echo "Please enter Username:" ; read UserName
id $UserName &> /dev/null
if [ $? -eq 0 ]; then
    echo "$UserName Existe."
else
    echo "$UserName Não Existe"; bash '/srv/scripts/MenuUser.bash'
exit 0
fi

echo "Mudando o password para account $UserName..." ; read Pass
echo -e "$Pass\n$Pass" | passwd $UserName
echo -e "$Pass\n$Pass" | smbpasswd -a $UserName

echo "Veremos se o $UserName está logado..."
if who|grep "$UserName" > /dev/null ; then
	for tty in $(who | grep $UserName | awk '{print $2}'); do

	cat << "EOF" > /dev/$tty
******************************************************************************
URGENTE COMUNICADO DA ADMINISTRAÇÂO
Esta conta foi suspensa e você será logged out em $secs segundos. 
Se tiver alguma duvida, entre em contato com um supervisor or com
Ornitorrinco Saltitante Diretor de Tecnologia.
******************************************************************************
EOF
done

echo "(Aviso $Username, Log out in $Secs segundos)"
sleep $Secs
jobs=$(ps -u $UserName | cut -f1)
kill -s HUP $jobs 						# Envia sinal "Hang Up" para os processos dele.
sleep 1 								# Da um segundos... 
kill -s KILL $jobs > /dev/null 2>1 		# E passa o "rodo"...
echo "$UserName Estava logado. Acaba de ser deslogado.."
fi

#Vamos fechar o acesso ao diretorio da /home.
chmod 000 $HomeDir/$UserName
echo "Account $UserName foi temporariamente suspensa."

echo -e "Fim do processo..." ; bash /srv/Projeto.Palha/ServerWebApp/scripts/MenuSamba.sh