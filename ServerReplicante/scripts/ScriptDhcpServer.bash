#!/bin/bash
# ScriptDhcpServer.bash - Configurar range e ip fixo do DHCP Server.  #
# Acionado por /srv/Projeto.Palha/MenuUserGw.bash                              #
# -----------------------------------------------------------------   #
# Este Programa recebe o id da rede a mascara e o range de endereços  #
# é criado um arquuivo temporario, no final do programa é feito o bkp #
# do arquivo existente e substituido pelo temporario                  #

# Licença: LGPL v3 (GNU Lesser General Public License v3.0)           #
# #################################################################   #
#   Variaveis
DateBKP=$(date +%d:%B:%Y.%H:%M:%S)
echo 'Configurando a interface de rede'

# Obtendo dados para criar o arquivo de configuração:
echo "Digite o endereço da rede: "; read IpAdress
echo "Digite a máscara da rede: "; read SubMask
echo "Digite o range de endereços disponíveis na rede separados por vírgula e sem espaço! "; read NetRange
echo "Informe os endereços de DNS separados por virgula sem espaço!" ; read DNS
echo \n
#  Montando o arquivo temporário
echo "ddns-update-style none;" > dhcpconfig.auto
echo "authoritative;" >> dhcpconfig.auto
echo "subnet $IpAdress netmask $SubMask {" >> dhcpconfig.auto
echo "range dynamic-bootp $NetRange;" >> dhcpconfig.auto
echo " " >> dhcpconfig.auto
echo "option subnet-mask $SubMask;" >> dhcpconfig.auto
echo "option domain-name-servers $DNS;" >> dhcpconfig.auto
echo "default-lease-time 21600;" >> dhcpconfig.auto
echo "max-lease-time 43200;" >> dhcpconfig.auto
echo "log-facility local7;" >> dhcpconfig.auto
echo " " >> dhcpconfig.auto
sed -i 's|,| |' dhcpconfig.auto
echo "}" >> dhcpconfig.auto

echo " # COMPUTADORES COM IP FIXO: " >> dhcpconfig.auto

echo -n "Deseja inserir algum IP fixo? (s/N)    " ; read AnswerHost
while [ $AnswerHost == 's' ] || [ $AnswerHost == 'S' ]; do

        echo "Digite o nome do host:" ; read HostName ; echo " host $HostName {" >> dhcpconfig.auto
        echo "Digite o endereço MAC:" ; read MAC ; echo " hardware ethernet $MAC;" >> dhcpconfig.auto
        echo "Digite o número de IP:" ; read IP ;  echo " fixed-address $IP;" >> dhcpconfig.auto     
        echo " }" >> dhcpconfig.auto
        echo " "
        echo -n 'Deseja Adcionar Mais? (s/N)    '; read OP

    if [ $OP == 'n' ] || [ $OP == 'N' ]; then
            break
    fi
done
echo \n

echo 'Arquivo DHCP Conf gerado com Sucesso! '; cat dhcpconfig.auto
echo "Colocar a conf. em produção em /etc/dhcp/dhcpd.conf? (s/N)" ; read AnswerMove

if [ $AnswerMove == 's' ] || [ $AnswerMove == 'S' ]; then
    mv /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.bkp.$DateBKP
    mv dhcpconfig.auto /etc/dhcp/dhcpd.conf
fi

echo "Reiniciando o servdidor dhcp…"; /etc/init.d/isc-dhcp-server restart
bash /srv/Projeto.Palha/ServerReplicante/MenuUserGw.bash