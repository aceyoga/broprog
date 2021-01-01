#!/bin/bash
# Broprog Audio Playbach, Record, and Volume Mixer
# How to Use:
# ./broprog.sh command args
# syntax list:
# command : what the program does
# args : the command arguments
# filename :
# task : additional tasks that is called when an alarm is triggered.
#
# Command list:
# help : show command list and how to use.
# devlist : lists all audio devices(equivalent of aplay -l)
# play : plays the given audio file with the specified args.
# record : records sound via mic and saves it to the given filename with the specified args
# cvol : changes the volume gain of master to given args
# ivol : increases the volume gain of master by the given args
# dvol : decreases the volume gain of master by the given args
# setalarm : sets an alarm with the given args as data, and the filename as the alarm sound(if not given, default value will be used)
# showalarm : shows all alarms that have been created.
# delalarm : removes the specified alarm from the system. Does not remove the sound used.
#
# args :
# -n : an int, used by cvol ivol dvol.
# -d : duration, used by play, record.
# -f : the file name/path to file(relative to the program. Can be absolute path).
# -t : a single-line command encapsulated in "".
# -w : the time for setalarm. Format: month-week-day

function broproghelp(){
    echo "================================================================"
    echo "Command list:"
    echo "help      : show command list and how to use."
    echo "devlist   : lists all audio devices(equivalent of aplay -l)."
    echo "play      : plays the given audio file with the specified args."
    echo "record    : records sound via mic and saves it to the given filename with the specified args."
    echo "cvol      : changes the volume gain of master to given args."
    echo "ivol      : increases the volume gain of master by the given args."
    echo "dvol      : decreases the volume gain of master by the given args."
    echo "setalarm  : sets an alarm with the given args as data, and the filename as the alarm sound(if not given, default value will be used)."
    echo "showalarm : shows all alarms that have been created."
    echo "delalarm  : removes the specified alarm from the system. Does not remove the sound used."
    echo "=================================================================="
    exit
}

function pause(){
    local message="$@"
    [ -z $message ] && message="Press [Enter] to continue"
    read -p "$message" readEnterKey
}

function play(){
    if [ -z "$duration" ]; then
        $(aplay $filename)
    else 
        $(aplay $filename -d $duration)
    fi
}

function record(){
    if [ -v ${duration} ]; then
        $(arecord $filename -d $duration)
        exit
    else
        $(arecord $filename)
        exit
    fi
}

function cvol(){
    if [ $num <= 100 && $num >= 0 ]; then
        $(amixer set Master %${num})
        echo "Master volume set to" $(num)
    else 
        echo "Specified volume invalid. Try again."
    fi
}

function ivol(){
    if [ $num <= 100 && $num >= 0 ]; then
        $(amixer set Master %${num}+)
        echo "Master volume set to " ${num}
    else 
        echo "Specified volume invalid. Try again."
    fi
    
}

function dvol(){
    if [ $num <= 100 && $num >= 0 ]; then
        $(amixer set Master %${num}-)
        echo "Master volume decreased to " ${num}
    else 
        echo "Specified volume invalid. Try again."
    fi
}

function setalarm(){
    $(crontab -l > jobs.txt)
    echo "${timeval} aplay ${filename} ${duration}" >> "jobs.txt"
    $(cron jobs.txt)
    echo "Alarm Set"
}

function showalarm(){
    local count=1
    echo "=================================================================="
    echo "All alarm:"
    for $line in $(cat jobs.txt | grep aplay); do
        echo $count ". ${line}"
    done
    echo "=================================================================="
}

function delalarm(){
    local count=1
    local msg
    echo "=================================================================="
    echo "All alarm:"
    for $line in $(cat jobs.txt | grep aplay); do
        echo $count ". ${line}"
    done
    echo "=================================================================="

    read -p "Which alarm you want to delete?" msg
    [ msg <= count ] && $(cat jobs.txt | grep aplay | sed -i '${msg}d' jobs.txt)
}

msg=""
if [ $# == 0 ]; then
    read -p "Welcome to Broprog Alarmizer. What do you want to do? (type help to print manual): " msg
    echo $msg
    #$(conditionals)
fi

if [ $# == 1 ]; then
    [ "$1" == "help" ] && broproghelp && exit
    [ "$1" == "devlist" ] && $(aplay -l) && exit
    echo "Command not found. Try again."
    exit
else
    while getopts "n:d:f:t:w:" flag; do
        case "${flag}" in
            n) num=${OPTARG};;
            d) duration=${OPTARG};;
            f) filename=${OPTARG};;
            t) task=${OPTARG};;
            w) timeval=${OPTARG};;
        esac
    done
    echo "num = ${num}"
    echo "duration = ${duration}"
    echo "filename = ${filename}"
    echo "task = ${task}"
    echo "timeval = ${timeval}"
    $1
fi
