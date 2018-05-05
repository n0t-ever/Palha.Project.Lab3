#!/bin/bash
# MenuSamba.sh	-	Menu para centralizar as opções do Samba!
# Acionado por /srv/script/MenuUser.bash
#
# Site          : https://ornitorrincosaltitante.visualstudio.com/_git/Project.Palha.LPARII
# Autor         : Ornitorrinco (2018) 
# Manutenção    : Everton Soares de Olivera
#
## Licença: LGPL v3 (GNU Lesser General Public License v3.0)
#-----------------------------------------------------------------------------------------

echo "MENU: Escolha a opção:"
echo  " 1 : Para adcionar um novo compartilhamento"
echo  " 2 : Para adcionar novos usuarios"
echo  " 3 : Para Suspender um usuário "
echo  " 4 : Para Procurar/Excluir um compartilhamento "
echo  " q : Para Sair"

while :
do
  read SAMBA_STRING
  case $SAMBA_STRING in
	1)
		echo "Novo Compartilhamento!"
		bash /srv/Projeto.Palha/ServerWebApp/scripts/samba/SambaShare.bash
		break
		;;
	2)
		echo "Novo Usuario "
		bash /srv/Projeto.Palha/ServerWebApp/scripts/samba/adduser.bash
		break
		;;	
	3)
		echo "Suspender Usuario"
		bash '$(pwd)/Samba/SuspUser.bash'
		break
		;;	
	4)
		echo "Procurar/Excluir Compartilhamento "
		bash /srv/Projeto.Palha/ServerWebApp/scripts/samba//SearchSamba.bash
		break
		;;
	q|Q)
		echo "That's all folks!"
		break
		;;
	*)
		echo "Digite uma opção valida"
		;;
  esac
done
echo  " "
echo -e "Fim do processo..." ; /etc/init.d/samba restart

#Voltamos a prancheta de lançamento...
bash /srv/Projeto.Palha/ServerWebApp/MenuUser.bash