#!/bin/bash

#File with all the programs and tools needed
source sources.sh

declare -p PROGS
declare -p TOOLS

#Compile the measure framework
gcc -O2 -Wall -o rapl-read rapl-read.c -lm

#Execute the measurement
mkdir -p Outputs
for PROG in "${PROGS[@]}"
do
	echo "Analysing: $PROG"
	rm -rf Outputs/$PROG
	mkdir Outputs/$PROG

	for TOOL_PROFILE in "${!TOOLS[@]}"
	do		
		echo -e "\t$TOOL_PROFILE: ${TOOLS[$TOOL_PROFILE]}"
		mkdir Outputs/$PROG/$TOOL_PROFILE
		perl -pi -e "s/^CFLAGS.*/CFLAGS = ${TOOLS[$TOOL_PROFILE]}/" Source_Files/$PROG/Makefile

		if [ "$1" == "-e" ]; then 
			echo -e "\tCompiling $PROG"
			make -C Source_Files/$PROG/ &> Outputs/$PROG/compilation$TOOL_PROFILE.txt
		fi

		for i in {1..50}
		do 
			printf "$i "
			if [ "$1" == "-e" ]
				then
					sudo ./rapl-read -c 1 -t -e Source_Files/$PROG/$PROG &> Outputs/$PROG/$TOOL_PROFILE/output$i.txt
				else 
					sudo ./rapl-read -c 1 -t -m Source_Files/$PROG -s Source_Files/$PROG/$PROG.c &> Outputs/$PROG/$TOOL_PROFILE/output$i.txt
			fi			
		done
		echo
	done
	echo
done

#perl outputprocessing.pl