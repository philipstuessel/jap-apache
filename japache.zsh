#!/bin/zsh
alias apache="japache"
japa_MAIN_FOLDER="${JAP_FOLDER}plugins/packages/japache/config/"
japa_CONFIG_FILE="${japa_MAIN_FOLDER}japache.config.json"

get_os() {
    os=$(jq -r '.os' "$japa_CONFIG_FILE")
    echo $os
}

japache() {
    if [[ "$1" == "v" || "$1" == "-v" ]];then
        echo -e "${YELLOW}J${NC}${RED}apache${NC}"
        echo -e "${BOLD}v0.1.2${NC}"
        echo -e "${YELLOW}JAP plugin${NC}"
        echo -e  "-----------------------"
        echo -e "${BLUE}OS: '$(get_os)'${NC}"
        echo -e  "-----------------------"
        apachectl -v
        echo -e  "-----------------------"
    fi

    if [[ "$1" == "os" ]];then
        echo "- Linux: l"
        echo "- Apple Intel: ai"
        echo "- Apple Silicon: as"
        echo -n "Your option: "
        read option
        json=$(jq --arg os "$option" '.os = $os' "$japa_CONFIG_FILE")
        echo "$json" > "$japa_CONFIG_FILE"
        echo -e "${YELLOW}You chose option '$option'${NC}"
    fi

    if [[ "$1" == "s" || "$1" == "status" ]];then
        os=$(get_os)
        ip="$(jip -r local)"
        if curl -s -o /dev/null -I -w "%{http_code}" http://$ip/ | grep -q "200"; then
            echo -e "${GREEN}${BOLD}Apache is active${NC}"
        else
            echo -e "${RED}${BOLD}Apache is not active${NC}"
        fi
    fi

    if [[ "$1" == "restart" ]];then
        apr
    fi
    
    if [[ "$1" == "start" || "$1" == "stop" ]];then
        aps
    fi
}

apr() {
    os=$(get_os)
    if [[ $os == "l" ]];then
        echo "restart apache"
        sudo systemctl restart apache2
    fi

    if [[ $os == "ai" || $os == "as" ]];then
        echo "restart apache"
        apachectl restart
    fi
}

aps() {
    os=$(get_os)
    ip="$(jip -r local)"
    if curl -s -o /dev/null -I -w "%{http_code}" http://$ip/ | grep -q "200"; then
        if [[ $os == "l" ]];then
            echo "stop apache"
            sudo systemctl stop apache2
        fi
        if [[ $os == "ai" || $os == "as" ]];then
            echo "stop apache"
            apachectl stop
        fi
    else
        if [[ $os == "l" ]];then
            echo "start apache"
            sudo systemctl start apache2
        fi
        if [[ $os == "ai" || $os == "as" ]];then
            echo "start apache"
            apachectl start
        fi
    fi
}

host() {
     os=$(get_os)
     if [[ $os == "ai" || $os == "as" ]];then
        code /etc/hosts
     fi
}

vhost() {
    os=$(get_os)
    if [[ $os == "ai" ]];then
        code /usr/local/etc/httpd/extra/httpd-vhosts.conf
    fi

    if [[ $os == "as" ]];then
        code /opt/homebrew/etc/httpd/extra/httpd-vhosts.conf
    fi
}