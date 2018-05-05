#!/bin/bash
# SearchSamba.bash   --    Procura pelo [Nome do Compartilhamento] até a palavra ###END###,  #
# Acionado por /srv/Projeto.Palha/ServerWebApp/scripts/MenuSamba.sh

# ----------------------------------------------------------------------------------------   #
# Ao encontrar mostrará na tela o compartilhamento. Poderá optar em excluir ou não,          #
# caso seja excluido será feito uma copia do arquivo /etc/samba/smb.conf em /tmp.            #

# ########################################################################################   #
# Licença: LGPL v3 (GNU Lesser General Public License v3.0)
# -----------------------------------------------------------------------------------------  #

echo -e "Procurar/Excluir Compartilhamento "
DateBKP=$(date +%d:%B:%Y.%H:%M:%S)

echo -n "Qual o nome do Compartilhamento? "; read ShareFinder
cat '/etc/samba/smb.conf' | sed -en '/^\['$ShareFinder'\]/,/###END###/pI'

echo "Gostaria de Apagar TODAS as Linhas mostrada? [sim] ou [não]? " ; read Answer

if [ "sim" = $Answer ]; then
    echo -e 'Fazendo backup em /tmp/ '
    cp '/etc/samba/smb.conf' '/tmp/smb.bkp'.$DateBKP
    echo -n 'Excluindo Compartilhamento! '
    sed -i '/^\['$ShareFinder'\]/,/###END###/d' '/etc/samba/smb.conf'

    else
        echo -n "Não Foram feitas mudanças no Arquivos "
fi

echo -n "Fim do processo... " ; bash /srv/Projeto.Palha/ServerWebApp/scripts/MenuSamba.sh