#!/bin/bash
# MenuUser.sh	-	Menu para centralizar as opções do Samba & Apache!
#
# Site          : https://ornitorrincosaltitante.visualstudio.com/_git/Project.Palha.LPARII
# Autor         : Ornitorrinco (2018) 
# Manutenção    : Everton Soares de Olivera
#
## Licença: LGPL v3 (GNU Lesser General Public License v3.0)
##------------------------------------------------------------------------------------------

if [ 'root' != `whoami` ]; then
	echo " Quem não é movido a Gasolina, precisa de Shell?! "
	exit 1
fi

echo -e " Choose your destiny: escolha a opção:"
echo "1 : Para Conf Samba e Gerenciamento de usuários; "
echo "2 : Para Adcionar Virtual Site ao Apache; "

echo "3 : Para Sair"

while :
do
  read INPUT_STRING
  case $INPUT_STRING in
	1)
		echo "Samba & Usuários... "
		bash /srv/Projeto.Palha/ServerWebApp/scripts/MenuSamba.sh
		break
		;;
	2)
		echo "Apache & Virtual-Sites"
		bash /srv/Projeto.Palha/ServerWebApp/scripts/ScriptApache.bash
		break
		;;
	3)
		echo "See you again!"
		break
		;;
	*)
		echo "Digite uma opção valida"
		;;
  esac
done
echo 
echo "That's all folks!"