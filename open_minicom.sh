#!/bin/bash



open_minicom(){
PORT_IP=2
PORT_IP=$((PORT_IP+$1))
gnome-terminal -t "Minicom port $1 - 192.168.1.$PORT_IP" -x ./tmp_script"$1".sh
#./minicom_PORT.sh "$PORT_NUM"
}

generate_script(){
echo "$1"
PORT_NUM="$1"
PORT_IP=2
PORT_IP=$((PORT_IP+$1))
#gconftool-2 --set /apps/gnome-terminal/profiles/Default/title --type=string "Minicom port $PORT_NUM"
#############################generat script
touch tmp_script"$1".sh
chmod 777 tmp_script"$1".sh
cat <<EOT >> tmp_script"$1".sh
#!/usr/bin/expect -f
spawn sudo minicom -D /dev/ttyUSB$PORT_NUM -S set_ip"$PORT_IP".sh
expect {
-re ".*sword.*" {
    exp_send "P@ssw0rd\r"
}
}
interact
EOT
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
rm tmp_script*.sh set_ip*.sh
}


#printf "\n$NUM_OF_PORTS\n"
##############################
#             MAIN           #
##############################
NUM_OF_PORTS="$(ls /dev/ttyUSB* | grep -v ^l | wc -l)"
if [ $# -eq 0 ]
  then
	pass="P@ssw0rd"
else
	pass="$1"
fi
if [ "$NUM_OF_PORTS" == "0" ]; then
	printf "Not found any minicom ports\n Exiting......\n" && exit 1;
fi
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

