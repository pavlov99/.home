function get_free_disk_space_info {
    df -h . | tail -n+2 | awk '{print "Used: "$3"/"$2" ("$5") Free: "$4}'
}

function get_system_core_name_ubuntu {
    echo $(lsb_release -dc | cut -f2 | xargs echo)" ("$(uname -o)" "$(uname -r)" "$(uname -m)")"
}

function get_system_core_name_macos {
    echo $(sw_vers -productName)" "$(sw_vers -productVersion)" ("$(uname -rsm)")"
}

function get_free_memory_info_ubuntu {
    free -m | grep "Mem:" | awk '{print "Used: "$3"Mb/"$2"Mb ("int($3/$2*100)"%) Free: "$4"Mb"}'
}

function get_free_memory_info_mac {
    # total_memory=$(ps -caxm -orss,comm | awk 'BEGIN{mem=0}{mem+=$1}END{print mem/1024}')
    total_memory=$(sysctl hw.memsize | awk '{print $2/(1024^2)}')
    # free_memory=$(vm_stat | grep "Pages free:" | awk '{print $3 * 4096 / (1024^2)}')
    free_memory=$(vm_stat | grep "Pages free:" | awk '{print $3 * 4 / 1024}')
    echo | awk -v fm=$free_memory -v tm=$total_memory '{print "Used: "tm-fm"Mb/"tm"Mb ("int((tm-fm)/tm*100)"%) Free: "fm"Mb"}'
}


function get_ip_address_ubuntu {
    ip addr show eth0 | grep "inet " | awk '{print $2}'
}
get_free_disk_space_info
# get_system_core_name_ubuntu

echo -e "Date:\t\t"$(date)
echo -e "User:\t\t"$(whoami)"@"$(hostname)
echo -e "Login users:\t"$(users)
echo -e "Current path:\t"$(pwd)
echo -e "Uptime:\t\t"$(uptime)
echo "Bash version: "${BASH_VERSION%.*}

# cat /proc/cpuinfo | grep "model name" | cut -d:  -f2 | cut -d" " -f2- | uniq -c # ubuntu
# sudo lshw # ubuntu show hardware info
# vmstat # also memory stat ubuntu
# system_profiler # mac hardware overview
# sysctl -a # mac low level overview
