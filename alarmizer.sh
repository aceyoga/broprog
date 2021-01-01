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
    if [ $opt == "help" ]; then
        echo "play      : plays the given audio file(parameter 2) with the specified duration(parameter 3, optional)." && exit
    fi
    if [ -z "$2" ]; then
        $(aplay $1)
    else 
        $(aplay $1 -d $2)
    fi
}

function record(){
    if [ $opt == "help" ]; then 
        echo "record    : records sound via mic and saves it to the given filename(parameter 2) with the specified duration(parameter 3, optional)." && exit
    fi
    if [ $2 != "" ]; then
        echo "has duration"
        $(arecord $1 -d $2 -r 44100)
        exit        
    else
        echo "no duration"
        $(arecord $1)
        exit
    fi
}

function cvol(){
    if [ $opt == "help" ]; then 
        echo "cvol      : changes the volume gain of master to given number(parameter 2, in percentages, must be between 0-100)." && exit
    fi
    if [ $1 <= 100 && $1 >= 0 ]; then
        $(amixer set Master %${1})
        echo "Master volume set to" $(1)
    else 
        echo "Specified volume invalid. Try again."
    fi
}

function ivol(){
    if [ $opt == "help" ]; then 
        echo "ivol      : increases the volume gain of master by the given number(parameter 2, in percentages, must be between 0-100)."
        echo "            if the volume is increased beyond 100, an error will be printed to stderr."
        exit
    fi
    if [ $1 <= 100 && $1 >= 0 ]; then
        $(amixer set Master %${1}+)
        echo "Master volume set to " ${1}
    else 
        echo "Specified volume invalid. Try again."
    fi

}

function dvol(){
    if [ $opt == "help" ]; then 
        echo "ivol      : decreases the volume gain of master by the given number(parameter 2, in percentages, must be between 0-100)."
        echo "            if the volume is decreased beyond 0, an error will be printed to stderr."
        exit
    fi
    if [ $num <= 100 && $1 >= 0 ]; then
        $(amixer set Master %${1}-)
        echo "Master volume decreased to " ${1}
    else 
        echo "Specified volume invalid. Try again."
    fi
}

function setalarm(){
    if [ $opt == "help" ]; then 
        echo "setalarm  : sets an alarm with the given parameter 2 as time value(see man cronjob), and the parameter 3"
        echo "as the alarm sound(if not given, default value will be used). Alarm Duration is optional at parameter 4."
    fi
    $(crontab -l > jobs.txt)
    if [ ${2} != "" && ${3} != "" ]; then
        echo "${2} aplay ${2} -d ${3}" >> "jobs.txt"
    elif [ ${3} != "" ]; then
        echo "${1} aplay ${2}" >> "jobs.txt"
    else
        echo "${1} aplay " >> "jobs.txt"
    fi
    $(cron jobs.txt)
    echo "Alarm Set"
}

function showalarm(){
    if [ $opt == "help" ]; then 
        echo "showalarm : shows all alarms that have been created." && exit
    fi
    local count=1
    echo "=================================================================="
    echo "All alarm:"
    for $line in $(cat jobs.txt | grep aplay); do
        echo $count ". ${line}"
    done
    echo "=================================================================="
}

function delalarm(){
    if [ $opt == "help" ]; then 
        echo "delalarm  : removes the specified alarm from the system. Does not remove the sound used." && exit
    fi
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

function startup(){ # literally mindahin crontab dari default di /lalala/lilili/cron ke /home/user/broprog/jobs.txt
    crontab -l > /home/user/broprog/jobs.txt there :V 
}

msg=""
if [ $# == 0 ]; then
    clear
    read -p "Welcome to Broprog Alarmizer. What do you want to do? (type broproghelp to print manual): " msg
    order=($msg)
    ${order[0]} ${order[1]} ${order[2]} ${order[3]} ${order[4]} ${order[5]}
    echo "See you later :D"
fi

if [ $# == 1 ]; then
    [ "$1" == "help" ] && broproghelp && exit
    [ "$1" == "devlist" ] && $(aplay -l) && exit
    echo "Command not found. Try again."
    exit
else
    opt=$2
    $1 $2 $3 $4 $5
fi

