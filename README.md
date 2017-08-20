# test
Ubuntu_Scripts


to use the script, copy the follow commands to statup script:

#!/bin/bash
#make dir for the git script
rm -rf /home/$(whoami)/tmp_open_minicoms
mkdir -p /home/$(whoami)/tmp_open_minicoms
cd /home/$(whoami)/tmp_open_minicoms
git clone https://github.com/amitayben/test.git
cd /home/$(whoami)/tmp_open_minicoms/test
chmod 777 open_minicom.sh
sed -i -e 's/\r$//' open_minicom.sh
./open_minicom.sh
