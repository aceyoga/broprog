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
# -w : the time for setalarm. Format: month-week-day-

if [ "$#" -eq 0 ]; then
    echo "Welcome to Broprog Alarmizer. What do you want to do? (type help to print manual) "

elif [ "$#" -eq 1]; then
    if [ "$1" == "help" ]; then
        echo "Command list: \n
            help : show command list and how to use.\n
            devlist : lists all audio devices(equivalent of aplay -l).\n
            play : plays the given audio file with the specified args.\n
            record : records sound via mic and saves it to the given filename with the specified args.\n
            cvol : changes the volume gain of master to given args.\n
            ivol : increases the volume gain of master by the given args.\n
            dvol : decreases the volume gain of master by the given args.\n
            setalarm : sets an alarm with the given args as data, and the filename as the alarm sound(if not given, default value will be used).\n
            showalarm : shows all alarms that have been created.\n
            delalarm : removes the specified alarm from the system. Does not remove the sound used.\n
            "
        exit
    elif [ "$1" == "devlist"]; then
        $(aplay -l)
        exit
    else 
        echo "Command not found. Try again."
        exit
    fi
else 
    while getopts n:d:f:t:w flag
    do
        case "${flag}" in
            n) num=${OPTARG};;
            d) duration=${OPTARG};;
            f) filename=${OPTARG};;
            t) task=${OPTARG};;
            w) timeval=${OPTARG};;
        esac
    done
    if [ "$1" == "play" && -f ${filename} ]; then 
        if [ -v ${duration} ]; then
            $(aplay ${filename} -d ${duration})
            exit
        else
            $(aplay ${filename})
            exit
        fi
    elif [ "$1" == "record" ]
        if [ -v ${duration} ]; then
            $(arecord ${filename} -d ${duration})
            exit
        else
            $(arecord ${filename})
            exit
        fi
    elif [ "$1" == "cvol" ]
        echo "belum bisa"
    elif [ "$1" == "ivol" ]
        echo "belum bisa"
    elif [ "$1" == "dvol" ]
        echo "belum bisa"
    elif [ "$1" == "setalarm" ]
        echo "belum bisa"
    elif [ "$1" == "showalarm" ]
        echo "belum bisa"
    elif [ "$1" == "delalarm" ]
        echo "belum bisa"
    fi
fi









