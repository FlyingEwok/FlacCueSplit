#!/usr/bin/env bash

# Colour Support
# Escape sequeces to change the text colour
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
LBLUE='\033[1;34m'
NC='\033[0m' # No Color

printC() {
    message=$1
    colour=$2
    echo -e "${colour}${message}${NC}"
}

printInfo() {
    printC "$1" $LBLUE
}

printSuccess() {
    printC "$1" $GREEN
}

printError() {
    printC "$1" $RED >&2
}

flaccuesplit ()
{
    cueFile="$1"
    flacFile="$2"
    printInfo "Now Splitting Files"
    shnsplit -f "$cueFile" -t %n-%t -o flac "$flacFile"
    if [ $? -ne 0 ]; then
        printError "Splitting Failed!"
        exit 1
    fi
}

splitflacTag ()
{
    cueFile="$1"
    cuetag "$cueFile" [0-9]*.flac
    printSuccess "Files Tagged"
}

printInfo "Starting flaccuesplit"

path="$1"
cd "$path"

cueFile=(*.cue)
flacFile=(*.flac)

if [ ${#cueFile[@]} -gt 1 ]; then
    printInfo "Multiple CUE files found\nSelect one."
    for INDEX in ${!cueFile[@]}; do 
        echo "${INDEX}) ${cueFile[${INDEX}]}"
    done
    
    read -p "Enter the number of the file you want: " usrSelection 
    cueFile="${cueFile[${usrSelection}]}"
else
    cueFile="${cueFile[0]}"
fi

flaccuesplit "$cueFile" "${flacFile[0]}"

splitflacTag "$cueFile"