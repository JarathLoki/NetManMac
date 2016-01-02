#!/bin/bash
# This program is free software; you can redistribute it and/or modify it under the terms of
# the GNU General Public 
# License as published by the Free Software Foundation; either version 2 of the License, or
# any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;\
# without even the implied 
# warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
# License for more details.
# You should have received a copy of the GNU General Public License along with this program;
# if not, write to the
# Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
# #--------------------------------------------------------------------------------------------------------------------
#
# Disclaimer:   This script is intended for use only for private study or during an authorised
# pentest. The author bears no responsibility for malicious or illegal use.
##############################################
# ANSI code routines from Vulpi author of
#              PwnStar9.0 
txtrst="\e[0m"      # Text reset 
warn="\e[1;31m"     # warning		   red         
info="\e[1;34m"     # info                 blue             
q="\e[1;32m"		# questions        green
inp="\e[1;36m"	    # input variables  magenta
yel="\e[1;33m"      # typed keyboard entries
##############################################

rm /tmp/macfile01.txt &> /dev/null
rm /tmp/macfile02.txt &> /dev/null

DEVTEST=ZZZ
clear
echo " "
echo -e "$info    ######################################################################"
echo "    #                                                                    #"
echo "    #           Musket Team Network-Manager Global Mac Spoofing Tool     #"
echo "    #                     FOR USE WITH KALI-LINUX AND NOW PENTOO!        #"
echo "    #                                                                    #"
echo "    #     This tool loads a random or selected mac address in ALL wifi   #" 
echo "    #   connection files in the etc/NetworkManger/system-connections     #"
echo "    #   folder. Please direct all thanks to:                             #"
echo "    #                                                                    #"
echo -e "    #                          $yel repzeroworld$info                             #"
echo "    #                                                                    #" 
echo "    #      in kali-linux forums who's work made this script possible.    #"
echo "    #         Pentoo support added by JarathLoki                                     #"
echo -e "$info    ######################################################################$txtrst"


while true

do
echo -e "$inp\n       Please confirm by pressing$yel (y/Y)$inp to continue...."
echo -e "         Press$yel (n/N)$inp to abort!!..Press$yel any other key$inp to try again:$txtrst"

  read CONFIRM
  case $CONFIRM in
    y|Y|YES|yes|Yes) break ;;
    n|N|no|NO|No)
      echo -e "Aborting - you entered$yel $CONFIRM $txtrst"
      exit
      ;;

  esac
done
echo -e "$info  You entered$yel $CONFIRM$info.   Continuing ...$txtrst"
sleep 3


#Select any existing wifi device so macchanger -r functions normally

SELECT_DEVICE_fn()
{

until  [ $DEVTEST == y ] || [ $DEVTEST == Y ]; do

echo -e  "$txtrst"
airmon-ng | tee /tmp/airmon01.txt

cat < /tmp/airmon01.txt | awk -F' ' '{ if(($2 != "Interface")) {print $2}}' > /tmp/airmon02.txt
#cat < /tmp/airmon01.txt | awk -F' ' '{ if(($1 != "Interface")) {print $1}}' > /tmp/airmon02.txt
cat < /tmp/airmon02.txt | awk -F' ' '{ if(($1 != "")) {print $1}}' > /tmp/airmon03.txt

  AIRMONNAME=$(cat /tmp/airmon03.txt | nl -ba -w 1  -s ': ')

echo ""
echo -e "$info Devices found by airmon-ng.$txtrst"
echo " "
echo "$AIRMONNAME" | sed 's/^/       /'
echo ""
echo -e "$inp    Enter the$yel line number$inp of ANY existing$yelwireless device(i.e. wlan0, wlan1 etc)$inp."
echo ""
read  -p "   Enter Line Number Here: " grep_Line_Number

echo -e "$txtrst"
DEV=$(cat /tmp/airmon03.txt| sed -n ""$grep_Line_Number"p")

# Remove trailing white spaces leaves spaces between names intact

DEV=$(echo $DEV | xargs)

rm /tmp/airmon01.txt &> /dev/null
rm /tmp/airmon02.txt &> /dev/null
rm /tmp/airmon03.txt &> /dev/null

	while true
	do

echo ""
echo -e "$inp  You entered$yel $DEV$info type$yel (y/Y)$inp to confirm or$yel (n/N)$inp to try again.$txtrst"
read DEVTEST

	case $DEVTEST in
	y|Y|n|N) break ;;
	~|~~)
	echo Aborting -
	exit
	;;

	esac
	echo -e  "$warn  !!!Wrong input try again!!!$txtrst"

	done

		done

}

#~~~~~~~~~~~~~~~End Select Device End~~~~~~~~~~~~~~~#

clear
echo ""
echo -e "$q     Do you wish to enter a specific mac address or use a random mac address?"
echo ""
echo -e "$inp   Type$yel (e/E)$inp to manually enter a mac address."
echo ""
echo -e "   Type$yel (r/R)$inp to generate a random mac address.$txtrst" #(ENTRAN)
read ENTRAN

	if [ $ENTRAN == e ] || [ $ENTRAN == E ]; then

		echo -e "$q\n     What mac address do you wish to enter(i.e. 00:11:22:33:44:55)?" #(MACCODE)
		echo ""
		echo -e  "$inp   Enter in this format ONLY i.e. 55:44:33:22:11:00."
		echo ""
		echo -e  "$info   Limited error handeling exists for this entry.$txtrst"
read MACCODE

#Sets correct puntuation for test
MACPUNCT=":::::"

sleep .2

# Tests punctuation

PUNCTEST=`echo "$MACCODE" | tr -d -c ".[:punct:]"`

sleep .2

if [ "$PUNCTEST" == "$MACPUNCT" ]

	then

	    PUNCT=1

	else

	    PUNCT=0

	fi

sleep .2

# Tests hex characters

MACALNUM=`echo "$MACCODE" | tr -d -c ".[:alnum:]"`

sleep .2


if [[ $MACALNUM =~ [A-Fa-f0-9]{12} ]]

then

	ALNUM=1
else

	ALNUM=0
  fi

sleep .2

# Tests string length

if [ ${#MACCODE} = 17 ]

then

	MACLEN=1
else

	MACLEN=0
  fi


sleep .2

# All mac variables set to ones(1)  and zeros(0)

until [ $MACLEN == 1 ] && [ $PUNCT == 1 ] && [ $ALNUM == 1 ]; do

	if [ $ALNUM == 0 ]; then
		echo -e "$warn  You are using a non-hex character.$txtrst"

			fi
	
	if [ $MACLEN == 0 ]; then
		echo -e "$warn  Your mac address is the wrong length.$txtrst"

			fi

	if [ $PUNCT == 0 ]; then

		echo -e "$warn  You have entered the wrong and/or too many separators - use ONLY colons :$txtrst"

			fi

	echo -e "$info  Mac address entry incorrect!!!"
        echo "  You must use format 00:11:22:33:44:55 or aa:AA:bb:BB:cc:CC"
	echo "  Only a thru f, A thru F, 0 thru 9 and the symbol :  are allowed."
	echo -e "$inp  Reenter mac address and try again.$txtrst" #(MACCODE)
	read MACCODE

        MACALNUM=`echo "$MACCODE" | tr -d -c ".[:alnum:]"`
	if [[ $MACALNUM =~ [A-Fa-f0-9]{12} ]]

        then

        	ALNUM=1

        else

	        ALNUM=0

			fi

sleep .2       

	if [ ${#MACCODE} == 17 ]

	then

		MACLEN=1
	else

		MACLEN=0

			fi

sleep .2

	PUNCTEST=`echo "$MACCODE" | tr -d -c ".[:punct:]"`
	if [ $PUNCTEST == $MACPUNCT ]

	then

	    PUNCT=1

	else

	    PUNCT=0

			fi

sleep 1

done

				fi
  
#######Mac Error Handling Ends Whew!!#######

	if [ $ENTRAN == e ] || [ $ENTRAN == E ]; then

find /etc/NetworkManager/system-connections -type f -exec sh -c "sed -i \"/^cloned-mac-address.*/d;/^\[802-11-wireless\]/a\cloned-mac-address=$MACCODE\" \"{}\"" \;

		fi


########## Start Random Mac #########

	if [ $ENTRAN == r ] || [ $ENTRAN == R ]; then

SELECT_DEVICE_fn

ifconfig $DEV down

macchanger -r $DEV > /tmp/macfile01.txt

sleep 1

ifconfig $DEV up

cat < /tmp/macfile01.txt | awk -F' ' '{ if(($1 == "New")) {print $3}}' > /tmp/macfile02.txt

random_mac=$(cat /tmp/macfile02.txt)

find /etc/NetworkManager/system-connections -type f -exec sh -c "sed -i \"/^cloned-mac-address.*/d;/^\[802-11-wireless\]/a\cloned-mac-address=$random_mac\" \"{}\"" \;

rm /tmp/macfile01.txt &> /dev/null
rm /tmp/macfile02.txt &> /dev/null

			fi

/etc/init.d/NetworkManager restart

if [ $ENTRAN == e ] || [ $ENTRAN == E ]; then

	echo ""
	echo -e "$info   The spoofed mac address(i.e. cloned-mac-address) in ALL"
	echo ""
	echo "  /etc/NetworkManager/system-connection files should be."
	echo ""
	echo -e "$yel		    cloned-mac-address=$MACCODE$txtrst"
	echo ""

		fi

if [ $ENTRAN == r ] || [ $ENTRAN == R ]; then


	echo ""
	echo -e "$info   The spoofed mac address(i.e. cloned-mac-address) in ALL"
	echo ""
	echo "  /etc/NetworkManager/system-connection files should be."
	echo ""
	echo -e "$yel		    cloned-mac-address=$random_mac$txtrst"
	echo ""

		fi

echo "end"

sleep 5

