#!/bin/bash

'''
#TODO
spoof email
ip externa
ifconfig
add color to the banner
'''

'''
#! Order:
banner
check tools
install tools
menu
'''


# First define the tools needed

function initialize_colors() {

	BlackAnWhiteMode = 0

    if BlackAnWhiteMode = 0
    then
        normal_color="\e[1;0m"
        green_color="\033[1;32m"
        red_color="\033[1;31m"
        red_color_slim="\033[0;031m"
        blue_color="\033[1;34m"
        cyan_color="\033[1;36m"
        brown_color="\033[0;33m"
        yellow_color="\033[1;33m"
        pink_color="\033[1;35m"
        white_color="\e[1;97m"
    elif BlackAnWhiteMode = 1
    then
        normal_color="\e[1;0m"
        green_color="${normal_color}"
		red_color="${normal_color}"
		red_color_slim="${normal_color}"
		blue_color="${normal_color}"
		cyan_color="${normal_color}"
		brown_color="${normal_color}"
		yellow_color="${normal_color}"
		pink_color="${normal_color}"
		white_color="${normal_color}"
    fi
}


essential_tools_names=(
						"ifconfig"
						"iwconfig"
						"iw"
						"airmon-ng"
						"airodump-ng"
						"aircrack-ng"
                        "reaver"
						"xterm"
						"ip"
                        "curl"
					)

optional_tools_names=(
						"crunch"
						"aireplay-ng"
						"mdk4"
						"hashcat"
						"wash"
						"bully"
						"pixiewps"
						"john"
					)



declare -A possible_package_names=(
									[${essential_tools_names[0]}]="net-tools" #ifconfig
									[${essential_tools_names[1]}]="wireless-tools" #iwconfig
									[${essential_tools_names[2]}]="iw" #iw
									[${essential_tools_names[3]}]="aircrack-ng" #airmon-ng
									[${essential_tools_names[4]}]="aircrack-ng" #airodump-ng
									[${essential_tools_names[5]}]="aircrack-ng" #aircrack-ng
                                    [${essential_tools_names[6]}]="reaver" #reaver
									[${essential_tools_names[7]}]="xterm" #xterm
									[${essential_tools_names[8]}]="iproute2" #ip
                                    [${essential_tools_names[9]}]="curl" #curl
                                    #########################################################
									[${optional_tools_names[0]}]="crunch" #crunch
									[${optional_tools_names[1]}]="aircrack-ng" #aireplay-ng
									[${optional_tools_names[2]}]="mdk4" #mdk4
									[${optional_tools_names[3]}]="hashcat" #hashcat
									[${optional_tools_names[4]}]="reaver" #wash
									[${optional_tools_names[5]}]="bully" #bully
									[${optional_tools_names[6]}]="pixiewps" #pixiewps
									[${optional_tools_names[7]}]="john" #john
								)


function check_essential_tools () {

    essential_toolsok=1
	for i in "${essential_tools_names[@]}"; do
        echo -ne "${i}"
        time_loop
        if ! hash "${i}" 2> /dev/null; then
            echo -ne "${red_color} Error${normal_color}"
            essential_toolsok=0
            echo -ne " (${possible_package_names_text} : ${possible_package_names[${i}]})"
            echo -e "\r"
        else
            echo -e "${green_color} Ok\r${normal_color}"
        fi
	done

}

function check_optional_tools () {
    
    echo
    optional_toolsok=1
	for i in "${!optional_tools[@]}"; do
        echo -ne "${i}"
        time_loop
		if ! hash "${i}" 2> /dev/null; then
            echo -ne "${red_color} Error${normal_color}"
            echo -ne " (${possible_package_names_text[${language}]} : ${possible_package_names[${i}]})"
            echo -e "\r"
			optional_toolsok=0
		else
			echo -e "${green_color} Ok\r${normal_color}"
			optional_tools[${i}]=1
		fi
	done

}

function check_all_tools () {

    check_essential_tools
    check_optional_tools
    main_menu

}

'''
function set_possible_aliases() {

	debug_print

	for item in "${!possible_alias_names[@]}"; do
		if ! hash "${item}" 2> /dev/null || [[ "${item}" = "beef" ]]; then
			arraliases=(${possible_alias_names[${item//[[:space:]]/ }]})
			for item2 in "${arraliases[@]}"; do
				if hash "${item2}" 2> /dev/null; then
					optional_tools_names=(${optional_tools_names[@]/${item}/${item2}})
					break
				fi
			done
		fi
	done
}
'''

function check_tools_menu () {

    echo
    echo " Now the program will check if you have the requiered tools."
    read -p " Press [ENTER] to continue. "
    echo
    check_essential_tools
    check_optional_tools

}







'''
function install_other_tools () {

    # first it will ask you what you want to install
    # (acording to the following menu)

    # install menu


}
'''


function main_menu () {
    clear
    banner

    echo "  if) ifconfig"
    echo "  iw) iwconfig"
    echo " pIP) Public IP"
    echo " mon) Monitor mode"
    echo " man) Managed mode"
    echo " 001) Test" 
    echo " 000) exit"

    echo
    echo -e " [Option]"
                echo -ne  "   > " ;tput sgr0
    read option
    check_option
}


function check_option () {
    if [[ $option == 0 || $option == 000 ]]
        then
        clear
        echo
        echo "          (                      ) "
        echo "          |\    _,--------._    / | "
        echo "          | \`.,'            \`. /  | "
        echo "          \`  '              ,-'   ' "
        echo "           \/_         _   (     / "
        echo "          (,-.\`.    ,',-.\`. \`__,' "
        echo "           |/x\ ),-','x\`= ,'.\` | "
        echo "           \`._/)  -'.\_,'   ) ))|"
        echo "           /  (_.)\     .   -'//"
        echo "          (  /\____/\    ) )\`'\ "
        echo "           \ |V----V||  ' ,    \ "
        echo "            |\`- -- -'   ,'   \  \      _____"
        echo "     ___    |         .'    \ \  \`._,-'     \`- "
        echo "        \`.__,\`---^---'       \ \` -' "
        echo "           -.______  \ . /  ______,- "
        echo "                   \`.     ,'            "
        echo
        echo "                  b  y  e  ! "
        sleep 0.5
        clear
        echo
        echo "          (                      ) "
        echo "          |\    _,--------._    / | "
        echo "          | \`.,'            \`. /  | "
        echo "          \`  '              ,-'   ' "
        echo "           \/_         _   (     / "
        echo "          (,-.\`.    ,',-.\`. \`__,' "
        echo "           |/X\ ),-','X\`= ,'.\` | "
        echo "           \`._/)  -'.\_,'   ) ))|"
        echo "           /  (_.)\     .   -'//"
        echo "          (  /\____/\    ) )\`'\ "
        echo "           \ |V----V||  ' ,    \ "
        echo "            |\`- -- -'   ,'   \  \      _____"
        echo "     ___    |         .'    \ \  \`._,-'     \`- "
        echo "        \`.__,\`---^---'       \ \` -' "
        echo "           -.______  \ . /  ______,- "
        echo "                   \`.     ,'            "
        echo
        echo "                  b  y  e  ! "
        sleep 0.1
        clear
        echo
        echo "          (                      ) "
        echo "          |\    _,--------._    / | "
        echo "          | \`.,'            \`. /  | "
        echo "          \`  '              ,-'   ' "
        echo "           \/_         _   (     / "
        echo "          (,-.\`.    ,',-.\`. \`__,' "
        echo "           |/x\ ),-','x\`= ,'.\` | "
        echo "           \`._/)  -'.\_,'   ) ))|"
        echo "           /  (_.)\     .   -'//"
        echo "          (  /\____/\    ) )\`'\ "
        echo "           \ |V----V||  ' ,    \ "
        echo "            |\`- -- -'   ,'   \  \      _____"
        echo "     ___    |         .'    \ \  \`._,-'     \`- "
        echo "        \`.__,\`---^---'       \ \` -' "
        echo "           -.______  \ . /  ______,- "
        echo "                   \`.     ,'            "
        echo
        echo "                  B  y  e  ! "
        sleep 0.1
        clear
        echo
        echo "          (                      ) "
        echo "          |\    _,--------._    / | "
        echo "          | \`.,'            \`. /  | "
        echo "          \`  '              ,-'   ' "
        echo "           \/_         _   (     / "
        echo "          (,-.\`.    ,',-.\`. \`__,' "
        echo "           |/X\ ),-','X\`= ,'.\` | "
        echo "           \`._/)  -'.\_,'   ) ))|"
        echo "           /  (_.)\     .   -'//"
        echo "          (  /\____/\    ) )\`'\ "
        echo "           \ |V----V||  ' ,    \ "
        echo "            |\`- -- -'   ,'   \  \      _____"
        echo "     ___    |         .'    \ \  \`._,-'     \`- "
        echo "        \`.__,\`---^---'       \ \` -' "
        echo "           -.______  \ . /  ______,- "
        echo "                   \`.     ,'            "
        echo
        echo "                  b  Y  e  ! "
        sleep 0.1
        clear
        echo
        echo "          (                      ) "
        echo "          |\    _,--------._    / | "
        echo "          | \`.,'            \`. /  | "
        echo "          \`  '              ,-'   ' "
        echo "           \/_         _   (     / "
        echo "          (,-.\`.    ,',-.\`. \`__,' "
        echo "           |/x\ ),-','x\`= ,'.\` | "
        echo "           \`._/)  -'.\_,'   ) ))|"
        echo "           /  (_.)\     .   -'//"
        echo "          (  /\____/\    ) )\`'\ "
        echo "           \ |V----V||  ' ,    \ "
        echo "            |\`- -- -'   ,'   \  \      _____"
        echo "     ___    |         .'    \ \  \`._,-'     \`- "
        echo "        \`.__,\`---^---'       \ \` -' "
        echo "           -.______  \ . /  ______,- "
        echo "                   \`.     ,'            "
        echo
        echo "                  b  y  E  ! "
        sleep 0.1
        clear
        echo
        echo "          (                      ) "
        echo "          |\    _,--------._    / | "
        echo "          | \`.,'            \`. /  | "
        echo "          \`  '              ,-'   ' "
        echo "           \/_         _   (     / "
        echo "          (,-.\`.    ,',-.\`. \`__,' "
        echo "           |/X\ ),-','X\`= ,'.\` | "
        echo "           \`._/)  -'.\_,'   ) ))|"
        echo "           /  (_.)\     .   -'//"
        echo "          (  /\____/\    ) )\`'\ "
        echo "           \ |V----V||  ' ,    \ "
        echo "            |\`- -- -'   ,'   \  \      _____"
        echo "     ___    |         .'    \ \  \`._,-'     \`- "
        echo "        \`.__,\`---^---'       \ \` -' "
        echo "           -.______  \ . /  ______,- "
        echo "                   \`.     ,'            "
        echo
        echo "                  b  y  e  ! "
        sleep 0.1
        clear
        echo
        echo "          (                      ) "
        echo "          |\    _,--------._    / | "
        echo "          | \`.,'            \`. /  | "
        echo "          \`  '              ,-'   ' "
        echo "           \/_         _   (     / "
        echo "          (,-.\`.    ,',-.\`. \`__,' "
        echo "           |/x\ ),-','x\`= ,'.\` | "
        echo "           \`._/)  -'.\_,'   ) ))|"
        echo "           /  (_.)\     .   -'//"
        echo "          (  /\____/\    ) )\`'\ "
        echo "           \ |V----V||  ' ,    \ "
        echo "            |\`- -- -'   ,'   \  \      _____"
        echo "     ___    |         .'    \ \  \`._,-'     \`- "
        echo "        \`.__,\`---^---'       \ \` -' "
        echo "           -.______  \ . /  ______,- "
        echo "                   \`.     ,'            "
        echo
        echo "                  b  y  E  ! "
        sleep 0.1
        clear
        echo
        echo "          (                      ) "
        echo "          |\    _,--------._    / | "
        echo "          | \`.,'            \`. /  | "
        echo "          \`  '              ,-'   ' "
        echo "           \/_         _   (     / "
        echo "          (,-.\`.    ,',-.\`. \`__,' "
        echo "           |/X\ ),-','X\`= ,'.\` | "
        echo "           \`._/)  -'.\_,'   ) ))|"
        echo "           /  (_.)\     .   -'//"
        echo "          (  /\____/\    ) )\`'\ "
        echo "           \ |V----V||  ' ,    \ "
        echo "            |\`- -- -'   ,'   \  \      _____"
        echo "     ___    |         .'    \ \  \`._,-'     \`- "
        echo "        \`.__,\`---^---'       \ \` -' "
        echo "           -.______  \ . /  ______,- "
        echo "                   \`.     ,'            "
        echo
        echo "                  b  Y  E  ! "
        sleep 0.1
        clear
        echo
        echo "          (                      ) "
        echo "          |\    _,--------._    / | "
        echo "          | \`.,'            \`. /  | "
        echo "          \`  '              ,-'   ' "
        echo "           \/_         _   (     / "
        echo "          (,-.\`.    ,',-.\`. \`__,' "
        echo "           |/x\ ),-','x\`= ,'.\` | "
        echo "           \`._/)  -'.\_,'   ) ))|"
        echo "           /  (_.)\     .   -'//"
        echo "          (  /\____/\    ) )\`'\ "
        echo "           \ |V----V||  ' ,    \ "
        echo "            |\`- -- -'   ,'   \  \      _____"
        echo "     ___    |         .'    \ \  \`._,-'     \`- "
        echo "        \`.__,\`---^---'       \ \` -' "
        echo "           -.______  \ . /  ______,- "
        echo "                   \`.     ,'            "
        echo
        echo "                  B  Y  E  ! "
        sleep 0.1
        clear
        echo
        echo "          (                      ) "
        echo "          |\    _,--------._    / | "
        echo "          | \`.,'            \`. /  | "
        echo "          \`  '              ,-'   ' "
        echo "           \/_         _   (     / "
        echo "          (,-.\`.    ,',-.\`. \`__,' "
        echo "           |/X\ ),-','X\`= ,'.\` | "
        echo "           \`._/)  -'.\_,'   ) ))|"
        echo "           /  (_.)\     .   -'//"
        echo "          (  /\____/\    ) )\`'\ "
        echo "           \ |V----V||  ' ,    \ "
        echo "            |\`- -- -'   ,'   \  \      _____"
        echo "     ___    |         .'    \ \  \`._,-'     \`- "
        echo "        \`.__,\`---^---'       \ \` -' "
        echo "           -.______  \ . /  ______,- "
        echo "                   \`.     ,'            "
        echo
        echo "                  B  Y  E  ! "
        sleep 0.1
        clear
        echo
        echo "          (                      ) "
        echo "          |\    _,--------._    / | "
        echo "          | \`.,'            \`. /  | "
        echo "          \`  '              ,-'   ' "
        echo "           \/_         _   (     / "
        echo "          (,-.\`.    ,',-.\`. \`__,' "
        echo "           |/x\ ),-','x\`= ,'.\` | "
        echo "           \`._/)  -'.\_,'   ) ))|"
        echo "           /  (_.)\     .   -'//"
        echo "          (  /\____/\    ) )\`'\ "
        echo "           \ |V----V||  ' ,    \ "
        echo "            |\`- -- -'   ,'   \  \      _____"
        echo "     ___    |         .'    \ \  \`._,-'     \`- "
        echo "        \`.__,\`---^---'       \ \` -' "
        echo "           -.______  \ . /  ______,- "
        echo "                   \`.     ,'            "
        echo
        echo "                  B  Y  E  ! "
        echo
        exit 0

    elif [[ $option == 1 || $option == 001 ]]; then
        clear
        echo "Soy un Test!"
        echo "En dos segundos limpiaré la pantalla!"
        sleep 2
        clear
        main_menu

    elif [[ $option == "pIp" || $option == "pip" ]]; then
        public_ip

    else
        echo
        echo "    \(╰◣▂ ◢╯)Ψ   Wrong option!"
        sleep 1
        main_menu
    fi

}

function banner () {

    echo
    echo "               (\`-')                (\`-')                              "
    echo "            <-.(OO )               _(OO )                  <-.         "
    echo "            ,------,)   .---. ,--.(_/,-.\ .--.  .----.   ,--. )   .--. "
    echo "            |   /\`. '  / .  | \   \ / (_//_  | /  ..  \  |  (\`-')/_  | "
    echo "            |  |_.' | / /|  |  \   /   /  |  ||  /  \  . |  |OO ) |  | "
    echo "            |  .   .'/ '-'  |   \     /_) |  |'  \  /  '(|  '__ | |  | "
    echo "            |  |\  \ \`---|  |    \   /    |  | \  \`'  /  |     |' |  | "
    echo "   ＴＥＨ   \`--' '--'    \`--'     \`-'     \`--'  \`---''   \`-----'  \`--'   ＳＣＲＩＰＴ"
    echo
}

function banner_animation () {
    clear
    echo
    echo "               (\`-')                (\`-')                              "
    echo "            <-.(OO )               _(OO )                  <-.         "
    echo "            ,------,)   .---. ,--.(_/,-.\ .--.  .----.   ,--. )   .--. "
    echo "            |   /\`. '  / .  | \   \ / (_//_  | /  ..  \  |  (\`-')/_  | "
    echo "            |  |_.' | / /|  |  \   /   /  |  ||  /  \  . |  |OO ) |  | "
    echo "            |  .   .'/ '-'  |   \     /_) |  |'  \  /  '(|  '__ | |  | "
    echo "            |  |\  \ \`---|  |    \   /    |  | \  \`'  /  |     |' |  | "
    echo "   ＴＥＨ   \`--' '--'    \`--'     \`-'     \`--'  \`---''   \`-----'  \`--'   ＳＣＲＩＰＴ"
    sleep 1
    clear
    echo
    echo "               (\`-')                (\`-')                              "
    echo "            <-.(-- )               _(-- )                  <-.         "
    echo "            ,------,)   .---. ,--.(_/,-.\ .--.  .----.   ,--. )   .--. "
    echo "            |   /\`. '  / .  | \   \ / (_//_  | /  ..  \  |  (\`-')/_  | "
    echo "            |  |_.' | / /|  |  \   /   /  |  ||  /  \  . |  |-- ) |  | "
    echo "            |  .   .'/ '-'  |   \     /_) |  |'  \  /  '(|  '__ | |  | "
    echo "            |  |\  \ \`---|  |    \   /    |  | \  \`'  /  |     |' |  | "
    echo "   ＴＥＨ   \`--' '--'    \`--'     \`-'     \`--'  \`---''   \`-----'  \`--'   ＳＣＲＩＰＴ"
    sleep 0.1
    clear
    echo
    echo "               (\`-')                (\`-')                              "
    echo "            <-.(OO )               _(OO )                  <-.         "
    echo "            ,------,)   .---. ,--.(_/,-.\ .--.  .----.   ,--. )   .--. "
    echo "            |   /\`. '  / .  | \   \ / (_//_  | /  ..  \  |  (\`-')/_  | "
    echo "            |  |_.' | / /|  |  \   /   /  |  ||  /  \  . |  |OO ) |  | "
    echo "            |  .   .'/ '-'  |   \     /_) |  |'  \  /  '(|  '__ | |  | "
    echo "            |  |\  \ \`---|  |    \   /    |  | \  \`'  /  |     |' |  | "
    echo "   ＴＥＨ   \`--' '--'    \`--'     \`-'     \`--'  \`---''   \`-----'  \`--'   ＳＣＲＩＰＴ"
    sleep 0.2
    clear
    echo
    echo "               (\`-')                (\`-')                              "
    echo "            <-.(-- )               _(-- )                  <-.         "
    echo "            ,------,)   .---. ,--.(_/,-.\ .--.  .----.   ,--. )   .--. "
    echo "            |   /\`. '  / .  | \   \ / (_//_  | /  ..  \  |  (\`-')/_  | "
    echo "            |  |_.' | / /|  |  \   /   /  |  ||  /  \  . |  |-- ) |  | "
    echo "            |  .   .'/ '-'  |   \     /_) |  |'  \  /  '(|  '__ | |  | "
    echo "            |  |\  \ \`---|  |    \   /    |  | \  \`'  /  |     |' |  | "
    echo "   ＴＥＨ   \`--' '--'    \`--'     \`-'     \`--'  \`---''   \`-----'  \`--'   ＳＣＲＩＰＴ"
    sleep 0.1
    clear
    echo
    echo "               (\`-')                (\`-')                              "
    echo "            <-.(OO )               _(OO )                  <-.         "
    echo "            ,------,)   .---. ,--.(_/,-.\ .--.  .----.   ,--. )   .--. "
    echo "            |   /\`. '  / .  | \   \ / (_//_  | /  ..  \  |  (\`-')/_  | "
    echo "            |  |_.' | / /|  |  \   /   /  |  ||  /  \  . |  |OO ) |  | "
    echo "            |  .   .'/ '-'  |   \     /_) |  |'  \  /  '(|  '__ | |  | "
    echo "            |  |\  \ \`---|  |    \   /    |  | \  \`'  /  |     |' |  | "
    echo "   ＴＥＨ   \`--' '--'    \`--'     \`-'     \`--'  \`---''   \`-----'  \`--'   ＳＣＲＩＰＴ"
    sleep 1.5
    echo
    check_all_tools
}




###################################
#        MENU FUNCTIONS           #
###################################



function public_ip
{
	clear
	echo -e "Please wait..."
	CHECKMON=$(ifconfig | grep "mon")
	if [[ "$CHECKMON" = "" ]]
	then
		clear
		PUBLICIP=$(curl -s ipinfo.io/ip)
		if [[ "$PUBLICIP" = "" ]]
		then
			clear
			PUBLICIP="Connection error."
	    fi
	    echo "  Your public IP is: "$PUBLICIP""
        read -p "  Press [ENTER] to continue. "

	else
		echo -e "Monitor mode enabled, I can't access internet!"
		echo -e "You can select 'man) Managed' to disable monitor mode."
		read -p "  Press [ENTER] to continue. "
	fi
    main_menu
}




# Start the program
banner_animation
exit 0



























'''



COSAS INTERESANTES DE OTROS SCRIPTS

#AIRGEDDON: L13061
function check_root_permissions() {

	debug_print

	user=$(whoami)

	if [ "${user}" = "root" ]; then
		if ! "${AIRGEDDON_SILENT_CHECKS:-false}"; then
			echo
			language_strings "${language}" 484 "yellow"
		fi
	else
		echo
		language_strings "${language}" 223 "red"
		exit_code=1
		exit_script_option
	fi
}



'''