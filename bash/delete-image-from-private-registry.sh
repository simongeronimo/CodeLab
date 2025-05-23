#!/bin/bash

# ========== Global Variables ==========
registry_ip=""
imageSelected=""
versionSelected=""

# ========== Functions ==========
get_homelab_registry_default() {
    tailscale_homelab_ip=$(tailscale ip --4 homelab)
    registry_service_port=$(kubectl get svc --namespace registry -o jsonpath="{.items[0].spec.ports[0].nodePort}")
    registry_ip="$tailscale_homelab_ip:$registry_service_port"
}

get_registry_address() {
    echo -e "Enter the IP address and port of the private registry (XXX.XX.XX.XXX:PPPPP) \n[Press Enter to use your homelab default]:"
    read -p "" registry_ip_manual
    registry_ip=${registry_ip_manual:-$registry_ip}
    echo "You have entered the following address: $registry_ip"
}

select_from_available_images() {
    images=$(curl -X GET $registry_ip/v2/_catalog | jq -r '.repositories[]')
    imageSelected=$(echo "$images" | fzf --prompt="Select a repository: ")
    [[ -n "$imageSelected" ]]
}

select_tag_from_image() {
    versionsList=$(curl -X GET $registry_ip/v2/$imageSelected/tags/list | jq -r '.tags[]')
    versionSelected=$(echo "$versionsList" | fzf --prompt="Select a version: ")
    [[ -n "$versionSelected" ]]
}

request_confirmation() {
    echo "Are you sure you want to delete $imageSelected:$versionSelected? [Y/n]"
    read -p "" confirmation
    confirmation=${confirmation:-y}
    [[ "$confirmation" =~ ^[Yy]$ ]]
}

delete_image() {
    digest=$(curl -sI \
        -H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
        "$registry_ip/v2/$imageSelected/manifests/$versionSelected" \
        | grep Docker-Content-Digest \
        | awk '{print $2}' \
        | tr -d $'\r')
    curl -X DELETE "$registry_ip/v2/$imageSelected/manifests/$digest"
    echo "$imageSelected:$versionSelected has been deleted"
}

main() {
    get_homelab_registry_default
    get_registry_address

    if ! select_from_available_images; then
        echo "No repository selected. Exiting."
        exit 1
    fi

    if ! select_tag_from_image; then
        echo "No tag selected. Exiting."
        exit 1
    fi

    if ! request_confirmation; then
        echo "Aborted by user."
        exit 1
    fi

    delete_image
}

main
