#!/usr/bin/env bash

# Colour Support
# Escape sequeces to change the text colour
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
LBLUE='\033[1;34m'
NC='\033[0m' # No Color

# Print colourful messages
printColour() {
    message=$1
    colour=$2
    echo -e "${colour}${message}${NC}"
}

# Print infomation messages
printInfo() {
    printColour "$1" $LBLUE
}

# Print Success Messages
printSuccess() {
    printColour "$1" $GREEN
}

# Print Error Messages
printError() {
    printColour "$1" $RED >&2
}

# Print Debug messages
# Note the DEBUG variable must be set to true
printDebug() {
    if [ "$DEBUG" = true ]; then
        printColour "$1" $YELLOW
    fi
}

# Split CUE Sheet file
flaccuesplit ()
{
    cueFile="$1"
    flacFile="$2"
    
    printInfo "Now Splitting Files from $cueFile"
    
    shnsplit -f "$cueFile" -t %n-%t -o flac "$flacFile"
    if [ $? -ne 0 ]; then
        printError "Splitting Failed!"
        exit 1
    fi
    
    printSuccess "Success Splitting Files"

}

# Apply metadata to extracted files from the CUE Sheet file
splitflacTag ()
{
    cueFile="$1"
    
    printInfo "Tagging Files from $cueFile"
    cuetag "$cueFile" [0-9]*.flac
    printSuccess "Files Tagged"
}

printInfo "Starting flaccuesplit"

# Save off the script and its base directory
currentScriptName="$0"
baseDir="$PWD"

# Capture arguement and change to it
path="$1"
cd "$path"

# Find out what CUE and FLAC files exist
cueFile=(*.cue)
flacFile=(*.flac)

# By default don't skip processing
skipProcessing=false

if [ ${#cueFile[@]} -gt 1 -a ${#flacFile[@]} -gt 1 ]; then # Multiple CUE / Multiple FLAC
    printInfo "Found Multiple CUE Sheet and Audio Files"
    for INDEX in ${!cueFile[@]}; do
        FILE="${cueFile[${INDEX}]}"
        
        printDebug "Current File $FILE"
        
        # Read the CUE Sheet for the corresponding FLAC file
        # There might be multiple FILE commands in the CUE Sheet, so handle this as an array
        readarray cueAudioFiles < <(grep FILE "$FILE" | sed -En 's/.*FILE "(.+)".*/\1/p')
        if [ ${#cueAudioFiles[@]} -gt 1 ]; then
            printError "SKIPPED: The CUE Sheet ($FILE) contains multiple FILE commands, this is not supported 😞"
            continue
        fi

        # It is known there is only one audio file, grab its file name
        cueAudioFile=$(echo "${cueAudioFiles[0]}" | xargs)

        # Move the CUE and FLAC file to a new directory
        fileNameWithoutExt=$(basename -s .cue "$FILE")
        printInfo "Creating new directory for Album: $fileNameWithoutExt"        
        mkdir -p "$fileNameWithoutExt"
        mv "$FILE" "$cueAudioFile" "$fileNameWithoutExt"
        
        # Read flac file with this tool
        eval "$baseDir/$currentScriptName \"$fileNameWithoutExt\""

        # Move original files back to their original location
        mv "$fileNameWithoutExt/$FILE" "$fileNameWithoutExt/$cueAudioFile" .
    done
    skipProcessing=true
elif [ ${#cueFile[@]} -gt 1 ]; then # Multiple CUE / Single FLAC
    printInfo "Multiple CUE files found\nSelect one."
    for INDEX in ${!cueFile[@]}; do 
        echo "${INDEX}) ${cueFile[${INDEX}]}"
    done
    
    read -p "Enter the number of the file you want: " usrSelection 
    cueFile="${cueFile[${usrSelection}]}"
else # Single CUE / Single FLAC
    cueFile="${cueFile[0]}"
fi

# Only process if processing isn't requested to be skipped
if [ "$skipProcessing" != true ]; then 
    flaccuesplit "$cueFile" "${flacFile[0]}"

    splitflacTag "$cueFile"
    printSuccess "CUE file successfully processed"
fi