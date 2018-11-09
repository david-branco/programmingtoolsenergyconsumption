#!/bin/bash

charts_profiles () {
	echo -e "\tCHARTS Profiles"
	perl outputprocessing.pl -chartsprofiles
}

charts_tools () {
	echo -e "\tCHARTS Tools"
	./outputmanagement.sh -copy
	perl outputprocessing.pl -chartstools
	./outputmanagement.sh -remove
}

charts_total_ids () {
	echo -e "\tCHARTS TOTAL IDS"
	./outputmanagement.sh -renameID
	perl outputprocessing.pl -chartstotalids
	./outputmanagement.sh -unrenameID
}	

charts_total_tools () {
	echo -e "\tCHARTS TOTAL TOOLS"
	./outputmanagement.sh -renameID
	perl outputprocessing.pl -chartstotaltools
	./outputmanagement.sh -unrenameID
}	

charts_categories () {
	echo -e "\tCHARTS Categories"
	./outputmanagement.sh -renameID
	perl outputprocessing.pl -chartscategories
	./outputmanagement.sh -unrenameID
}	

charts_debug () {
	#Alternatively use charts -categories
	./outputmanagement.sh -debug
	charts_tools
	charts_total_ids 
	charts_total_tools 
	mkdir -p Charts/Debug
	mv Charts/Tools/ Charts/Debug
	mv Charts/TotalIDs/ Charts/Debug
	mv Charts/TotalTools/ Charts/Debug
	./outputmanagement.sh -undebug
}

charts_optimized () {
	#Alternatively use charts -categories
	./outputmanagement.sh -optimized
	charts_tools
	charts_total_ids
	charts_total_tools  
	mkdir -p Charts/Optimized
	mv Charts/Tools/ Charts/Optimized
	mv Charts/TotalIDs/ Charts/Optimized
	mv Charts/TotalTools/ Charts/Optimized
	./outputmanagement.sh -unoptimized
}

rankings_progs () {
	echo -e "\tRANKINGS Progs"
	./outputmanagement.sh -renameID
	perl outputprocessing.pl -rankprogs
	./outputmanagement.sh -unrenameID
}

rankings_ids () {
	echo -e "\tRANKINGS IDs"
	./outputmanagement.sh -renameID
	perl outputprocessing.pl -rankids
	mv Rankings/rankids.txt Rankings/rankidstotal.txt
	./outputmanagement.sh -unrenameID
}	

rankings_tools () {
	echo -e "\tRANKINGS Tools"
	./outputmanagement.sh -renameID
	perl outputprocessing.pl -ranktools
	./outputmanagement.sh -unrenameID
}

rankings_debug () {
	echo -e "\tRANKINGS Debug"
	./outputmanagement.sh -debug
	./outputmanagement.sh -renameID
	perl outputprocessing.pl -rankids
	mv Rankings/rankids.txt Rankings/rankidsdebug.txt
	perl outputprocessing.pl -ranktools
	mv Rankings/ranktools.txt Rankings/ranktoolsdebug.txt
	./outputmanagement.sh -unrenameID
	./outputmanagement.sh -undebug
}

rankings_optimized () {
	echo -e "\tRANKINGS Optimized"
	./outputmanagement.sh -optimized
	./outputmanagement.sh -renameID
	perl outputprocessing.pl -rankids
	mv Rankings/rankids.txt Rankings/rankidsoptimized.txt
	perl outputprocessing.pl -ranktools
	mv Rankings/ranktools.txt Rankings/ranktoolsoptimized.txt
	./outputmanagement.sh -unrenameID
	./outputmanagement.sh -unoptimized
}

if [ "$1" == "-charts" ]; then
	charts_profiles 
	charts_tools
	charts_total_ids
	charts_total_tools
	charts_categories

elif [ "$1" == "-rankings" ]; then
	rankings_progs
	rankings_ids
	rankings_tools

elif [ "$1" == "-complete" ]; then
	echo -e "Complete"
	charts_profiles 
	charts_tools
	charts_total_ids
	charts_total_tools
	charts_categories
	rankings_progs
	rankings_ids
	rankings_tools

elif [ "$1" == "-chartscategories" ]; then
	charts_categories 

elif [ "$1" == "-chartstotaltools" ]; then
	charts_total_tools 

elif [ "$1" == "-ranktools" ]; then
	rankings_tools 

elif [ "$1" == "-debug" ]; then
	echo -e "Debug"
	charts_debug
	rankings_debug

elif [ "$1" == "-chartsdebug" ]; then
	#Alternatively use charts -categories
	echo -e "\tCHARTS Debug"
	charts_debug

elif [ "$1" == "-rankdebug" ]; then	
	echo -e "\tRANKINGS Debug"
	rankings_debug	

elif [ "$1" == "-optimized" ]; then
	echo -e "Optimized"
	charts_optimized
	rankings_optimized

elif [ "$1" == "-chartsoptimized" ]; then
	#Alternatively use charts -categories
	echo -e "\tCHARTS OPTIMIZED"
	charts_optimized

elif [ "$1" == "-rankoptimized" ]; then
	echo -e "\tRANKINGS Optimized"
	rankings_optimized

else echo "Invalid Option";
fi
