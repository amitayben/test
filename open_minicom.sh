#!/bin/bash

sleep 10

open_minicom(){
PORT_IP=2
PORT_IP=$((PORT_IP+$1))
gnome-terminal -t "Minicom port $1 - 192.168.1.$PORT_IP" -x ./tmp_script"$1".sh
#./minicom_PORT.sh "$PORT_NUM"
}

generate_script(){
echo "$1"
PORT_NUM="$1"
#PORT_IP=2
#PORT_IP=$((PORT_IP+$1))
#gconftool-2 --set /apps/gnome-terminal/profiles/Default/title --type=string "Minicom port $PORT_NUM"
#############################generat script
touch tmp_script"$1".sh
chmod 777 tmp_script"$1".sh
cat <<EOT >> tmp_script"$1".sh
#!/usr/bin/expect -f
spawn sudo minicom -D /dev/ttyUSB$PORT_NUM
expect {
-re ".*sword.*" {
    exp_send "P@ssw0rd\r"
}
}
interact

###############################
#open terminal

}



generate_eth(){
PORT_IP=2
PORT_IP=$((PORT_IP+$1))
touch set_ip"$PORT_IP".sh
chmod 777 set_ip"$PORT_IP".sh
cat <<EOT >> set_ip"$PORT_IP".sh
#!/bin/bash
ifconfig eth0 192.168.1.$PORT_IP down up
EOT
}

MY_distractor(){
rm tmp_script*.sh
}


#printf "\n$NUM_OF_PORTS\n"
##############################
#             MAIN           #
##############################
NUM_OF_PORTS="$(ls /dev/ttyUSB* | grep -v ^l | wc -l)"

for (( i=0; i < $NUM_OF_PORTS ; i++ ))
do
	generate_script "$i"
done
echo "$(ls tmp_script*.sh)"
for (( i=0; i < $NUM_OF_PORTS ; i++ ))
do
	generate_eth "$i"
done

for (( i=0; i < $NUM_OF_PORTS ; i++ ))
do
	open_minicom "$i"
done
sleep 1

MY_distractor
