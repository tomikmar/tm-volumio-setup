
log() {
	echo `date +"%Y-%m-%d-%H:%M:%S:"` "$1" 
}


say() {
    if [ -x "$(command -v espeak)" ]; then
        espeak -a 200 "$1" --stdout | aplay -Dhw:1,0
    else
        echo "Command espeak not installed. Ignoring message: $1"
    fi
}


logAndSay() {
    log "$1"
    say "$1"
}


illuminate() {
    if [ -x "$(command -v /opt/volumio-scripts/illuminate.sh)" ]; then
        /opt/volumio-scripts/illuminate.sh $1
    else
        echo "Script illuminate.sh not found or not executable. Ignoring."
    fi
}

