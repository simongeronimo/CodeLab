#!/bin/bash

main(){
    get_registry_address
}

get_registry_address() {
    echo -e "Enter the ip address and port of the private registry (XXX.XX.XX.XXX:PPPPP):"
    read -p "" registry_ip
    echo "You have entered the following address: $registry_ip"
}

main
