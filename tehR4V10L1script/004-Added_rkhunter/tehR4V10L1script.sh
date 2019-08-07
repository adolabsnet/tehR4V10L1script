#!/bin/bash

#TODO: Añadir al menu otros programas como zenmap, metasploit (por donde los payloads), airgeddon o lscript.
#TODO: Añadir opción para crear payloads con msfvenom.
#TODO: Mirar coño coño marcan los wifis con gente en airgeddon
#TODO: Añadir handshakes automatizados (suicidio inminente)
#TODO: Añadir al menú de escaner analizar una ip (los puertos)
#TODO: Wordlist generator with crunch

#TODO: Scripts python: SSH bruteforce + Web login bruteforce

# Set the colors here beacause i don't wanna kill myself yet
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

###################################
#        INITIAL CHECKING         #
###################################

# First define the tools needed and the optional ones
essential_tools_names=(
						"ifconfig"
						"iwconfig"
						"iw"
						"airmon-ng"
						"airodump-ng"
						"aircrack-ng"
                        "reaver"
                        "nmap"
						"xterm"
						"ip"
                        "curl"
                        "awk"
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
                        "msfconsole"
                        "msfvenom"
                        "hydra"
                        "rkhunter"
					)


# Declare the posible package names acording to the order before.
declare -A possible_package_names=(
									[${essential_tools_names[0]}]="net-tools" #ifconfig
									[${essential_tools_names[1]}]="wireless-tools" #iwconfig
									[${essential_tools_names[2]}]="iw" #iw
									[${essential_tools_names[3]}]="aircrack-ng" #airmon-ng
									[${essential_tools_names[4]}]="aircrack-ng" #airodump-ng
									[${essential_tools_names[5]}]="aircrack-ng" #aircrack-ng
                                    [${essential_tools_names[6]}]="reaver" #reaver
                                    [${essential_tools_names[7]}]="nmap" #nmap
									[${essential_tools_names[8]}]="xterm" #xterm
									[${essential_tools_names[9]}]="iproute2" #ip
                                    [${essential_tools_names[10]}]="curl" #curl
                                    [${essential_tools_names[11]}]="gawk" #awk
                                    #########################################################
									[${optional_tools_names[0]}]="crunch" #crunch
									[${optional_tools_names[1]}]="aircrack-ng" #aireplay-ng
									[${optional_tools_names[2]}]="mdk4" #mdk4
									[${optional_tools_names[3]}]="hashcat" #hashcat
									[${optional_tools_names[4]}]="reaver" #wash
									[${optional_tools_names[5]}]="bully" #bully
									[${optional_tools_names[6]}]="pixiewps" #pixiewps
									[${optional_tools_names[7]}]="john" #john
                                    [${optional_tools_names[8]}]="msfconsole" #metasploit
                                    [${optional_tools_names[9]}]="msfvenom" #msfvenom
                                    [${optional_tools_names[9]}]="hydra" #hydra
                                    [${optional_tools_names[10]}]="rkhunter" #rkhunter
								)

# Check first tool names (essentials)
function check_essential_tools () {

    echo -e "${white_color} Checking essential tools...${normal_color}"

    essential_toolsok=1
	for i in "${essential_tools_names[@]}"; do
        echo -ne " ${i}"
        if ! hash "${i}" 2> /dev/null; then
            echo -ne "${red_color} Error${normal_color}"
            essential_toolsok=0
            echo -ne " (Posible name: ${possible_package_names[${i}]})"
            echo -e "\r"
        else
            echo -e "${green_color} Ok\r${normal_color}"
            essential_toolsok=1
        fi
	done

}

# Check second tool names (opyional)
function check_optional_tools () {
    
    echo -e "${white_color} Checking optional tools...${normal_color}"

    optional_toolsok=1
	for i in "${optional_tools_names[@]}"; do
        echo -ne " ${i}"
		if ! hash "${i}" 2> /dev/null; then
            echo -ne "${red_color} Error${normal_color}"
            echo -ne " (Posible name: ${possible_package_names[${i}]})"
            echo -e "\r"
			optional_toolsok=0
		else
			echo -e "${green_color} Ok\r${normal_color}"
			optional_tools[${i}]=1
		fi
	done

}

# Execute essential tools and optional tools functions
function check_all_tools () {

    check_essential_tools
    echo
    check_optional_tools
    echo
    echo -ne "${white_color} Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
    read -p ""
    main_menu

}

# The press enter to concinue after checking that you are root
function check_tools_menu () {

    echo -e " ${white_color}Now the program will check if you have the requiered tools.${normal_color}"
    echo -ne "${white_color} Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
    read -p ""
    echo
    check_all_tools

}

# executes whoami to see if the output is root or not
function check_root_permissions() {

	user=$(whoami)

	if [ "${user}" = "root" ]; then
		echo
        echo -e "${white_color} You have successfully logged in as root.${normal_color}"
        echo
        check_tools_menu
	else
		echo
		echo -e "${white_color} You are not ${red_color}root${white_color}! You must be ${red_color}root${white_color} to run this script."
        echo -e "${white_color} You can type ${red_color_slim}su -${white_color} to be ${red_color}root${white_color}."
        echo
	fi
}

###################################
#              MENU               #
###################################

# display of the main menu, first with the banner
function main_menu () {
    clear
    banner

    echo -e "${red_color_slim}  ins)${white_color} Install the missing packages" 
    echo -e " ${white_color}[${normal_color}=================================${white_color}]${normal_color}"
    echo -e "${red_color_slim}   if)${white_color} ifconfig"
    echo -e "${red_color_slim}      lIP)${white_color} See just local IP"
    echo -e "${red_color_slim}   iw)${white_color} iwconfig"
    echo -e "${red_color_slim}  pIP)${white_color} Public IP"
    echo -e "${red_color_slim}  mon)${white_color} Monitor mode"
    echo -e "${red_color_slim}      cmm)${white_color} [ Channel Monitor Mode ] Monitor mode with custom channel"
    echo -e "${red_color_slim}  man)${white_color} Managed mode"
    echo -e "${red_color_slim}  scn)${white_color} Scan near networks"
    echo -e " ${white_color}[${normal_color}=================================${white_color}]${normal_color}"
    echo -e "${red_color_slim}  001)${white_color} Deauth menu"
    echo -e "${red_color_slim}  002)${white_color} Scanning menu"
    echo -e "${red_color_slim}  003)${white_color} Bruteforce menu"
    echo -e "${red_color_slim}  004)${white_color} Scan your pc with rkhunter"
    echo -e " ${white_color}[${normal_color}=================================${white_color}]${normal_color}"
    echo -e "${red_color_slim}  000)${normal_color} Exit"

    echo
    echo -e "${white_color} [Option]"
                echo -ne  "   > " ;tput sgr0
    read option
    check_option
}

function check_option () {
    if [[ $option = 0 || $option  = 000 ]]
    then
        exit_animation

    elif [[ $option = "ins" || $option  = "INS" ]]; then
        install_tools

    elif [[ $option = "if" || $option  = "IF" ]]; then
        if_option

    elif [[ $option = "lip" || $option  = "lIP" ]]; then
        just_local_ip

    elif [[ $option = "iw" || $option  = "IW" ]]; then
        iw_option

    elif [[ $option = "pIP" || $option  = "pip" ]]; then
        public_ip

    elif [[ $option = "mon" || $option  = "MON" ]]; then
        monitor_mode

    elif [[ $option = "cmm" || $option  = "CMM" ]]; then
        monitor_mode_custom_channel

    elif [[ $option = "man" || $option  = "MAN" ]]; then
        managed_mode

    elif [[ $option = "scn" || $option  = "SCN" ]]; then
        scan_networks


    elif [[ $option = 1 || $option  = 001 ]]; then
        deauth_menu

    elif [[ $option = 2 || $option  = 002 ]]; then
        scanning_menu

    elif [[ $option = 3 || $option  = 003 ]]; then
        bruteforce_menu

    elif [[ $option = 4 || $option  = 004 ]]; then
        rkhunter_scan

    else
        echo
        echo -e "${red_color}    \(╰◣▂ ◢╯)Ψ   ${white_color}Wrong option!"
        sleep 1
        main_menu
    fi

}

###################################
#             BANNERS            #
###################################

# banner without animation
function banner () {

    echo
    echo -e "               ${red_color}(\`-')${white_color}                ${red_color}(\`-')${white_color}                              "
    echo -e "            ${red_color}<-.(OO )${white_color}               ${red_color}_(OO )${white_color}                  ${red_color}<-.${white_color}         "
    echo -e "            ,------,${red_color})${white_color}   .---. ,--.${red_color}(_/${white_color},-.${red_color}\ ${white_color}.--.  .----.   ,--. ${red_color})${white_color}   .--. "
    echo -e "            |   /\`. '  / .  | \   \ / ${red_color}(_/${white_color}/_  | /  ..  \  |  ${red_color}(\`-')${white_color}/_  | "
    echo -e "            |  |_.' | / /|  |  \   /   /  |  ||  /  \  . |  |${red_color}OO )${white_color} |  | "
    echo -e "            |  .   .'/ '-'  |   \     /${red_color}_)${white_color} |  |'  \  /  '${red_color}(${white_color}|  '__ ${red_color}|${white_color} |  | "
    echo -e "            |  |\  \ \`---|  |    \   /    |  | \  \`'  /  |     |${red_color}'${white_color} |  | "
    echo -e "   ＴＥＨ   \`--' '--'    \`--'     \`-'     \`--'  \`---''   \`-----'  \`--'   ＳＣＲＩＰＴ${normal_color}"
    echo
}

# banner animation
function banner_animation () {
    clear
    echo
    echo -e "               ${red_color}(\`-')${white_color}                ${red_color}(\`-')${white_color}                              "
    echo -e "            ${red_color}<-.(OO )${white_color}               ${red_color}_(OO )${white_color}                  ${red_color}<-.${white_color}         "
    echo -e "            ,------,${red_color})${white_color}   .---. ,--.${red_color}(_/${white_color},-.${red_color}\ ${white_color}.--.  .----.   ,--. ${red_color})${white_color}   .--. "
    echo -e "            |   /\`. '  / .  | \   \ / ${red_color}(_/${white_color}/_  | /  ..  \  |  ${red_color}(\`-')${white_color}/_  | "
    echo -e "            |  |_.' | / /|  |  \   /   /  |  ||  /  \  . |  |${red_color}OO )${white_color} |  | "
    echo -e "            |  .   .'/ '-'  |   \     /${red_color}_)${white_color} |  |'  \  /  '${red_color}(${white_color}|  '__ ${red_color}|${white_color} |  | "
    echo -e "            |  |\  \ \`---|  |    \   /    |  | \  \`'  /  |     |${red_color}'${white_color} |  | "
    echo -e "   ＴＥＨ   \`--' '--'    \`--'     \`-'     \`--'  \`---''   \`-----'  \`--'   ＳＣＲＩＰＴ"
    sleep 1
    clear
    echo
    echo -e "               ${red_color}(\`-')${white_color}                ${red_color}(\`-')${white_color}                              "
    echo -e "            ${red_color}<-.(-- )${white_color}               ${red_color}_(-- )${white_color}                  ${red_color}<-.${white_color}         "
    echo -e "            ,------,${red_color})${white_color}   .---. ,--.${red_color}(_/${white_color},-.${red_color}\ ${white_color}.--.  .----.   ,--. ${red_color})${white_color}   .--. "
    echo -e "            |   /\`. '  / .  | \   \ / ${red_color}(_/${white_color}/_  | /  ..  \  |  ${red_color}(\`-')${white_color}/_  | "
    echo -e "            |  |_.' | / /|  |  \   /   /  |  ||  /  \  . |  |${red_color}-- )${white_color} |  | "
    echo -e "            |  .   .'/ '-'  |   \     /${red_color}_)${white_color} |  |'  \  /  '${red_color}(${white_color}|  '__ ${red_color}|${white_color} |  | "
    echo -e "            |  |\  \ \`---|  |    \   /    |  | \  \`'  /  |     |${red_color}'${white_color} |  | "
    echo -e "   ＴＥＨ   \`--' '--'    \`--'     \`-'     \`--'  \`---''   \`-----'  \`--'   ＳＣＲＩＰＴ"
    sleep 0.1
    clear
    echo
    echo -e "               ${red_color}(\`-')${white_color}                ${red_color}(\`-')${white_color}                              "
    echo -e "            ${red_color}<-.(OO )${white_color}               ${red_color}_(OO )${white_color}                  ${red_color}<-.${white_color}         "
    echo -e "            ,------,${red_color})${white_color}   .---. ,--.${red_color}(_/${white_color},-.${red_color}\ ${white_color}.--.  .----.   ,--. ${red_color})${white_color}   .--. "
    echo -e "            |   /\`. '  / .  | \   \ / ${red_color}(_/${white_color}/_  | /  ..  \  |  ${red_color}(\`-')${white_color}/_  | "
    echo -e "            |  |_.' | / /|  |  \   /   /  |  ||  /  \  . |  |${red_color}OO )${white_color} |  | "
    echo -e "            |  .   .'/ '-'  |   \     /${red_color}_)${white_color} |  |'  \  /  '${red_color}(${white_color}|  '__ ${red_color}|${white_color} |  | "
    echo -e "            |  |\  \ \`---|  |    \   /    |  | \  \`'  /  |     |${red_color}'${white_color} |  | "
    echo -e "   ＴＥＨ   \`--' '--'    \`--'     \`-'     \`--'  \`---''   \`-----'  \`--'   ＳＣＲＩＰＴ"
    sleep 0.2
    clear
    echo
    echo -e "               ${red_color}(\`-')${white_color}                ${red_color}(\`-')${white_color}                              "
    echo -e "            ${red_color}<-.(-- )${white_color}               ${red_color}_(-- )${white_color}                  ${red_color}<-.${white_color}         "
    echo -e "            ,------,${red_color})${white_color}   .---. ,--.${red_color}(_/${white_color},-.${red_color}\ ${white_color}.--.  .----.   ,--. ${red_color})${white_color}   .--. "
    echo -e "            |   /\`. '  / .  | \   \ / ${red_color}(_/${white_color}/_  | /  ..  \  |  ${red_color}(\`-')${white_color}/_  | "
    echo -e "            |  |_.' | / /|  |  \   /   /  |  ||  /  \  . |  |${red_color}-- )${white_color} |  | "
    echo -e "            |  .   .'/ '-'  |   \     /${red_color}_)${white_color} |  |'  \  /  '${red_color}(${white_color}|  '__ ${red_color}|${white_color} |  | "
    echo -e "            |  |\  \ \`---|  |    \   /    |  | \  \`'  /  |     |${red_color}'${white_color} |  | "
    echo -e "   ＴＥＨ   \`--' '--'    \`--'     \`-'     \`--'  \`---''   \`-----'  \`--'   ＳＣＲＩＰＴ"
    sleep 0.1
    clear
    echo
    echo -e "               ${red_color}(\`-')${white_color}                ${red_color}(\`-')${white_color}                              "
    echo -e "            ${red_color}<-.(OO )${white_color}               ${red_color}_(OO )${white_color}                  ${red_color}<-.${white_color}         "
    echo -e "            ,------,${red_color})${white_color}   .---. ,--.${red_color}(_/${white_color},-.${red_color}\ ${white_color}.--.  .----.   ,--. ${red_color})${white_color}   .--. "
    echo -e "            |   /\`. '  / .  | \   \ / ${red_color}(_/${white_color}/_  | /  ..  \  |  ${red_color}(\`-')${white_color}/_  | "
    echo -e "            |  |_.' | / /|  |  \   /   /  |  ||  /  \  . |  |${red_color}OO )${white_color} |  | "
    echo -e "            |  .   .'/ '-'  |   \     /${red_color}_)${white_color} |  |'  \  /  '${red_color}(${white_color}|  '__ ${red_color}|${white_color} |  | "
    echo -e "            |  |\  \ \`---|  |    \   /    |  | \  \`'  /  |     |${red_color}'${white_color} |  | "
    echo -e "   ＴＥＨ   \`--' '--'    \`--'     \`-'     \`--'  \`---''   \`-----'  \`--'   ＳＣＲＩＰＴ"
    sleep 0.5
    echo
    check_root_permissions
}

# 000) exit animation'
function exit_animation () {

    clear
        echo
        echo -e "${red_color}          (                      ) "
        echo -e "          |\    _,--------._    / | "
        echo -e "          | \`.,'            \`. /  | "
        echo -e "          \`  '              ,-'   ' "
        echo -e "           \/_         _   (     / "
        echo -e "          (,-.\`.    ,',-.\`. \`__,' "
        echo -e "           |/${white_color}x${red_color}\ ),-','${white_color}x${red_color}\`= ,'.\` | "
        echo -e "           \`._/)  -'.\_,'   ) ))|"
        echo -e "           /  (_.)\     .   -'//"
        echo -e "          (  /\____/\    ) )\`'\ "
        echo -e "           \ |V----V||  ' ,    \ "
        echo -e "            |\`- -- -'   ,'   \  \      _____"
        echo -e "     ___    |         .'    \ \  \`._,-'     \`- "
        echo -e "        \`.__,\`---^---'       \ \` -' "
        echo -e "           -.______  \ . /  ______,- "
        echo -e "                   \`.     ,'            "
        echo
        echo -e "                  ${white_color}b  y  e  !"
        sleep 0.5
        clear
        echo
        echo -e "${red_color}          (                      ) "
        echo -e "          |\    _,--------._    / | "
        echo -e "          | \`.,'            \`. /  | "
        echo -e "          \`  '              ,-'   ' "
        echo -e "           \/_         _   (     / "
        echo -e "          (,-.\`.    ,',-.\`. \`__,' "
        echo -e "           |/${white_color}X${red_color}\ ),-','${white_color}X${red_color}\`= ,'.\` | "
        echo -e "           \`._/)  -'.\_,'   ) ))|"
        echo -e "           /  (_.)\     .   -'//"
        echo -e "          (  /\____/\    ) )\`'\ "
        echo -e "           \ |V----V||  ' ,    \ "
        echo -e "            |\`- -- -'   ,'   \  \      _____"
        echo -e "     ___    |         .'    \ \  \`._,-'     \`- "
        echo -e "        \`.__,\`---^---'       \ \` -' "
        echo -e "           -.______  \ . /  ______,- "
        echo -e "                   \`.     ,'            "
        echo
        echo -e "                  ${white_color}b  y  e  !"
        sleep 0.1
        clear
        echo
        echo -e "${red_color}          (                      ) "
        echo -e "          |\    _,--------._    / | "
        echo -e "          | \`.,'            \`. /  | "
        echo -e "          \`  '              ,-'   ' "
        echo -e "           \/_         _   (     / "
        echo -e "          (,-.\`.    ,',-.\`. \`__,' "
        echo -e "           |/${white_color}x${red_color}\ ),-','${white_color}x${red_color}\`= ,'.\` | "
        echo -e "           \`._/)  -'.\_,'   ) ))|"
        echo -e "           /  (_.)\     .   -'//"
        echo -e "          (  /\____/\    ) )\`'\ "
        echo -e "           \ |V----V||  ' ,    \ "
        echo -e "            |\`- -- -'   ,'   \  \      _____"
        echo -e "     ___    |         .'    \ \  \`._,-'     \`- "
        echo -e "        \`.__,\`---^---'       \ \` -' "
        echo -e "           -.______  \ . /  ______,- "
        echo -e "                   \`.     ,'            "
        echo
        echo -e "                  ${white_color}B  y  e  !"
        sleep 0.1
        clear
        echo
        echo -e "${red_color}          (                      ) "
        echo -e "          |\    _,--------._    / | "
        echo -e "          | \`.,'            \`. /  | "
        echo -e "          \`  '              ,-'   ' "
        echo -e "           \/_         _   (     / "
        echo -e "          (,-.\`.    ,',-.\`. \`__,' "
        echo -e "           |/${white_color}X${red_color}\ ),-','${white_color}X${red_color}\`= ,'.\` | "
        echo -e "           \`._/)  -'.\_,'   ) ))|"
        echo -e "           /  (_.)\     .   -'//"
        echo -e "          (  /\____/\    ) )\`'\ "
        echo -e "           \ |V----V||  ' ,    \ "
        echo -e "            |\`- -- -'   ,'   \  \      _____"
        echo -e "     ___    |         .'    \ \  \`._,-'     \`- "
        echo -e "        \`.__,\`---^---'       \ \` -' "
        echo -e "           -.______  \ . /  ______,- "
        echo -e "                   \`.     ,'            "
        echo
        echo -e "                  ${white_color}b  Y  e  !"
        sleep 0.1
        clear
        echo
        echo -e "${red_color}          (                      ) "
        echo -e "          |\    _,--------._    / | "
        echo -e "          | \`.,'            \`. /  | "
        echo -e "          \`  '              ,-'   ' "
        echo -e "           \/_         _   (     / "
        echo -e "          (,-.\`.    ,',-.\`. \`__,' "
        echo -e "           |/${white_color}x${red_color}\ ),-','${white_color}x${red_color}\`= ,'.\` | "
        echo -e "           \`._/)  -'.\_,'   ) ))|"
        echo -e "           /  (_.)\     .   -'//"
        echo -e "          (  /\____/\    ) )\`'\ "
        echo -e "           \ |V----V||  ' ,    \ "
        echo -e "            |\`- -- -'   ,'   \  \      _____"
        echo -e "     ___    |         .'    \ \  \`._,-'     \`- "
        echo -e "        \`.__,\`---^---'       \ \` -' "
        echo -e "           -.______  \ . /  ______,- "
        echo -e "                   \`.     ,'            "
        echo
        echo -e "                  ${white_color}b  y  E  !"
        sleep 0.1
        clear
        echo
        echo -e "${red_color}          (                      ) "
        echo -e "          |\    _,--------._    / | "
        echo -e "          | \`.,'            \`. /  | "
        echo -e "          \`  '              ,-'   ' "
        echo -e "           \/_         _   (     / "
        echo -e "          (,-.\`.    ,',-.\`. \`__,' "
        echo -e "           |/${white_color}X${red_color}\ ),-','${white_color}X${red_color}\`= ,'.\` | "
        echo -e "           \`._/)  -'.\_,'   ) ))|"
        echo -e "           /  (_.)\     .   -'//"
        echo -e "          (  /\____/\    ) )\`'\ "
        echo -e "           \ |V----V||  ' ,    \ "
        echo -e "            |\`- -- -'   ,'   \  \      _____"
        echo -e "     ___    |         .'    \ \  \`._,-'     \`- "
        echo -e "        \`.__,\`---^---'       \ \` -' "
        echo -e "           -.______  \ . /  ______,- "
        echo -e "                   \`.     ,'            "
        echo
        echo -e "                  ${white_color}b  Y  e  !"
        sleep 0.1
        clear
        echo
        echo -e "${red_color}          (                      ) "
        echo -e "          |\    _,--------._    / | "
        echo -e "          | \`.,'            \`. /  | "
        echo -e "          \`  '              ,-'   ' "
        echo -e "           \/_         _   (     / "
        echo -e "          (,-.\`.    ,',-.\`. \`__,' "
        echo -e "           |/${white_color}x${red_color}\ ),-','${white_color}x${red_color}\`= ,'.\` | "
        echo -e "           \`._/)  -'.\_,'   ) ))|"
        echo -e "           /  (_.)\     .   -'//"
        echo -e "          (  /\____/\    ) )\`'\ "
        echo -e "           \ |V----V||  ' ,    \ "
        echo -e "            |\`- -- -'   ,'   \  \      _____"
        echo -e "     ___    |         .'    \ \  \`._,-'     \`- "
        echo -e "        \`.__,\`---^---'       \ \` -' "
        echo -e "           -.______  \ . /  ______,- "
        echo -e "                   \`.     ,'            "
        echo
        echo -e "                  ${white_color}B  y  e  !"
        sleep 0.1
        clear
        echo
        echo -e "${red_color}          (                      ) "
        echo -e "          |\    _,--------._    / | "
        echo -e "          | \`.,'            \`. /  | "
        echo -e "          \`  '              ,-'   ' "
        echo -e "           \/_         _   (     / "
        echo -e "          (,-.\`.    ,',-.\`. \`__,' "
        echo -e "           |/${white_color}X${red_color}\ ),-','${white_color}X${red_color}\`= ,'.\` | "
        echo -e "           \`._/)  -'.\_,'   ) ))|"
        echo -e "           /  (_.)\     .   -'//"
        echo -e "          (  /\____/\    ) )\`'\ "
        echo -e "           \ |V----V||  ' ,    \ "
        echo -e "            |\`- -- -'   ,'   \  \      _____"
        echo -e "     ___    |         .'    \ \  \`._,-'     \`- "
        echo -e "        \`.__,\`---^---'       \ \` -' "
        echo -e "           -.______  \ . /  ______,- "
        echo -e "                   \`.     ,'            "
        echo
        echo -e "                  ${white_color}B  Y  e  !"
        sleep 0.1
        clear
        echo
        echo -e "${red_color}          (                      ) "
        echo -e "          |\    _,--------._    / | "
        echo -e "          | \`.,'            \`. /  | "
        echo -e "          \`  '              ,-'   ' "
        echo -e "           \/_         _   (     / "
        echo -e "          (,-.\`.    ,',-.\`. \`__,' "
        echo -e "           |/${white_color}x${red_color}\ ),-','${white_color}x${red_color}\`= ,'.\` | "
        echo -e "           \`._/)  -'.\_,'   ) ))|"
        echo -e "           /  (_.)\     .   -'//"
        echo -e "          (  /\____/\    ) )\`'\ "
        echo -e "           \ |V----V||  ' ,    \ "
        echo -e "            |\`- -- -'   ,'   \  \      _____"
        echo -e "     ___    |         .'    \ \  \`._,-'     \`- "
        echo -e "        \`.__,\`---^---'       \ \` -' "
        echo -e "           -.______  \ . /  ______,- "
        echo -e "                   \`.     ,'            "
        echo
        echo -e "                  ${white_color}B  Y  E  !"
        sleep 0.1
        clear
        echo
        echo -e "${red_color}          (                      ) "
        echo -e "          |\    _,--------._    / | "
        echo -e "          | \`.,'            \`. /  | "
        echo -e "          \`  '              ,-'   ' "
        echo -e "           \/_         _   (     / "
        echo -e "          (,-.\`.    ,',-.\`. \`__,' "
        echo -e "           |/${white_color}X${red_color}\ ),-','${white_color}X${red_color}\`= ,'.\` | "
        echo -e "           \`._/)  -'.\_,'   ) ))|"
        echo -e "           /  (_.)\     .   -'//"
        echo -e "          (  /\____/\    ) )\`'\ "
        echo -e "           \ |V----V||  ' ,    \ "
        echo -e "            |\`- -- -'   ,'   \  \      _____"
        echo -e "     ___    |         .'    \ \  \`._,-'     \`- "
        echo -e "        \`.__,\`---^---'       \ \` -' "
        echo -e "           -.______  \ . /  ______,- "
        echo -e "                   \`.     ,'            "
        echo
        echo -e "                  ${white_color}B  Y  E  !${normal_color}"
        echo
        sleep 1
        clear
        exit 0

}

###################################
#        MENU FUNCTIONS           #
###################################

# ins
function install_tools () {

    clear
    echo
    echo -e "${red_color_slim} [${white_color} Install tools menu ${red_color_slim}]${normal_color}"
    echo
    echo -e " ${white_color}[${normal_color}==========================${white_color}]${normal_color}"
    echo -e "${white_color}  01) ${normal_color}Install all${normal_color}"
    echo -e " ${white_color}[${normal_color}======${white_color}essential-tools${normal_color}=====${white_color}]${normal_color}"
    echo -e "${white_color}  02) ${normal_color}net-tools${normal_color}"
    echo -e "${white_color}  03) ${normal_color}wireless-tools${normal_color}"
    echo -e "${white_color}  04) ${normal_color}iw${normal_color}"
    echo -e "${white_color}  05) ${normal_color}aircrack-ng${normal_color}"
    echo -e "${white_color}  06) ${normal_color}reaver${normal_color}"
    echo -e "${white_color}  07) ${normal_color}nmap${normal_color}"
    echo -e "${white_color}  08) ${normal_color}xterm${normal_color}"
    echo -e "${white_color}  09) ${normal_color}iproute2${normal_color}"
    echo -e "${white_color}  10) ${normal_color}curl${normal_color}"
    echo -e "${white_color}  11) ${normal_color}awk (gawk)${normal_color}"
    echo -e " ${white_color}[${normal_color}======${white_color}optional-tools${normal_color}======${white_color}]${normal_color}"
    echo -e "${white_color}  12) ${normal_color}crunch${normal_color}"
    echo -e "${white_color}  13) ${normal_color}mdk4${normal_color}"
    echo -e "${white_color}  14) ${normal_color}hashcat${normal_color}"
    echo -e "${white_color}  15) ${normal_color}bully${normal_color}"
    echo -e "${white_color}  16) ${normal_color}pixiewps${normal_color}"
    echo -e "${white_color}  17) ${normal_color}john${normal_color}"
    echo -e "${white_color}  18) ${normal_color}metasploit${normal_color}"
    echo -e "${white_color}  19) ${normal_color}msfvenom${normal_color}"
    echo -e "${white_color}  19) ${normal_color}hydra${normal_color}"
    echo -e "${white_color}  20) ${normal_color}rkhunter${normal_color}"
    echo -e " ${white_color}[${normal_color}==========================${white_color}]${normal_color}"
    echo -e "${normal_color}  00)${normal_color} Back${normal_color}"
    echo
    echo -e "${white_color} [Option]"
                echo -ne  "   > " ;tput sgr0
    read install_option
    clear
    echo

    if [[ $install_option = 0 ||  $install_option = 00 ]]
    then
        main_menu
    elif [[ $install_option = 1 || $install_option = 01 ]]
    then

        apt-get install net-tools wireless_tools iw aircrack-ng reaver nmap xterm iproute2 curl gawk crunch libnl-genl-3-dev build-essential git autoconf automake libtool pkg-config libnl-3-dev libssl-dev libpcre3-dev hashcat john
        cd /root
        mkdir r4v10l1_temp_files
        cd r4v10l1_temp_files
        git clone https://github.com/aircrack-ng/mdk4
        wget https://github.com/aanarchyy/bully/archive/master.zip && unzip master.zip
        git clone https://github.com/wiire-a/pixiewps
        cd mdk4
        make 
        make install
        cd /root/r4v10l1_temp_files/bully*
        cd src
        make
        make install
        cd /root/r4v10l1_temp_files/pixiewps*
        make
        make install
        cd /root
        rm -r /root/r4v10l1_temp_files
        echo
        echo
        echo -e "${red_color} All${white_color} installed successfully!${normal_color}"
        sleep 3
        install_tools
        
    elif [[ $install_option = 2 ||  $install_option = 02 ]]
    then
        apt-get install net-tools
        echo
        echo -e "${red_color_slim} Net-tools${white_color} installed successfully!${normal_color}"
        sleep 1.5
        install_tools
    elif [[ $install_option = 3 ||  $install_option = 03 ]]
    then
        apt-get install wireless_tools
        echo
        echo -e "${red_color_slim} Wireless-tools${white_color} installed successfully!${normal_color}"
        sleep 1.5
        install_tools
    elif [[ $install_option = 4 ||  $install_option = 04 ]]
    then
        apt-get install iw
        echo
        echo -e "${red_color_slim} Iw${white_color} installed successfully!${normal_color}"
        sleep 1.5
        install_tools
    elif [[ $install_option = 5 ||  $install_option = 05 ]]
    then
        apt-get install aircrack-ng
        echo
        echo -e "${red_color_slim} Aircrack-ng${white_color} installed successfully!${normal_color}"
        sleep 1.5
        install_tools
    elif [[ $install_option = 6 ||  $install_option = 06 ]]
    then
        apt-get install reaver
        echo
        echo -e "${red_color_slim} Reaver${white_color} installed successfully!${normal_color}"
        sleep 1.5
        install_tools
    elif [[ $install_option = 7 ||  $install_option = 07 ]]
    then
        apt-get install nmap
        echo
        echo -e "${red_color_slim} Nmap${white_color} installed successfully!${normal_color}"
        sleep 1.5
        install_tools

    elif [[ $install_option = 8 ||  $install_option = 08 ]]
    then
        apt-get install xterm
        echo
        echo -e "${red_color_slim} Xterm${white_color} installed successfully!${normal_color}"
        sleep 1.5
        install_tools
    elif [[ $install_option = 9 ||  $install_option = 09 ]]
    then
        apt-get install iproute2
        echo
        echo -e "${red_color_slim} Iproute2${white_color} installed successfully!${normal_color}"
        sleep 1.5
        install_tools
    elif [[ $install_option = 10 ]]
    then
        apt-get install curl
        echo
        echo -e "${red_color_slim} Curl${white_color} installed successfully!${normal_color}"
        sleep 1.5
        install_tools
    elif [[ $install_option = 11 ]]
    then
        apt-get install gawk
        echo
        echo -e "${red_color_slim} Awk${white_color} installed successfully!${normal_color}"
        sleep 1.5
        install_tools

    elif [[ $install_option = 12 ]]
    then
        apt-get install crunch
        echo
        echo -e "${red_color_slim} Crunch${white_color} installed successfully!${normal_color}"
        sleep 1.5
        install_tools
    elif [[ $install_option = 13 ]]
    then
        apt install libnl-genl-3-dev build-essential git autoconf automake libtool pkg-config libnl-3-dev libssl-dev libpcre3-dev
        cd /root
        mkdir r4v10l1_temp_files
        cd r4v10l1_temp_files
        git clone https://github.com/aircrack-ng/mdk4
        cd mdk4
        make 
        make install
        cd /root
        rm -r /root/r4v10l1_temp_files
        echo
        echo -e "${red_color_slim} Mdk4${white_color} installed successfully!${normal_color}"
        sleep 1.5
        install_tools
    elif [[ $install_option = 14 ]]
    then
        apt-get install hashcat
        echo
        echo -e "${red_color_slim} Hashcat${white_color} installed successfully!${normal_color}"
        sleep 1.5
        install_tools
    elif [[ $install_option = 15 ]]
    then
        apt install libnl-genl-3-dev build-essential git autoconf automake libtool pkg-config libnl-3-dev libssl-dev libpcre3-dev
        cd /root
        mkdir r4v10l1_temp_files
        cd r4v10l1_temp_files
        wget https://github.com/aanarchyy/bully/archive/master.zip && unzip master.zip
        cd bully*/
        cd src/
        make
        make install
        cd /root
        rm -r /root/r4v10l1_temp_files
        echo
        echo -e "${red_color_slim} Bully${white_color} installed successfully!${normal_color}"
        sleep 1.5
        install_tools
    elif [[ $install_option = 16 ]]
    then
        apt install libnl-genl-3-dev build-essential git autoconf automake libtool pkg-config libnl-3-dev libssl-dev libpcre3-dev
        cd /root
        mkdir r4v10l1_temp_files
        cd r4v10l1_temp_files
        git clone https://github.com/wiire-a/pixiewps
        cd pixiewps*
        make 
        make install
        cd /root
        rm -r /root/r4v10l1_temp_files
        echo
        echo -e "${red_color_slim} Pixiewps${white_color} installed successfully!${normal_color}"
        sleep 1.5
        install_tools
    elif [[ $install_option = 17 ]]
    then
        apt-get install john
        echo
        echo -e "${red_color_slim} John${white_color} installed successfully!${normal_color}"
        sleep 1.5
        install_tools
    elif [[ $install_option = 18 || $install_option = 19 ]]
    then
        curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && chmod 755 msfinstall && ./msfinstall
        echo
        echo -e "${red_color_slim} Metasploit / Msfvenom${white_color} installed successfully!${normal_color}"
        sleep 1.5
        install_tools
    elif [[ $install_option = 19 ]]
    then
        apt-get install hydra
        echo
        echo -e "${red_color_slim} Hydra${white_color} installed successfully!${normal_color}"
        sleep 1.5
        install_tools
    elif [[ $install_option = 20 ]]
    then
        apt-get install rkhunter
        echo
        echo -e "${red_color_slim} Rkhunter${white_color} installed successfully!${normal_color}"
        sleep 1.5
        install_tools
    else
        echo
        echo -e "${red_color}    \(╰◣▂ ◢╯)Ψ   ${white_color}Wrong option!"
        sleep 1
        install_tools
    fi
}

# pip
function public_ip () {
	clear
    echo
	echo -e "${white_color}  Please wait..."
	CHECKMON=$(ifconfig | grep "mon")
	if [[ "$CHECKMON" = "" ]]
	then
		echo
		PUBLICIP=$(curl -s ipinfo.io/ip)
		if [[ "$PUBLICIP" = "" ]]
		then
			echo
			PUBLICIP="${red_color}Connection error.${normal_color}"
            echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
            read -p ""
            main_menu
	    else
            echo -e "${white_color}  Your public IP is ${red_color_slim}[${white_color} ${PUBLICIP} ${red_color_slim}]${normal_color}"
            echo
            echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
            read -p ""
            main_menu
        fi

	else
		echo -e "${white_color}Monitor mode enabled, I can't access internet!"
		echo -e "You can select 'man) Managed' to disable monitor mode.${normal_color}"
		echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
        read -p ""
        main_menu
	fi
    main_menu
}

# mon
function monitor_mode () {

    clear
    echo
    echo -ne "${red_color_slim} [ ${white_color}Interface name${red_color_slim} ]${normal_color}"
                echo -ne  " > " ;tput sgr0
    read interface_name_managed
    echo
    echo -e "${white_color} Changing...${normal_color}"
    airmon-ng start ${interface_name_managed} 1>/dev/null
    echo -e "${white_color} Done!${normal_color}"
    echo
    echo -ne "${white_color} Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
    read -p ""
    main_menu
    

}

# cmm
function monitor_mode_custom_channel () {

    clear
    echo
    echo -ne "${red_color_slim} [ ${white_color}Interface name${red_color_slim} ]${normal_color}"
                echo -ne  " > " ;tput sgr0
    read interface_name_managed
    echo
    echo -ne "${red_color_slim} [ ${white_color}Channel for the monitor mode${red_color_slim} ]${normal_color}"
                echo -ne  " > " ;tput sgr0
    read monitor_channel
    echo
    echo -e "${white_color} Changing...${normal_color}"
    airmon-ng start ${interface_name_managed} ${monitor_channel} 1>/dev/null
    echo -e "${white_color} Done!${normal_color}"
    echo
    echo -ne "${white_color} Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
    read -p ""
    main_menu

}

# man
function managed_mode () {

    clear
    echo
    echo -ne "${red_color_slim} [ ${white_color}Interface name${red_color_slim} ]${normal_color}"
                echo -ne  " > " ;tput sgr0
    read interface_name_monitor
    echo
    echo -e "${white_color} Changing...${normal_color}"
    airmon-ng stop ${interface_name_monitor} 1>/dev/null
    echo -e "${white_color} Done!${normal_color}"
    echo
    echo -ne "${white_color} Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
    read -p ""
    main_menu
    

}

# if
function if_option () {

    clear
    echo
    ifconfig
    echo
    echo -ne "${white_color} Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
    read -p ""
    main_menu

}

# lip
function just_local_ip () {

    clear
    CHECKMON=$(ifconfig | grep "mon")
	if [[ "$CHECKMON" = "" ]]
	then
        echo
        echo -ne "${red_color_slim} [ ${white_color}Interface name${red_color_slim} ]${normal_color}"
                    echo -ne  " > " ;tput sgr0
        read interface_name_managed
        echo
        echo -e " ${white_color}Your local IP is ${red_color_slim}[${white_color} $(ifconfig ${interface_name_managed} | head -n2 | tail -n1 | awk '{print $2}')${red_color_slim} ]${normal_color}"
        echo
        echo -ne "${white_color} Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
        read -p ""
        main_menu
    else
        echo -e "${white_color}Monitor mode enabled, I can't access internet!"
		echo -e "You can select 'man) Managed' to disable monitor mode.${normal_color}"
		echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
        read -p ""
        main_menu
    fi


}

# iw
function iw_option () {

    clear
    echo
    iwconfig
    echo
    echo -ne "${white_color} Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
    read -p ""
    main_menu

}

# 001
function deauth_menu () {

    clear
    echo
    echo -e "${red_color_slim} [${white_color} Deauth menu ${red_color_slim}]${normal_color}"
    echo
    echo -e "${white_color} 01) ${normal_color}Aireplay deauth${normal_color}"
    echo -e "${white_color} 00)${normal_color} Back${normal_color}"
    echo
    echo -e "${white_color} [Option]"
                echo -ne  "   > " ;tput sgr0
    read deauth_option

    if [[ $deauth_option = 0 ||  $deauth_option = 00 ]]
    then
        main_menu
    elif [[ $deauth_option = 1 || $deauth_option = 01 ]]
    then
        aireplay_deauth
    else
        echo
        echo -e "${red_color}    \(╰◣▂ ◢╯)Ψ   ${white_color}Wrong option!"
        sleep 1
        deauth_menu
    fi

}

# 001.1
function aireplay_deauth() {

    clear
	echo
    echo -ne "${red_color_slim} [ ${white_color}Interface name${red_color_slim} ]${normal_color}"
                    echo -ne  " > " ;tput sgr0
    read interface_name_monitor

    clear
    CHECKMON=$(ifconfig | grep "mon")
    if [[ "$CHECKMON" = "" ]]
    then

        echo -e "${white_color}  Managed mode enabled, I can't run the deauth!${normal_color}"
        echo -e "${white_color}  Do you want to activate monitor mode in ${red_color_slim} ${interface_name_monitor}${white_color}? ${normal_color}"
        echo -ne "${white_color}   [ Y / N ]"
                    echo -ne  " > " ;tput sgr0
        read deauth_option
        if [[ $deauth_option = y || $deauth_option = Y ]]
        then
            echo
            # echo -ne "${white_color}  [ Interface channel ]"
            #         echo -ne  " > " ;tput sgr0
            # read deauth_channel
            # airmon-ng start ${interface_name_monitor} ${deauth_channel} 1> /dev/null
            airmon-ng start ${interface_name_monitor} 1>/dev/null
            echo
            echo -e "${white_color}  Done! ${normal_color}"
            echo -e "${white_color}  I'll iwconfig for you so you can see the interface name. ${normal_color}"
            echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
            read -p ""
            clear
            iwconfig
            echo
            echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
            read -p ""
            aireplay_deauth
        else
            deauth_menu
        fi

    else
        
        echo
        echo -e "${white_color}  Now I will run airodump-ng to select the BSSID of the victim. Press Ctrl + C to stop it."
        echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
        read -p ""
        # airodump-ng -i ${interface_name_monitor} 
        mkdir /root/r4v10l1_temp_files
        mkdir /root/r4v10l1_temp_files/airodump
        cd /root/r4v10l1_temp_files/airodump
        airodump-ng -w r4v10l1_interrupt_package --output-format csv ${interface_name_monitor}
        echo
        echo -ne "${white_color} [ BSSID ]"
                    echo -ne  "   > " ;tput sgr0
        read victims_bssid

        mv /root/r4v10l1_temp_files/airodump/r4v10l1_interrupt_package* /root/r4v10l1_temp_files/airodump/${victims_bssid}_1.csv
        
        # echo
        # echo -ne "${white_color} [ CHANNEL ]"
        #             echo -ne  "   > " ;tput sgr0
        # read victims_channel
        
        # echo -ne "${white_color} [ ESSID ]"
        #             echo -ne  "   > " ;tput sgr0
        # read victims_essid

        clear
        echo -e "${white_color}  Now the program will get the channel of the victim to restart the monitor interface in the correct way. ${normal_color}"
        victims_channel=$(cat /root/r4v10l1_temp_files/airodump/${victims_bssid}*.csv | grep -i ${victims_bssid} | head -n1 | tail -n1 | awk '{print substr($6, 1, length($6)-1)}')
        cd /root
        rm -r /root/r4v10l1_temp_files
        airmon-ng stop ${interface_name_monitor} 1>/dev/null
        echo
        echo -ne "${red_color_slim} [ ${white_color}Interface name ( Managed mode )${red_color_slim} ]${normal_color}"
                        echo -ne  " > " ;tput sgr0
        read interface_name_managed
        airmon-ng start ${interface_name_managed} ${victims_channel} 1>/dev/null
        echo
        echo -ne "${red_color_slim} [ ${white_color}Number of \"deauths\" (Put 0 for infinite)${red_color_slim} ]${normal_color}"
                        echo -ne  " > " ;tput sgr0
        read aireplay_times
        echo
        echo -e "${white_color}  All done! ${normal_color}"
        echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to start the attack.${normal_color}"
        read -p ""
        clear
        # aireplay-ng -0 0 -a ${victims_bssid} ${interface_name_monitor}
        # aireplay-ng -0 0 -e ${victims_essid} ${interface_name_monitor}
        aireplay-ng --deauth ${aireplay_times} -a ${victims_bssid} --ignore-negative-one ${interface_name_monitor}
        echo
        echo -e "${white_color}  Attack finished! ${normal_color}"
        echo
        echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
        read -p ""
        airmon-ng stop ${interface_name_monitor}
        deauth_menu
    fi
    deauth_menu
}

# scn
function scan_networks () {

    clear
	echo
    echo -ne "${red_color_slim} [ ${white_color}Interface name${red_color_slim} ]${normal_color}"
                    echo -ne  " > " ;tput sgr0
    read interface_name_monitor

    clear
    CHECKMON=$(ifconfig | grep "mon")
    if [[ "$CHECKMON" = "" ]]
    then

        echo -e "${white_color}  Managed mode enabled, I can't scan the networks!${normal_color}"
        echo -e "${white_color}  Do you want to activate monitor mode in ${red_color_slim} ${interface_name_monitor}${white_color}? ${normal_color}"
        echo -ne "${white_color}   [ Y / N ]"
                    echo -ne  " > " ;tput sgr0
        read port_canning_option
        if [[ $port_canning_option = y || $port_canning_option = Y ]]
        then
            echo
            airmon-ng start ${interface_name_monitor} 1>/dev/null
            echo
            echo -e "${white_color}  Done! ${normal_color}"
            echo -e "${white_color}  I'll iwconfig for you so you can see the interface name. ${normal_color}"
            echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
            read -p ""
            clear
            iwconfig
            echo
            echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
            read -p ""
            scan_networks
        else
            main_menu
        fi

    else
        echo
        echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to scan.${normal_color}"
        read -p ""
        clear
        airodump-ng -i ${interface_name_monitor}
        echo
        echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
        read -p ""
        airmon-ng stop ${interface_name_monitor} 1>/dev/null
        main_menu
    fi
    main_menu

}

# 002
function scanning_menu () {

    clear
    echo
    echo -e "${red_color_slim} [${white_color} Port scanning menu ${red_color_slim}]${normal_color}"
    echo
    echo -e "${white_color} 01) ${normal_color}Scan all devices in network with nmap${normal_color}"
    echo -e "${white_color} 02) ${normal_color}Scan an IP and its ports with nmap${normal_color}"
    echo -e "${white_color} 00)${normal_color} Back${normal_color}"
    echo
    echo -e "${white_color} [Option]"
                echo -ne  "   > " ;tput sgr0
    read port_canning_option

    if [[ $port_canning_option = 0 ||  $port_canning_option = 00 ]]
    then
        main_menu
    elif [[ $port_canning_option = 1 || $port_canning_option = 01 ]]
    then
        scan_all_devices
    elif [[ $port_canning_option = 2 || $port_canning_option = 02 ]]
    then
        scan_regular_ip
    else
        echo
        echo -e "${red_color}    \(╰◣▂ ◢╯)Ψ   ${white_color}Wrong option!"
        sleep 1
        deauth_menu
    fi

}

# 002.1
function scan_all_devices () {

    clear
    CHECKINSTALL_NMAP=$(which nmap)
    if [[ CHECKINSTALL_NMAP = "" ]]
    then
        echo -e "${red_color_slim}  [${white_color} Nmap ${red_color_slim}] ${white_color} is not installed! You can install it in the \"ins)\" menu."
        echo
        echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
        read -p ""
        main_menu
    else
        echo
        CHECKMON=$(ifconfig | grep "mon")
        if [[ "$CHECKMON" = "" ]]
        then
            
            echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to start scanning.${normal_color}"
            read -p ""
            clear
            # nmap -sP 192.168.1.1-255
            nmap -sn 192.168.1.1-255
            echo
            echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
            read -p ""
            scanning_menu

        else
            echo -e "${white_color}Monitor mode enabled, I can't scan right!"
            echo -e "You can select 'man) Managed' to disable monitor mode.${normal_color}"
            echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
            read -p ""
            main_menu
        fi
        scanning_menu
    fi
}

function scan_regular_ip () {

    clear
    CHECKINSTALL_NMAP=$(which nmap)
    if [[ CHECKINSTALL_NMAP = "" ]]
    then
        echo -e "${red_color_slim}  [${white_color} Nmap ${red_color_slim}] ${white_color} is not installed! You can install it in the \"ins)\" menu."
        echo
        echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
        read -p ""
        main_menu
    else
        echo
        CHECKMON=$(ifconfig | grep "mon")
        if [[ "$CHECKMON" = "" ]]
        then
            
            echo -ne "${red_color_slim} [ ${white_color}IP to scan${red_color_slim} ]${normal_color}"
                        echo -ne  " > " ;tput sgr0
            read ip2scan
            clear
            echo
            nmap ${ip2scan}
            echo
            echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
            read -p ""
            scanning_menu

        else
            echo -e "${white_color}Monitor mode enabled, I can't scan right!"
            echo -e "You can select 'man) Managed' to disable monitor mode.${normal_color}"
            echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
            read -p ""
            main_menu
        fi
        scanning_menu
    fi
}

function bruteforce_menu () {

    clear
    echo
    echo -e "${red_color_slim} [${white_color} Bruteforce menu ${red_color_slim}]${normal_color}"
    echo
    echo -e "${white_color} 01) ${normal_color}Bruteforce SSH with hydra${normal_color}"
    echo -e "${white_color} 02) ${normal_color}Bruteforce FTP login with hydra${normal_color}"
    echo -e "${white_color} 00)${normal_color} Back${normal_color}"
    echo
    echo -e "${white_color} [Option]"
                echo -ne  "   > " ;tput sgr0
    read bruteforce_option

    if [[ $bruteforce_option = 0 ||  $bruteforce_option = 00 ]]
    then
        main_menu
    elif [[ $bruteforce_option = 1 || $bruteforce_option = 01 ]]
    then
        ssh_hydra_bruteforce
    elif [[ $bruteforce_option = 2 || $bruteforce_option = 02 ]]
    then
        ftp_hydra_bruteforce
    else
        echo
        echo -e "${red_color}    \(╰◣▂ ◢╯)Ψ   ${white_color}Wrong option!"
        sleep 1
        bruteforce_menu
    fi

}

function ssh_hydra_bruteforce () {

    clear
    CHECKINSTALL_HYDRA=$(which hydra)
    if [[ CHECKINSTALL_HYDRA = "" ]]
    then
        echo -e "${red_color_slim}  [${white_color} Hydra ${red_color_slim}] ${white_color} is not installed! You can install it in the \"ins)\" menu."
        echo
        echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
        read -p ""
        main_menu
    else
        echo
        CHECKMON=$(ifconfig | grep "mon")
        if [[ "$CHECKMON" = "" ]]
        then
            
            echo -ne "${red_color_slim} [ ${white_color}IP you want to bruteforce${red_color_slim} ]${normal_color}"
                        echo -ne  " > " ;tput sgr0
            read ssh_ip
            echo
            echo -ne "${red_color_slim} [ ${white_color}Username you want to bruteforce${red_color_slim} ]${normal_color}"
                        echo -ne  " > " ;tput sgr0
            read ssh_user
            echo
            echo -ne "${red_color_slim} [ ${white_color}Wordlist complete path (with the .txt extension)${red_color_slim} ]${normal_color}"
                        echo -ne  " > " ;tput sgr0
            read ssh_wordlist
            echo
            clear
            echo
            hydra ${ssh_ip} ssh -l ${ssh_user} -P ${ssh_wordlist} -vV
            echo
            echo
            echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
            read -p ""
            bruteforce_menu

        else
            echo -e "${white_color}Monitor mode enabled, I can't scan right!"
            echo -e "You can select 'man) Managed' to disable monitor mode.${normal_color}"
            echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
            read -p ""
            main_menu
        fi
        bruteforce_menu
    fi

}

function ftp_hydra_bruteforce () {

    clear
    CHECKINSTALL_HYDRA=$(which hydra)
    if [[ CHECKINSTALL_HYDRA = "" ]]
    then
        echo -e "${red_color_slim}  [${white_color} Hydra ${red_color_slim}] ${white_color} is not installed! You can install it in the \"ins)\" menu."
        echo
        echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
        read -p ""
        main_menu
    else
        echo
        CHECKMON=$(ifconfig | grep "mon")
        if [[ "$CHECKMON" = "" ]]
        then
            
            echo -ne "${red_color_slim} [ ${white_color}IP you want to bruteforce${red_color_slim} ]${normal_color}"
                        echo -ne  " > ftp://" ;tput sgr0
            read ftp_ip
            echo
            echo -ne "${red_color_slim} [ ${white_color}Username you want to bruteforce${red_color_slim} ]${normal_color}"
                        echo -ne  " > " ;tput sgr0
            read ftp_user
            echo
            echo -ne "${red_color_slim} [ ${white_color}Wordlist complete path (with the .txt extension)${red_color_slim} ]${normal_color}"
                        echo -ne  " > " ;tput sgr0
            read ftp_wordlist
            echo
            clear
            echo
            hydra -l ${ftp_user} -P ${ftp_wordlist} ftp://${ftp_ip}
            echo
            echo
            echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
            read -p ""
            bruteforce_menu
        else
            echo -e "${white_color}Monitor mode enabled, I can't scan right!"
            echo -e "You can select 'man) Managed' to disable monitor mode.${normal_color}"
            echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
            read -p ""
            main_menu
        fi
        bruteforce_menu
    fi

}

function default_login_bruteforce () {

    CHECKINSTALL_PIP=$(which pip)
    CHECKINSTALL_PIP3=$(which pip3)
    if [[ $CHECKINSTALL_PIP = "" ]]
    then
        apt-get install python-pip 1>/dev/null
    fi
    
    if [[ $CHECKINSTALL_PIP3 = "" ]]
    then
        apt-get install python3-pip 1>/dev/null
    fi

    pip install requests 1>/dev/null
    pip install colorama 1>/dev/null
    pip3 install requests 1>/dev/null
    pip3 install colorama 1>/dev/null

    clear
    echo
    python3 python/default_login_bruteforce.py 
    echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
    read -p ""
    bruteforce_menu

}

function rkhunter_scan () {

    clear
    CHECKINSTALL_RKHUNTER=$(which rkhunter)
    if [[ CHECKINSTALL_RKHUNTER = "" ]]
    then
        echo -e "${red_color_slim}  [${white_color} Rkhunter ${red_color_slim}] ${white_color} is not installed! You can install it in the \"ins)\" menu."
        echo
        echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
        read -p ""
        main_menu
    else
        echo
        echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to scan your PC with rkhunter.${normal_color}"
        read -p ""
        clear
        echo
        rkhunter -c
        echo
        echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
        read -p ""
        main_menu
    fi

}

###################################
#       STARTING THE PROGRAM      #
###################################

banner_animation
exit 0

######################################################################################################################################################################################################################