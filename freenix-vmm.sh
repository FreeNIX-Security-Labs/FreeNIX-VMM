#!/bin/bash
## FreeNIX-VMM is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>
## Name: FreeNIX-VMM
## Version: 0.1
## License: GPLv3
## Author: davenull - dave-null@riseup.net
## Website: https://www.freenixsecurity.net
## Creation Date: 2017-07-20
## Last Update: 2017-10-19
## Copyright 2014-2017 davenull

main()
{
clear;
choose_menu;
}

choose_menu()
{
echo "## FreeNIX-VMM 0.1";
echo "## Description: Virtual Machine creator";
echo "## for X86 and X64 architecture with KVM technology";
echo "";
echo "## FreeNIX Security Lab";
echo "## https://www.freenixsecurity.net";
echo "## dave-null@riseup.net";
echo "## Copyright 2017 davenull"
echo "";
echo "## Supported by Cooperativa Sociale LaCanosa";
echo "## http://www.cooperativasociale.org";
echo "";
echo "### Menu ###";
echo "A - Install KVMX Dependences";
echo "B - Create a Virtual Machine";
echo "C - Choose a Virtual Machine to boot";
echo "E - Exit";
echo "Choose a letter: ";
read -n 1 menu_command;
## CODICE PER LEGGERE LE OPZIONI DEL MENU ##
if [ ${menu_command} = "a" ] || [ ${menu_command} = "A" ]
then
dependences_installer
elif [ ${menu_command} = "b" ] || [ ${menu_command} = "B" ]
then
create_vm
elif [ ${menu_command} = "c" ] || [ ${menu_command} = "C" ]
then
choose_vm
elif [ ${menu_command} = "e" ] || [ ${menu_command} = "E" ]
then
exit_program
else
#if [ $(menu_command) != "a" && $(menu_command) != "A" && $(menu_command) != "b" && $(menu_command) != "B" && $(menu_command) != "c" && $(menu_command) != "C" && $(menu_command) != "e" && $(menu_command) != "E" ] 
wrong_choose
fi
}

dependences_installer()
{
clear
apt-get update && apt-get --yes --force-yes dist-upgrade && apt-get install --yes --force-yes qemu qemu-kvm;
clear;
choose_menu;
}

create_vm()
{
clear

echo "## FreeNIX-VMM 0.1";
echo "## Description: Virtual Machine creator";
echo "## for X86 and X64 architecture with KVM technology";
echo "";
echo "## FreeNIX Security Lab";
echo "## https://www.freenixsecurity.net";
echo "## dave-null@riseup.net";
echo "";
echo "## Supported by Cooperativa Sociale LaCanosa";
echo "## http://www.cooperativasociale.org";
echo "";
echo "### Create VM ###";
echo "Choose the VM name (without spaces): "
read vmname;
mkdir vms/$vmname ;
echo "";
echo "Choose the Virtual Disk size (M for Mb, G for GB, for example 8G): "
read vmdisksize;
vdi=".vdi"
qemu-img create -f vdi vms/$vmname/$vmname$vdi $vmdisksize;
chmod -R 777 vms/$vmname
echo "";
echo "Choose the architecture [type x86 or x64]: ";
read -n 3 architecture;
if [ ${architecture} = "x86" ] || [ ${architecture} = "X86" ]
then
architecture="qemu-system-i386"
elif [ ${architecture} = "x64" ] || [ ${architecture} = "X64" ]
then
architecture="qemu-system-x86_64"
else
rm -rf vms/$vmname;
wrong_choose;
fi
echo "";
echo "Choose the core's number (for example 2): "
read -n 1 cores;
echo "";
echo "Choose the RAM memory in Mb (type only the number of Mb): "
read memory;
echo "";
echo "Put the iso file for the installation in vms/"$vmname" and type ENTER" ;
read
pwd="$(/bin/pwd)" ;
isofile="$(/bin/ls $pwd/vms/$vmname/*.iso)" ;
installfile="_install.sh" ;
bootfile="_boot.sh" ;
echo "#!/bin/bash" > $pwd/vms/$vmname/$vmname$bootfile &&
echo $architecture "--enable-kvm -smp" $cores "-m" $memory $vmname$vdi >> $pwd"/vms/"$vmname/$vmname$bootfile &&
chmod 755 $pwd/vms/$vmname/$vmname$bootfile &&
echo "#!/bin/bash" > $pwd/vms/$vmname/$vmname$installfile &&
echo $architecture "--enable-kvm -smp" $cores "-m" $memory "-cdrom" $isofile $pwd"/vms/"$vmname/$vmname$vdi >> vms/$vmname/$vmname$installfile &&
chmod 755 $pwd/vms/$vmname/$vmname$installfile &&
/bin/bash $pwd/vms/$vmname/$vmname$installfile
}


choose_vm()
{
clear
echo "## KVMX 0.1";
echo "## Description: Virtual Machine creator";
echo "## for X86 and X64 architecture with KVM technology";
echo "";
echo "## FreeNIX Security Lab";
echo "## https://www.freenixsecurity.net";
echo "## davenull.freenix@gmail.com";
echo "";
echo "## Cooperativa Sociale LaCanosa";
echo "## http://www.cooperativasociale.org";
echo "";
echo "### Choose a VM to boot ###";
ls vms | sort
echo "";
echo "Type the VM's name to run: ";
read vmname;
#cd vms;
if [ -d vms/"$vmname" ]; then
cd vms/$vmname/;
./*boot.sh;
else
echo "The chosem VM does not exist";
choose_menu;
fi
}

exit_program()
{
exit;
}

wrong_choose()
{
clear;
echo "You have chosen a wrong command";
sleep 3s;
main;
}

if [ $UID != 0 ]; then
    echo "You should be logged as root to run this tool!";
    exit 1;
fi
main
exit 0;
