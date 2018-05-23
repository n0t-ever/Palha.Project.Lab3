#!/bin/bash
# MenuSamba.sh	-	Menu para centralizar as opções do Samba!
# Acionado por /srv/script/MenuUser.bash
#
# Site          : https://ornitorrincosaltitante.visualstudio.com/_git/Project.Palha.LPARII
# Autor         : Ornitorrinco (2018) 
# Manutenção    : Everton Soares de Olivera
#
# Atualizações
# 23/05/2018 - Agora com interface mais amigavel.
#
## Licença: LGPL v3 (GNU Lesser General Public License v3.0)
#-----------------------------------------------------------------------------------------
# Loop que Mostra o Menu.
while : ; do 
# Mostra na tela as seguintes opções.
SAMBA_STRING=$( dialog --stdout --title 'Menu do Samba ' --menu 'Escolha a opção: '\
0 0 0 \
1 'Para adcionar um novo compartilhamento ' \
2 'Para adcionar novos usuarios ' \
3 'Para Suspender um usuário ' \
4 'Para Procurar/Excluir um compartilhamento ' \
q 'Para Sair')
# Apertou o ESC ou CANCELAR, então vamos sair ...
[ $? -ne 0 ] && break
# De Acordo com opção dispara o programa.
  case $SAMBA_STRING in
	1)
		bash /srv/Projeto.Palha/ServerWebApp/scripts/samba/SambaShare.bash ;;
	2)
		bash /srv/Projeto.Palha/ServerWebApp/scripts/samba/adduser.bash ;;	
	3)
		bash /srv/Projeto.Palha/ServerWebApp/scripts/samba/SuspUser.bash ;;	
	4)
		bash /srv/Projeto.Palha/ServerWebApp/scripts/samba//SearchSamba.bash ;;
	q)
		break ;;
  esac
done
# Mensagem Final
dialog --title 'Encerrando aplicação' --msgbox 'Fim do processo... ' 6 40
/etc/init.d/samba restart
#Voltamos a prancheta de lançamento...
bash /srv/Projeto.Palha/ServerWebApp/MenuUser.bash
