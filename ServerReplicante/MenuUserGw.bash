#!/bin/bash
# MenuUserGw.bash	-	Menu para centralizar as opções do Firewall & DHCP Server!
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
echo "1 : Configurar range e ip fixo do DHCP Server; "
echo "2 : Parar Firewall&Roteamento; "
echo "3 : Restart do Firewall; "

echo "Q : Para Sair"

while :
do
  read INPUT_STRING
  case $INPUT_STRING in
	1)
		echo "DHCP Server "
		bash /srv/Projeto.Palha/ServerReplicante/ScriptDhcpServer.bash
		break
		;;
	2)
		echo "PARAR Firewall&Roteamento de pacotes pelo Kernel"
		service firewall stop
		break
		;;
    2)
		echo "INICIAR Firewall&Roteamento de pacotes pelo Kernel"
		service firewall start
		break
		;;
	q|Q)
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