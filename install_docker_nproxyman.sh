#!/bin/bash

installApps()
{
    clear
    OS="$REPLY" ## <-- This $REPLY is about OS Selection
    echo "We can install Docker-CE, Docker-Compose, NGinX Proxy Manager, and Portainer-CE."
    echo "Please select 'y' for each item you would like to install."
    echo "NOTE: Without Docker you cannot use Docker-Compose, NGinx Proxy Manager, or Portainer-CE."
    echo "       You also must have Docker-Compose for NGinX Proxy Manager to be installed."
    echo ""
    echo ""
    
    ISACT=$( (sudo systemctl is-active docker ) 2>&1 )
    ISCOMP=$( (docker-compose -v ) 2>&1 )

    #### Try to check whether docker is installed and running - don't prompt if it is
    if [[ "$ISACT" != "active" ]]; then
        read -rp "Docker-CE (y/n): " DOCK
    else
        echo "Docker appears to be installed and running."
        echo ""
        echo ""
    fi

    if [[ "$ISCOMP" == *"command not found"* ]]; then
        read -rp "Docker-Compose (y/n): " DCOMP
    else
        echo "Docker-compose appears to be installed."
        echo ""
        echo ""
    fi

    read -rp "NGinX Proxy Manager (y/n): " NPM
    read -rp "Portainer-CE (y/n): " PTAIN

    if [[ "$PTAIN" == [yY] ]]; then
        echo ""
        echo ""
        PS3="Please choose either Portainer-CE or just Portainer Agent: "
        select _ in \
            " Full Portainer-CE (Web GUI for Docker, Swarm, and Kubernetes)" \
            " Portainer Agent - Remote Agent to Connect from Portainer-CE" \
            " Nevermind -- I don't need Portainer after all."
        do
            PORT="$REPLY"
            case $REPLY in
                1) startInstall ;;
                2) startInstall ;;
                3) startInstall ;;
                *) echo "Invalid selection, please try again..." ;;
            esac
        done
    fi
    
    startInstall
}

startInstall() 
{
    clear
    echo "#######################################################"
    echo "###         Preparing for Installation              ###"
    echo "#######################################################"
    echo ""
    sleep 3s

    #######################################################
    ###           Install for Debian / Ubuntu           ###
    #######################################################

    if [[ "$OS" != "1" ]]; then
        echo "    1. Installing System Updates... this may take a while...be patient. If it is being done on a Digial Ocean VPS, you should run updates before running this script."
        (sudo apt update && sudo apt upgrade -y) > ~/docker-script-install.log 2>&1 &
        ## Show a spinner for activity progress
        pid=$! # Process Id of the previous running command
        spin='-\|/'
        i=0
        while kill -0 $pid 2>/dev/null
        do
            i=$(( (i+1) %4 ))
            printf "\r${spin:$i:1}"
            sleep .1
        done
        printf "\r"

        echo "    2. Install Prerequisite Packages..."
        sleep 2s

        sudo apt install curl wget git -y >> ~/docker-script-install.log 2>&1

        echo "    3. Installing Docker-CE (Community Edition)..."
        sleep 2s

        curl -fsSL https://get.docker.com | sh >> ~/docker-script-install.log 2>&1

        echo "      - docker-ce version is now:"
        DOCKERV=$(docker -v)
        echo "          "${DOCKERV}
        sleep 3s

        if [[ "$OS" == 2 ]]; then
            echo "    5. Starting Docker Service"
            sudo systemctl docker start >> ~/docker-script-install.log 2>&1
        fi

    fi
        
    
    #######################################################
    ###              Install for CentOS 7 or 8          ###
    #######################################################
    if [[ "$OS" == "1" ]]; then
        if [[ "$DOCK" == [yY] ]]; then
            echo "    1. Updating System Packages..."
            sudo yum check-update >> ~/docker-script-install.log 2>&1

            echo "    2. Installing Prerequisite Packages..."
            sudo dnf install git curl wget -y >> ~/docker-script-install.log 2>&1

            echo "    3. Installing Docker-CE (Community Edition)..."

            sleep 2s
            (curl -fsSL https://get.docker.com/ | sh) >> ~/docker-script-install.log 2>&1

            echo "    4. Starting the Docker Service..."

            sleep 2s


            sudo systemctl start docker >> ~/docker-script-install.log 2>&1

            echo "    5. Enabling the Docker Service..."
            sleep 2s

            sudo systemctl enable docker >> ~/docker-script-install.log 2>&1

            echo "      - docker version is now:"
            DOCKERV=$(docker -v)
            echo "        "${DOCKERV}
            sleep 3s
        fi
    fi

    #######################################################
    ###               Install for Arch Linux            ###
    #######################################################

    if [[ "$OS" == "5" ]]; then
        read -rp "Do you want to install system updates prior to installing Docker-CE? (y/n): " UPDARCH
        if [[ "UPDARCH" == [yY] ]]; then
            echo "    1. Installing System Updates... this may take a while...be patient."
            (sudo pacman -Syu) > ~/docker-script-install.log 2>&1 &
            ## Show a spinner for activity progress
            pid=$! # Process Id of the previous running command
            spin='-\|/'
            i=0
            while kill -0 $pid 2>/dev/null
            do
                i=$(( (i+1) %4 ))
                printf "\r${spin:$i:1}"
                sleep .1
            done
            printf "\r"
        else
            echo "    1. Skipping system update..."
            sleep 2s
        fi

        echo "    2. Installing Prerequisit Packages..."
        sudo pacman -Sy git curl wget >> ~/docker-script-install.log 2>&1

        echo "    3. Installing Docker-CE (Community Edition)..."
            sleep 2s

            curl -fsSL https://get.docker.com | sh >> ~/docker-script-install.log 2>&1

            echo "    - docker-ce version is now:"
            DOCKERV=$(docker -v)
            echo "        "${DOCKERV}
            sleep 3s
    fi

    if [[ "$DOCK" == [yY] ]]; then
        # add current user to docker group so sudo isn't needed
        echo ""
        echo "  - Attempting to add the currently logged in user to the docker group..."

        sleep 2s
        sudo usermod -aG docker "${USER}" >> ~/docker-script-install.log 2>&1
        echo "  - You'll need to log out and back in to finalize the addition of your user to the docker group."
        echo ""
        echo ""
        sleep 3s
    fi

    if [[ "$DCOMP" = [yY] ]]; then
        echo "############################################"
        echo "######     Install Docker-Compose     ######"
        echo "############################################"

        # install docker-compose
        echo ""
        echo "    1. Installing Docker-Compose..."
        echo ""
        echo ""
        sleep 2s

        ######################################
        ###     Install Debian / Ubuntu    ###
        ######################################        
        
        if [[ "$OS" == "2" || "$OS" == "3" || "$OS" == "4" ]]; then
            sudo apt install docker-compose -y >> ~/docker-script-install.log 2>&1
        fi

        ######################################
        ###        Install CentOS 7 or 8   ###
        ######################################

        if [[ "$OS" == "1" ]]; then
            sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose >> ~/docker-script-install.log 2>&1

            sudo chmod +x /usr/local/bin/docker-compose >> ~/docker-script-install.log 2>&1
        fi

        ######################################
        ###        Install Arch Linux      ###
        ######################################

        if [[ "$OS" == "5" ]]; then
            sudo pacman -Sy >> ~/docker-script-install.log 2>&1
            sudo pacman -Sy docker-compose > ~/docker-script-install.log 2>&1
        fi

        echo ""

        echo "      - Docker Compose Version is now: " 
        DOCKCOMPV=$(docker-compose --version)
        echo "        "${DOCKCOMPV}
        echo ""
        echo ""
        sleep 3s
    fi

    ##########################################
    #### Test if Docker Service is Running ###
    ##########################################
    ISACT=$( (sudo systemctl is-active docker ) 2>&1 )
    if [[ "$ISACt" != "active" ]]; then
        echo "Giving the Docker service time to start..."
        while [[ "$ISACT" != "active" ]] && [[ $X -le 10 ]]; do
            sudo systemctl start docker >> ~/docker-script-install.log 2>&1
            sleep 10s &
            pid=$! # Process Id of the previous running command
            spin='-\|/'
            i=0
            while kill -0 $pid 2>/dev/null
            do
                i=$(( (i+1) %4 ))
                printf "\r${spin:$i:1}"
                sleep .1
            done
            printf "\r"
            ISACT=`sudo systemctl is-active docker`
            let X=X+1
            echo "$X"
        done
    fi

    if [[ "$NPM" == [yY] ]]; then
        echo "##########################################"
        echo "###     Install NGinX Proxy Manager    ###"
        echo "##########################################"
        docker network create my-main-net
        # pull an nginx proxy manager docker-compose file from github
        echo "    1. Pulling a default NGinX Proxy Manager docker-compose.yml file."

        mkdir -p docker/nginx-proxy-manager
        cd docker/nginx-proxy-manager

        curl https://raw.githubusercontent.com/mahmoudhashemm/docker_installs/refs/heads/main/docker_compose.nginx_proxy_manager.yml -o docker-compose.yml >> ~/docker-script-install.log 2>&1

        echo "    2. Running the docker-compose.yml to install and start NGinX Proxy Manager"
        echo ""
        echo ""

        if [[ "$OS" == "1" ]]; then
          docker-compose up -d
        fi

        if [[ "$OS" != "1" ]]; then
          sudo docker-compose up -d
        fi

        echo ""
        echo ""
        echo "    Navigate to your server hostname / IP address on port 81 to setup"
        echo "    NGinX Proxy Manager admin account."
        echo ""
        echo "    The default login credentials for NGinX Proxy Manager are:"
        echo "        username: admin@example.com"
        echo "        password: changeme"

        echo ""       
        sleep 3s
        cd
    fi

    if [[ "$PORT" == "1" ]]; then
        echo "########################################"
        echo "###      Installing Portainer-CE     ###"
        echo "########################################"
        echo ""
        echo "    1. Preparing to Install Portainer-CE"
        echo ""
        echo ""

        sudo docker volume create portainer_data
        sudo docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce
        echo ""
        echo ""
        echo "    Navigate to your server hostname / IP address on port 9000 and create your admin account for Portainer-CE"

        echo ""
        echo ""
        echo ""
        sleep 3s
    fi

    if [[ "$PORT" == "2" ]]; then
        echo "###########################################"
        echo "###      Installing Portainer Agent     ###"
        echo "###########################################"
        echo ""
        echo "    1. Preparing to install Portainer Agent"

        sudo docker volume create portainer_data
        sudo docker run -d -p 9001:9001 --name portainer_agent --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/docker/volumes:/var/lib/docker/volumes portainer/agent
        echo ""
        echo ""
        echo "    From Portainer or Portainer-CE add this Agent instance via the 'Endpoints' option in the left menu."
        echo "       ####     Use the IP address of this server and port 9001"
        echo ""
        echo ""
        echo ""
        sleep 3s
    fi

    exit 1
}

echo ""
echo ""

clear

echo "Let's figure out which OS / Distro you are running."
echo ""
echo ""
echo "    From some basic information on your system, you appear to be running: "
echo "        --  OpSys        " $(lsb_release -i)
echo "        --  Desc:        " $(lsb_release -d)
echo "        --  OSVer        " $(lsb_release -r)
echo "        --  CdNme        " $(lsb_release -c)
echo ""
echo "------------------------------------------------"
echo ""
PS3="Please select the number for your OS / distro: "
select _ in \
    "CentOS 7 / 8 / Fedora" \
    "Debian 10 / 11" \
    "Ubuntu 18.04" \
    "Ubuntu 20.04 / 21.04 / 22.04" \
    "Arch Linux" \
    "End this Installer"
do
  case $REPLY in
    1) installApps ;;
    2) installApps ;;
    3) installApps ;;
    4) installApps ;;
    5) installApps ;;
    6) exit ;;
    *) echo "Invalid selection, please try again..." ;;
  esac
done
