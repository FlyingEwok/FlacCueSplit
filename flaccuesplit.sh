#!/usr/bin/env bash

echo "Starting flaccuesplit"

path="$1"
cd "$path"

flaccuesplit ()
{
    cueFile="$1"
    flacFile="$2"
    echo "Now Splitting Files"
    shnsplit -f "$cueFile" -t %n-%t -o flac "$flacFile"
    if [ $? -ne 0 ]; then
        echo "Splitting Failed!"
        exit 1
    fi
}

splitflacTag ()
{
    cueFile="$1"
    cuetag "$cueFile" [0-9]*.flac
    echo "Files Tagged"
}

cueFile=(*.cue)
flacFile=(*.flac)

if [ ${#cueFile[@]} -gt 1 ]; then 
    echo -e "Multiple files found\nSelect one."
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