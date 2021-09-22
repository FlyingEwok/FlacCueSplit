#!/usr/bin/env bash

echo "Starting flaccuesplit"

flaccuesplit ()
{
    cueFile=$1
    flacFile=$2
    shnsplit -f $cueFile -t %n-%t -o flac $flacFile
}

splitflacTag ()
{
    cueFile=$1
    cuetag $cueFile [0-9]*.flac
}

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

cueFile="SCRIPT_DIR/Outlaws - Playin' To Win + Ghost Riders.cue"
flacFile="SCRIPT_DIR/Outlaws - Playin' To Win + Ghost Riders.flac"

flaccuesplit cueFile flacFile

splitflacTag cueFile