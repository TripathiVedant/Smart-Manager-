#!/bin/bash

#Giving main functionality list
X=0
X1=0
zenity --info --width=200 --height=150 --text "Welcome to the Smart Manager" --ok-label "continue" --no-wrap
while [ "$X" -eq "$X1" ]
do
A="$(zenity --list --title "MAIN MENU" --column Selection --column Functionality \
\	TRUE "Disk Usage" \
\	FALSE "Memory Usage" \
\	FALSE "Login History" \
\	FALSE "Running Processes" \
\	FALSE "kill a process" \
\	FALSE "Search a process" \
\	FALSE "Process using most RAM" \
\	FALSE "Process using most CPU" \
\	FALSE "Commands History" \
\	FALSE "Search Something in history" \
	--width=600 --height=400 --radiolist --cancel-label "Quit")"
Stat=$?
Exitstat=1
#B1....n are for respective options selected from Menu
B1="Disk Usage"
B2="Memory Usage"
B3="Login History"
B4="Running Processes"
B5="kill a process"
B6="Search a process"
B7="Process using most RAM"
B8="Process using most CPU"
B9="Commands History"
B10="Search Something in history"

if [ "$Stat" -eq "1" ]
	then
		break

	#FOR DISK USAGE
	elif [ "$A" = "$B1" ]
	then 
		zenity --info --width=200 --height=150 --text "Disk usage:
		$(df -h | xargs | awk '{print "\nTotal disk: " $9 " \nFree Disk " $11}')"

	#FOR MEMORY USAGE
	elif [ "$A" = "$B2" ]
	then
		zenity --info --width=300 --height=200 --text "Memory usage:
		$(free -m | xargs | awk '{print "\nTotal Memory: " $8 " MB\nUsed Memory: " $9 " MB\nFree Memory: " $10 "MB\nShared Memory: " $11 " MB\n"s}')"

	#Login History	
	elif [ "$A" = "$B3" ]
	then
		N=$(zenity --entry --width=300 --height=100 --title "Login History" --text "Enter no. of history you want:")
		#my_array=$(last -a | head -$N)
		LHIST=()
		while IFS= read -r line; do
    		LHIST+=( "$line" )
		done < <( last -a | head -$N )
		zenity --list --width=600 --height=400 --title "Login History" --text "Login History of all the users is as follows:" --column "USER             DAY   DATE  TIME  STATUS" "${LHIST[@]}"
		#zenity --info --width=600 --height=200 --text "Last  $N  login history details are\n\n$my_array"

	#Running Processes	
	elif [ "$A" = "$B4" ]
	then
		RPRO=()
		while IFS= read -r line; do
    		RPRO+=( "$line" )
		done < <( top -b | head -300 )
		zenity --list --title "Running Process" --text " " --width=900 --height=900 --column Process "${RPRO[@]}"
		#zenity --info --width=1000 --height=600 --text "$(top -b | head -50)"

	#Kill a Process
	elif [ "$A" = "$B5" ]
	then
		PID="$(zenity --entry --width=300 --height=100 --title "Kill Process" --text "Please enter PID:")"
		kill $PID
		zenity --info --width=200 --height=150 --text "Request Forwarded!"

	#Search a process
	elif [ "$A" = "$B6" ]
	then
		key="$(zenity --entry --width=400 --height=100 --title "Search a Process" --text "Please enter keyword:")"
		KEYRET=()
		while IFS= read -r line; do
    		KEYRET+=( "$line" )
		done < <( ps aux | grep -i "$key" )
		zenity --list --width=900 --height=300 --title "Search Result" --text "Results are as follows:" --column PROCESSES "${KEYRET[@]}"

	#Process using most RAM
	elif [ "$A" = "$B7" ]
	then	
		MRAM=()
		while IFS= read -r line; do
    		MRAM+=( "$line" )
		done < <( ps -eo pid,cmd,%mem,%cpu --sort=-%mem | awk 'NR<=10{print $0}' | head )
		zenity --list --width=600 --height=600 --title "Process using most RAM" --text " " --column PROCESS "${MRAM[@]}"

	#Process using most CPU	
	elif [ "$A" = "$B8" ]
	then	
		MCPU=()
		while IFS= read -r line; do
    		MCPU+=( "$line" )
		done < <( ps -eo pid,cmd,%mem,%cpu --sort=-%cpu | awk 'NR<=10{print $0}' | head )
		zenity --list --width=600 --height=600 --column PROCESS --title "Process using most CPU" --text " " "${MCPU[@]}"
		#zenity --info --width=600 --height=300 --text "$(ps -eo pid,cmd,%mem,%cpu --sort=-%cpu | awk 'NR<=10{print $0}' | head)"

	#Command History
	elif [ "$A" = "$B9" ]
	then
		HISTFILE=~/.bash_history
		set -o history
		#TO STORE EACH LINE AS ELEMENT IN ARRAY WITH EACH ELEMENT QUOTED
		CHIST=()
		while IFS= read -r line; do
    		CHIST+=( "$line" )
		done < <( history )
		#ONE LINE AS ELEMENT IN ARRAY HIST :
		#mapfile -t HIST < <( cat ~/.bash_history | tail -50 )
		#EACH WORD AS ELEMENT IN ARRAY HIST: HIST=( $(cat ~/.bash_history | tail -50))
		zenity --list --title "COMMAND HISTORY" --text "" --width=900 --height=900 --column COMMAND "${CHIST[@]}"

	#Search command History
	elif [ "$A" = "$B10" ]
	then
		key2="$(zenity --entry --title "Search a Command" --text "Please enter keyword:")"
		HISTFILE=~/.bash_history
		set -o history
		SHIST=()c
		while IFS= read -r line; do
    		SHIST+=( "$line" )
		done < <( history | grep -i $key2 | tail -50 )
		zenity --list --title "COMMAND HISTORY" --text "" --width=900 --height=900 --column COMMAND "${SHIST[@]}"
		#zenity --info --width=900 --height=300 --text "$(cat ~/.bash_history | grep -i $key2 | tail -50)"
									   
fi
done
