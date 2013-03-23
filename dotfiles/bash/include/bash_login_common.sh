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
get_free_disk_space_info
get_system_core_name_ubuntu


echo -e "Date:\t\t"$(date)
echo -e "User:\t\t"$(whoami)"@"$(hostname)
echo -e "Login users:\t"$(users)
echo -e "Current path:\t"$(pwd)
echo -e "Uptime:\t\t"$(uptime)
echo -e "Server IP:\t"$(ifconfig | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}')
# ip addr show eth0 | grep "inet " | awk '{print $2}'

echo "Bash version"${BASH_VERSION%.*}
cat /proc/cpuinfo | grep "model name" | cut -d:  -f2 | cut -d" " -f2- | uniq -c # ubuntu
