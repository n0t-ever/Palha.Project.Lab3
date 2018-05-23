#!/bin/bash
# MenuUser.sh	-	Menu para centralizar as opções do Samba & Apache!
#
# Site          : https://ornitorrincosaltitante.visualstudio.com/_git/Project.Palha.LPARII
# Autor         : Ornitorrinco (2018) 
# Manutenção    : Everton Soares de Olivera
#
# Atualizações
# 23/05/2018 - Agora com interface mais amigavel
#
## Licença: LGPL v3 (GNU Lesser General Public License v3.0)
##------------------------------------------------------------------------------------------

# Verificar se o usuario é o root
if [ 'root' != `whoami` ]; then
	dialog --msgbox ' Quem não é movido a Gasolina, precisa de Shell?! ' 5 40
	exit 1
fi

#Loop que mostra o Menu
while : ; do
INPUT_STRING=$( dialog --stdout --menu 'Escolha a Opção: ' 0 0 0 \
Samba ': Para Conf Samba e Gerenciamento de usuários; ' \
Apache ': Para Adcionar Virtual Site ao Apache; ' \
Sair ': Para Sair; ')
# Apertou o ESC ou CANCELAR, então vamos sair ...
[ $? -ne 0 ] && break
# De Acordo com opção dispara o programa.
case $INPUT_STRING in
	Samba)
		bash /srv/Projeto.Palha/ServerWebApp/scripts/MenuSamba.sh
		;;
	Apache)
		bash /srv/Projeto.Palha/ServerWebApp/scripts/ScriptApache.bash
		;;
	Sair)
		break ;;
  esac
done
# Mensagem Final
dialog --title 'Encerrando aplicação' --msgbox 'Tchau Tia! ' 6 40
