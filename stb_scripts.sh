# for 1520
cd /usr/local/bin
tftp 169.254.6.55 -c get list_low.sh
chmod +x list_low.sh
ln -s /usr/local/bin/list_low.sh list





# for 1530
cd /usr/local/bin
tftp -g -r list_low.sh 169.254.6.55
chmod +x list_low.sh
ln -s /usr/local/bin/list_low.sh list


