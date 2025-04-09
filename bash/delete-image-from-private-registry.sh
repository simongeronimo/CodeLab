#!/bin/bash

main(){
    get_registry_address
    show_available_images
}

get_registry_address() {
    echo -e "Enter the ip address and port of the private registry (XXX.XX.XX.XXX:PPPPP):"
    read -p "" registry_ip
    echo "You have entered the following address: $registry_ip"
}

show_available_images() {
    images=$(curl -X GET $registry_ip/v2/_catalog | jq -r '.repositories[]')
    echo $images
    select repo in $images; do
        if [ -n "$repo" ]; then
            echo "You selected: $repo"
            # You can process the selected repository here
            break
        else
            echo "Invalid option, please try again."
        fi
    done
}

main
