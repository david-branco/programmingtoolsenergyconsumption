#!/bin/bash

declare -a PROGS=("binarytrees" "chameneosredux" "fannkuchredux" "fasta" "knucleotide" "mandelbrot" "meteorcontest" "nbody" "regexredux" "revcomp" "spectralnorm" "threadring")

for PROG in "${PROGS[@]}"
do	
	if [ "$1" == "-renameID" ]; then
		mv -T ../Outputs/$PROG/Anjuta,Default ../Outputs/$PROG/Anjuta,1 2>/dev/null
		mv -T ../Outputs/$PROG/Geany,Default ../Outputs/$PROG/Geany,2 2>/dev/null
		mv -T ../Outputs/$PROG/Anjuta,Debug ../Outputs/$PROG/Anjuta,3 2>/dev/null
		mv -T ../Outputs/$PROG/Anjuta,Profile ../Outputs/$PROG/Anjuta,4 2>/dev/null
		mv -T ../Outputs/$PROG/Cloud9,Debug ../Outputs/$PROG/Cloud9,5 2>/dev/null
		mv -T ../Outputs/$PROG/CMake,Debug ../Outputs/$PROG/CMake,6 2>/dev/null
		mv -T ../Outputs/$PROG/Eclipse,Debug ../Outputs/$PROG/Eclipse,7 2>/dev/null
		mv -T ../Outputs/$PROG/Codelite,Debug ../Outputs/$PROG/Codelite,8 2>/dev/null
		mv -T ../Outputs/$PROG/Qmake,Debug ../Outputs/$PROG/Qmake,9 2>/dev/null
		mv -T ../Outputs/$PROG/ZinjaI,Debug ../Outputs/$PROG/ZinjaI,10 2>/dev/null
		mv -T ../Outputs/$PROG/QBS,Debug ../Outputs/$PROG/QBS,11 2>/dev/null
		mv -T ../Outputs/$PROG/DialogBlocks,Debug ../Outputs/$PROG/DialogBlocks,12 2>/dev/null
		mv -T ../Outputs/$PROG/GPS,SomeOpt ../Outputs/$PROG/GPS,13 2>/dev/null
		mv -T ../Outputs/$PROG/CMake,RelDebInfo ../Outputs/$PROG/CMake,14 2>/dev/null
		mv -T ../Outputs/$PROG/Qmake,Profile ../Outputs/$PROG/Qmake,15 2>/dev/null
		mv -T ../Outputs/$PROG/Codelite,Release ../Outputs/$PROG/Codelite,16 2>/dev/null
		mv -T ../Outputs/$PROG/DialogBlocks,Release ../Outputs/$PROG/DialogBlocks,17 2>/dev/null
		mv -T ../Outputs/$PROG/Qmake,Release ../Outputs/$PROG/Qmake,18 2>/dev/null
		mv -T ../Outputs/$PROG/Anjuta,Optimized ../Outputs/$PROG/Anjuta,19 2>/dev/null
		mv -T ../Outputs/$PROG/QBS,Release ../Outputs/$PROG/QBS,20 2>/dev/null
		mv -T ../Outputs/$PROG/SphereEngine,Default ../Outputs/$PROG/SphereEngine,21 2>/dev/null
		mv -T ../Outputs/$PROG/ZinjaI,Release ../Outputs/$PROG/ZinjaI,22 2>/dev/null
		mv -T ../Outputs/$PROG/CMake,Release ../Outputs/$PROG/CMake,23 2>/dev/null
		mv -T ../Outputs/$PROG/Eclipse,Release ../Outputs/$PROG/Eclipse,24 2>/dev/null
		mv -T ../Outputs/$PROG/GPS,FullAutoInli ../Outputs/$PROG/GPS,25 2>/dev/null
		mv -T ../Outputs/$PROG/CMake,RelMinSize ../Outputs/$PROG/CMake,26 2>/dev/null

	elif [ "$1" == "-unrenameID" ]; then 
		mv -T ../Outputs/$PROG/Anjuta,1 ../Outputs/$PROG/Anjuta,Default 2>/dev/null
		mv -T ../Outputs/$PROG/Geany,2 ../Outputs/$PROG/Geany,Default 2>/dev/null
		mv -T ../Outputs/$PROG/Anjuta,3 ../Outputs/$PROG/Anjuta,Debug 2>/dev/null
		mv -T ../Outputs/$PROG/Anjuta,4 ../Outputs/$PROG/Anjuta,Profile 2>/dev/null
		mv -T ../Outputs/$PROG/Cloud9,5 ../Outputs/$PROG/Cloud9,Debug 2>/dev/null
		mv -T ../Outputs/$PROG/CMake,6 ../Outputs/$PROG/CMake,Debug 2>/dev/null
		mv -T ../Outputs/$PROG/Eclipse,7 ../Outputs/$PROG/Eclipse,Debug 2>/dev/null
		mv -T ../Outputs/$PROG/Codelite,8 ../Outputs/$PROG/Codelite,Debug 2>/dev/null
		mv -T ../Outputs/$PROG/Qmake,9 ../Outputs/$PROG/Qmake,Debug 2>/dev/null
		mv -T ../Outputs/$PROG/ZinjaI,10 ../Outputs/$PROG/ZinjaI,Debug 2>/dev/null
		mv -T ../Outputs/$PROG/QBS,11 ../Outputs/$PROG/QBS,Debug 2>/dev/null
		mv -T ../Outputs/$PROG/DialogBlocks,12 ../Outputs/$PROG/DialogBlocks,Debug 2>/dev/null
		mv -T ../Outputs/$PROG/GPS,13 ../Outputs/$PROG/GPS,SomeOpt 2>/dev/null
		mv -T ../Outputs/$PROG/CMake,14 ../Outputs/$PROG/CMake,RelDebInfo 2>/dev/null
		mv -T ../Outputs/$PROG/Qmake,15 ../Outputs/$PROG/Qmake,Profile 2>/dev/null
		mv -T ../Outputs/$PROG/Codelite,16 ../Outputs/$PROG/Codelite,Release 2>/dev/null
		mv -T ../Outputs/$PROG/DialogBlocks,17 ../Outputs/$PROG/DialogBlocks,Release 2>/dev/null
		mv -T ../Outputs/$PROG/Qmake,18 ../Outputs/$PROG/Qmake,Release 2>/dev/null
		mv -T ../Outputs/$PROG/Anjuta,19 ../Outputs/$PROG/Anjuta,Optimized 2>/dev/null
		mv -T ../Outputs/$PROG/QBS,20 ../Outputs/$PROG/QBS,Release 2>/dev/null
		mv -T ../Outputs/$PROG/SphereEngine,21 ../Outputs/$PROG/SphereEngine,Default  2>/dev/null
		mv -T ../Outputs/$PROG/ZinjaI,22 ../Outputs/$PROG/ZinjaI,Release 2>/dev/null
		mv -T ../Outputs/$PROG/CMake,23 ../Outputs/$PROG/CMake,Release 2>/dev/null
		mv -T ../Outputs/$PROG/Eclipse,24 ../Outputs/$PROG/Eclipse,Release 2>/dev/null
		mv -T ../Outputs/$PROG/GPS,25 ../Outputs/$PROG/GPS,FullAutoInli 2>/dev/null
		mv -T ../Outputs/$PROG/CMake,26 ../Outputs/$PROG/CMake,RelMinSize 2>/dev/null

	elif [ "$1" == "-debug" ]; then
		mkdir -p Aux Aux/$PROG/
		#mv -T ../Outputs/$PROG/Anjuta,Default ../Outputs/$PROG/Anjuta,1
		#mv -T ../Outputs/$PROG/Geany,Default ../Outputs/$PROG/Geany,2
		#mv -T ../Outputs/$PROG/Anjuta,Debug ../Outputs/$PROG/Anjuta,3
		#mv -T ../Outputs/$PROG/Anjuta,Profile ../Outputs/$PROG/Anjuta,4
		#mv -T ../Outputs/$PROG/Cloud9,Debug ../Outputs/$PROG/Cloud9,5
		#mv -T ../Outputs/$PROG/CMake,Debug ../Outputs/$PROG/CMake,6
		#mv -T ../Outputs/$PROG/Eclipse,Debug ../Outputs/$PROG/Eclipse,7
		#mv -T ../Outputs/$PROG/Codelite,Debug ../Outputs/$PROG/Codelite,8
		#mv -T ../Outputs/$PROG/Qmake,Debug ../Outputs/$PROG/Qmake,9
		#mv -T ../Outputs/$PROG/ZinjaI,Debug ../Outputs/$PROG/ZinjaI,10
		#mv -T ../Outputs/$PROG/QBS,Debug ../Outputs/$PROG/QBS,11
		#mv -T ../Outputs/$PROG/DialogBlocks,Debug ../Outputs/$PROG/DialogBlocks,12
		mv ../Outputs/$PROG/GPS,SomeOpt Aux/$PROG/
		mv ../Outputs/$PROG/CMake,RelDebInfo Aux/$PROG/
		mv ../Outputs/$PROG/Qmake,Profile Aux/$PROG/
		mv ../Outputs/$PROG/Codelite,Release Aux/$PROG/
		mv ../Outputs/$PROG/DialogBlocks,Release Aux/$PROG/
		mv ../Outputs/$PROG/Qmake,Release Aux/$PROG/
		mv ../Outputs/$PROG/Anjuta,Optimized Aux/$PROG/
		mv ../Outputs/$PROG/QBS,Release Aux/$PROG/
		mv ../Outputs/$PROG/SphereEngine,Default Aux/$PROG/
		mv ../Outputs/$PROG/ZinjaI,Release Aux/$PROG/
		mv ../Outputs/$PROG/CMake,Release Aux/$PROG/
		mv ../Outputs/$PROG/Eclipse,Release Aux/$PROG/
		mv ../Outputs/$PROG/GPS,FullAutoInli Aux/$PROG/
		mv ../Outputs/$PROG/CMake,RelMinSize Aux/$PROG/

	elif [ "$1" == "-undebug" ]; then
		#mv -T ../Outputs/$PROG/Anjuta,1 ../Outputs/$PROG/Anjuta,Default
		#mv -T ../Outputs/$PROG/Geany,2 ../Outputs/$PROG/Geany,Default
		#mv -T ../Outputs/$PROG/Anjuta,3 ../Outputs/$PROG/Anjuta,Debug
		#mv -T ../Outputs/$PROG/Anjuta,4 ../Outputs/$PROG/Anjuta,Profile
		#mv -T ../Outputs/$PROG/Cloud9,5 ../Outputs/$PROG/Cloud9,Debug
		#mv -T ../Outputs/$PROG/CMake,6 ../Outputs/$PROG/CMake,Debug
		#mv -T ../Outputs/$PROG/Eclipse,7 ../Outputs/$PROG/Eclipse,Debug
		#mv -T ../Outputs/$PROG/Codelite,8 ../Outputs/$PROG/Codelite,Debug
		#mv -T ../Outputs/$PROG/Qmake,9 ../Outputs/$PROG/Qmake,Debug
		#mv -T ../Outputs/$PROG/ZinjaI,10 ../Outputs/$PROG/ZinjaI,Debug
		#mv -T ../Outputs/$PROG/QBS,11 ../Outputs/$PROG/QBS,Debug
		#mv -T ../Outputs/$PROG/DialogBlocks,12 ../Outputs/$PROG/DialogBlocks,Debug
		mv Aux/$PROG/GPS,SomeOpt ../Outputs/$PROG/
		mv Aux/$PROG/CMake,RelDebInfo ../Outputs/$PROG/
		mv Aux/$PROG/Qmake,Profile ../Outputs/$PROG/
		mv Aux/$PROG/Codelite,Release ../Outputs/$PROG/
		mv Aux/$PROG/DialogBlocks,Release ../Outputs/$PROG/
		mv Aux/$PROG/Qmake,Release ../Outputs/$PROG/
		mv Aux/$PROG/Anjuta,Optimized ../Outputs/$PROG/
		mv Aux/$PROG/QBS,Release ../Outputs/$PROG/
		mv Aux/$PROG/SphereEngine,Default ../Outputs/$PROG/
		mv Aux/$PROG/ZinjaI,Release ../Outputs/$PROG/
		mv Aux/$PROG/CMake,Release ../Outputs/$PROG/
		mv Aux/$PROG/Eclipse,Release ../Outputs/$PROG/
		mv Aux/$PROG/GPS,FullAutoInli ../Outputs/$PROG/
		mv Aux/$PROG/CMake,RelMinSize ../Outputs/$PROG/
		rm -rf Aux/$PROG/

	elif [ "$1" == "-optimized" ]; then
		mkdir -p Aux Aux/$PROG/
		mv ../Outputs/$PROG/Anjuta,Default Aux/$PROG/
		mv ../Outputs/$PROG/Geany,Default Aux/$PROG/
		mv ../Outputs/$PROG/Anjuta,Debug Aux/$PROG/
		mv ../Outputs/$PROG/Anjuta,Profile Aux/$PROG/
		mv ../Outputs/$PROG/Cloud9,Debug Aux/$PROG/
		mv ../Outputs/$PROG/CMake,Debug  Aux/$PROG/
		mv ../Outputs/$PROG/Eclipse,Debug Aux/$PROG/
		mv ../Outputs/$PROG/Codelite,Debug Aux/$PROG/
		mv ../Outputs/$PROG/Qmake,Debug Aux/$PROG/
		mv ../Outputs/$PROG/ZinjaI,Debug Aux/$PROG/
		mv ../Outputs/$PROG/QBS,Debug Aux/$PROG/
		mv ../Outputs/$PROG/DialogBlocks,Debug Aux/$PROG/
		#mv -T ../Outputs/$PROG/GPS,SomeOpt ../Outputs/$PROG/GPS,13
		#mv -T ../Outputs/$PROG/CMake,RelDebInfo ../Outputs/$PROG/CMake,14
		#mv -T ../Outputs/$PROG/Qmake,Profile ../Outputs/$PROG/Qmake,15
		#mv -T ../Outputs/$PROG/Codelite,Release ../Outputs/$PROG/Codelite,16
		#mv -T ../Outputs/$PROG/DialogBlocks,Release ../Outputs/$PROG/DialogBlocks,17
		#mv -T ../Outputs/$PROG/Qmake,Release ../Outputs/$PROG/Qmake,18
		#mv -T ../Outputs/$PROG/Anjuta,Optimized ../Outputs/$PROG/Anjuta,19
		#mv -T ../Outputs/$PROG/QBS,Release ../Outputs/$PROG/QBS,20
		#mv -T ../Outputs/$PROG/SphereEngine,Default ../Outputs/$PROG/SphereEngine,21
		#mv -T ../Outputs/$PROG/ZinjaI,Release ../Outputs/$PROG/ZinjaI,22
		#mv -T ../Outputs/$PROG/CMake,Release ../Outputs/$PROG/CMake,23
		#mv -T ../Outputs/$PROG/Eclipse,Release ../Outputs/$PROG/Eclipse,24
		#mv -T ../Outputs/$PROG/GPS,FullAutoInli ../Outputs/$PROG/GPS,25
		#mv -T ../Outputs/$PROG/CMake,RelMinSize ../Outputs/$PROG/CMake,26

	elif [ "$1" == "-unoptimized" ]; then
		mkdir -p Aux Aux/$PROG/
		mv Aux/$PROG/Anjuta,Default ../Outputs/$PROG/
		mv Aux/$PROG/Geany,Default ../Outputs/$PROG/
		mv Aux/$PROG/Anjuta,Debug ../Outputs/$PROG/
		mv Aux/$PROG/Anjuta,Profile ../Outputs/$PROG/
		mv Aux/$PROG/Cloud9,Debug ../Outputs/$PROG/
		mv Aux/$PROG/CMake,Debug  ../Outputs/$PROG/
		mv Aux/$PROG/Eclipse,Debug ../Outputs/$PROG/
		mv Aux/$PROG/Codelite,Debug ../Outputs/$PROG/
		mv Aux/$PROG/Qmake,Debug ../Outputs/$PROG/
		mv Aux/$PROG/ZinjaI,Debug ../Outputs/$PROG/
		mv Aux/$PROG/QBS,Debug ../Outputs/$PROG/
		mv Aux/$PROG/DialogBlocks,Debug ../Outputs/$PROG/
		#mv -T ../Outputs/$PROG/GPS,13 ../Outputs/$PROG/GPS,SomeOpt
		#mv -T ../Outputs/$PROG/CMake,14 ../Outputs/$PROG/CMake,RelDebInfo
		#mv -T ../Outputs/$PROG/Qmake,15 ../Outputs/$PROG/Qmake,Profile
		#mv -T ../Outputs/$PROG/Codelite,16 ../Outputs/$PROG/Codelite,Release
		#mv -T ../Outputs/$PROG/DialogBlocks,17 ../Outputs/$PROG/DialogBlocks,Release
		#mv -T ../Outputs/$PROG/Qmake,18 ../Outputs/$PROG/Qmake,Release
		#mv -T ../Outputs/$PROG/Anjuta,19 ../Outputs/$PROG/Anjuta,Optimized
		#mv -T ../Outputs/$PROG/QBS,20 ../Outputs/$PROG/QBS,Release
		#mv -T ../Outputs/$PROG/SphereEngine,21 ../Outputs/$PROG/SphereEngine,Default
		#mv -T ../Outputs/$PROG/ZinjaI,22 ../Outputs/$PROG/ZinjaI,Release
		#mv -T ../Outputs/$PROG/CMake,23 ../Outputs/$PROG/CMake,Release
		#mv -T ../Outputs/$PROG/Eclipse,24 ../Outputs/$PROG/Eclipse,Release
		#mv -T ../Outputs/$PROG/GPS,25 ../Outputs/$PROG/GPS,FullAutoInli
		#mv -T ../Outputs/$PROG/CMake,26 ../Outputs/$PROG/CMake,RelMinSize
		rm -rf Aux/$PROG/
		
	elif [ "$1" == "-copy" ]; then 
		cp -R ../Outputs/$PROG/Anjuta,Default ../Outputs/$PROG/CodeBlocks,Default 2>/dev/null
		cp -R ../Outputs/$PROG/Anjuta,Default ../Outputs/$PROG/GPS,Default 2>/dev/null
		cp -R ../Outputs/$PROG/Anjuta,Default ../Outputs/$PROG/Cloud9,Default 2>/dev/null
		cp -R ../Outputs/$PROG/CMake,Debug ../Outputs/$PROG/CLion,Debug 2>/dev/null
		cp -R ../Outputs/$PROG/CMake,Debug ../Outputs/$PROG/KDevelop,Debug 2>/dev/null
		cp -R ../Outputs/$PROG/CMake,Debug ../Outputs/$PROG/QT,CmakeDebug 2>/dev/null
		cp -R ../Outputs/$PROG/CMake,Debug ../Outputs/$PROG/NetBeans,Debug 2>/dev/null
		cp -R ../Outputs/$PROG/CMake,Debug ../Outputs/$PROG/Oracle,Debug 2>/dev/null
		cp -R ../Outputs/$PROG/Qmake,Debug ../Outputs/$PROG/QT,QmakeDebug 2>/dev/null
		cp -R ../Outputs/$PROG/QBS,Debug ../Outputs/$PROG/QT,QBSDebug 2>/dev/null
		cp -R ../Outputs/$PROG/CMake,RelDebInfo ../Outputs/$PROG/CLion,RelDebInfo 2>/dev/null
		cp -R ../Outputs/$PROG/CMake,RelDebInfo ../Outputs/$PROG/KDevelop,RelDebInfo 2>/dev/null
		cp -R ../Outputs/$PROG/CMake,RelDebInfo ../Outputs/$PROG/QT,CmakeRelDebInfo 2>/dev/null
		cp -R ../Outputs/$PROG/Qmake,Profile ../Outputs/$PROG/QT,QmakeProfile 2>/dev/null
		cp -R ../Outputs/$PROG/Qmake,Release ../Outputs/$PROG/QT,QmakeRelease 2>/dev/null
		cp -R ../Outputs/$PROG/Anjuta,Optimized ../Outputs/$PROG/GPS,FullOpt 2>/dev/null
		cp -R ../Outputs/$PROG/Anjuta,Optimized ../Outputs/$PROG/NetBeans,Release 2>/dev/null
		cp -R ../Outputs/$PROG/Anjuta,Optimized ../Outputs/$PROG/Oracle,Release 2>/dev/null
		cp -R ../Outputs/$PROG/QBS,Release ../Outputs/$PROG/QT,QBSRelease 2>/dev/null
		cp -R ../Outputs/$PROG/CMake,Release ../Outputs/$PROG/CLion,Release 2>/dev/null
		cp -R ../Outputs/$PROG/CMake,Release ../Outputs/$PROG/KDevelop,Release 2>/dev/null
		cp -R ../Outputs/$PROG/CMake,Release ../Outputs/$PROG/QT,CmakeRelease 2>/dev/null
		cp -R ../Outputs/$PROG/CMake,RelMinSize ../Outputs/$PROG/CLion,RelMinSize 2>/dev/null
		cp -R ../Outputs/$PROG/CMake,RelMinSize ../Outputs/$PROG/KDevelop,RelMinSize 2>/dev/null
		cp -R ../Outputs/$PROG/CMake,RelMinSize ../Outputs/$PROG/QT,CmakeRelMinSize 2>/dev/null
		
	elif [ "$1" == "-remove" ]; then	
		rm -rf ../Outputs/$PROG/CodeBlocks,Default
		rm -rf ../Outputs/$PROG/GPS,Default
		rm -rf ../Outputs/$PROG/Cloud9,Default
		rm -rf ../Outputs/$PROG/CLion,Debug
		rm -rf ../Outputs/$PROG/KDevelop,Debug
		rm -rf ../Outputs/$PROG/QT,CmakeDebug
		rm -rf ../Outputs/$PROG/NetBeans,Debug
		rm -rf ../Outputs/$PROG/Oracle,Debug
		rm -rf ../Outputs/$PROG/QT,QmakeDebug
		rm -rf ../Outputs/$PROG/QT,QBSDebug
		rm -rf ../Outputs/$PROG/CLion,RelDebInfo
		rm -rf ../Outputs/$PROG/KDevelop,RelDebInfo
		rm -rf ../Outputs/$PROG/QT,CmakeRelDebInfo
		rm -rf ../Outputs/$PROG/QT,QmakeProfile
		rm -rf ../Outputs/$PROG/QT,QmakeRelease
		rm -rf ../Outputs/$PROG/GPS,FullOpt
		rm -rf ../Outputs/$PROG/NetBeans,Release
		rm -rf ../Outputs/$PROG/Oracle,Release
		rm -rf ../Outputs/$PROG/QT,QBSRelease
		rm -rf ../Outputs/$PROG/CLion,Release
		rm -rf ../Outputs/$PROG/KDevelop,Release
		rm -rf ../Outputs/$PROG/QT,CmakeRelease
		rm -rf ../Outputs/$PROG/CLion,RelMinSize
		rm -rf ../Outputs/$PROG/KDevelop,RelMinSize
		rm -rf ../Outputs/$PROG/QT,CmakeRelMinSize

	else echo "Invalid Option";
	fi
done

<<COMMENT
		mv -T ../Outputs/$PROG/Anjuta,Default
		mv -T ../Outputs/$PROG/Geany,Default
		mv -T ../Outputs/$PROG/Anjuta,Debug
		mv -T ../Outputs/$PROG/Anjuta,Profile
		mv -T ../Outputs/$PROG/Cloud9,Debug
		mv -T ../Outputs/$PROG/CMake,Debug
		mv -T ../Outputs/$PROG/Eclipse,Debug
		mv -T ../Outputs/$PROG/Codelite,Debug
		mv -T ../Outputs/$PROG/Qmake,Debug
		mv -T ../Outputs/$PROG/ZinjaI,Debug
		mv -T ../Outputs/$PROG/QBS,Debug
		mv -T ../Outputs/$PROG/DialogBlocks,Debug
		mv -T ../Outputs/$PROG/GPS,SomeOpt
		mv -T ../Outputs/$PROG/CMake,RelDebInfo
		mv -T ../Outputs/$PROG/Qmake,Profile
		mv -T ../Outputs/$PROG/Codelite,Release
		mv -T ../Outputs/$PROG/DialogBlocks,Release
		mv -T ../Outputs/$PROG/Qmake,Release
		mv -T ../Outputs/$PROG/Anjuta,Optimized
		mv -T ../Outputs/$PROG/QBS,Release
		mv -T ../Outputs/$PROG/SphereEngine,Default
		mv -T ../Outputs/$PROG/ZinjaI,Release
		mv -T ../Outputs/$PROG/CMake,Release
		mv -T ../Outputs/$PROG/Eclipse,Release
		mv -T ../Outputs/$PROG/GPS,FullAutoInli
		mv -T ../Outputs/$PROG/CMake,RelMinSize
COMMENT