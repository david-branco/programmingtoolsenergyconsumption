#!/bin/bash

#Programs to measure
#declare -a PROGS=("dummy")
declare -a PROGS=("dummy" "mandelbrot" "spectralnorm" "revcomp" "threadring" "regexredux" "meteorcontest" "nbody" "binarytrees" "chameneosredux" "fasta" "fannkuchredux" "knucleotide")


#Tools associative array initialization with all the tools and respectives profiles
declare -A TOOLS

: '
#WARMUP
WARMUP_DEBUG="-O0 -g -Wall"
declare -A WARMUP=( ["Debug"]=${WARMUP_DEBUG} )

for PROFILE in "${!WARMUP[@]}"; do
  TOOLS["Warmup",$PROFILE]=${WARMUP[$PROFILE]}
done
'

#ECLIPSE
ECLIPSE_DEBUG="-O0 -g3 -Wall -fmessage-length=0"
ECLIPSE_RELEASE="-O3 -Wall -fmessage-length=0"
declare -A ECLIPSE=( ["Debug"]=${ECLIPSE_DEBUG} ["Release"]=${ECLIPSE_RELEASE} )

for PROFILE in "${!ECLIPSE[@]}"; do
  TOOLS["Eclipse",$PROFILE]=${ECLIPSE[$PROFILE]}
done

#CODELITE
CODELITE_DEBUG="-g -O0 -Wall"
CODELITE_RELEASE="-O2 -Wall -DNDEBUG"
declare -A CODELITE=( ["Debug"]=${CODELITE_DEBUG} ["Release"]=${CODELITE_RELEASE} )

for PROFILE in "${!CODELITE[@]}"; do
  TOOLS["Codelite",$PROFILE]=${CODELITE[$PROFILE]}
done

#ANJUTA
ANJUTA_DEFAULT=""
ANJUTA_DEBUG="-g -O0"
ANJUTA_PROFILE="-g -pg"
ANJUTA_OPTIMIZED="-O2"
declare -A ANJUTA=( ["Default"]=${ANJUTA_DEFAULT} ["Debug"]=${ANJUTA_DEBUG} ["Profile"]=${ANJUTA_ROFILE} ["Optimized"]=${ANJUTA_OPTIMIZED} )

for PROFILE in "${!ANJUTA[@]}"; do
  TOOLS["Anjuta",$PROFILE]=${ANJUTA[$PROFILE]}
done

#CMAKE - CLion, KDevelop
CMAKE_DEBUG="-g"
CMAKE_RELEASE="-O3 -DNDEBUG"
CMAKE_RELWITHDEBINFO="-O2 -g -DNDEBUG"
CMAKE_MINSIZEREL="-Os -DNDEBUG"
declare -A CMAKE=( ["Debug"]=${CMAKE_DEBUG} ["Release"]=${CMAKE_RELEASE} ["RelDebInfo"]=${CMAKE_RELWITHDEBINFO} ["RelMinSize"]=${CMAKE_MINSIZEREL} )

for PROFILE in "${!CMAKE[@]}"; do
  TOOLS["CMake",$PROFILE]=${CMAKE[$PROFILE]}
done

#GEANY
GEANY_DEFAULT="-Wall"
declare -A GEANY=( ["Default"]=${GEANY_DEFAULT} )

for PROFILE in "${!GEANY[@]}"; do
  TOOLS["Geany",$PROFILE]=${GEANY[$PROFILE]}
done

#DIALOGBLOCKS
DIALOGBLOCKS_DEBUG="-O0 -ggdb -Wall -Wno-write-strings"
DIALOGBLOCKS_RELEASE="-O2 -Wall -Wno-write-strings"
declare -A DIALOGBLOCKS=( ["Debug"]=${DIALOGBLOCKS_DEBUG} ["Release"]=${DIALOGBLOCKS_RELEASE} )

for PROFILE in "${!DIALOGBLOCKS[@]}"; do
  TOOLS["DialogBlocks",$PROFILE]=${DIALOGBLOCKS[$PROFILE]}
done

#Qmake
QMAKE_DEBUG="-pipe -g -Wall -W -fPIC"
QMAKE_PROFILE="-pipe -O2 -g -Wall -W -fPIC"
QMAKE_RELEASE="-pipe -O2 -Wall -W -fPIC"
declare -A QMAKE=( ["Debug"]=${QMAKE_DEBUG} ["Profile"]=${QMAKE_PROFILE} ["Release"]=${QMAKE_RELEASE} )

for PROFILE in "${!QMAKE[@]}"; do
  TOOLS["Qmake",$PROFILE]=${QMAKE[$PROFILE]}
done

#ZINJAI
ZINJAI_DEBUG="-fshow-column -fno-diagnostics-show-caret -g2 -Wall -O0"
ZINJAI_RELEASE="-fshow-column -fno-diagnostics-show-caret -Wall -O2"
declare -A ZINJAI=( ["Debug"]=${ZINJAI_DEBUG} ["Release"]=${ZINJAI_RELEASE} )

for PROFILE in "${!ZINJAI[@]}"; do
  TOOLS["ZinjaI",$PROFILE]=${ZINJAI[$PROFILE]}
done

#GPS
GPS_SOMEOPT="-O"
GPS_FULLAUTOINLI="-O3"
declare -A GPS=( ["SomeOpt"]=${GPS_SOMEOPT} ["FullAutoInli"]=${GPS_FULLAUTOINLI} )

for PROFILE in "${!GPS[@]}"; do
  TOOLS["GPS",$PROFILE]=${GPS[$PROFILE]}
done

#QBS
QBS_DEBUG="-g -O0 -Wall -Wextra -pipe -fvisibility=default -fPIC"
QBS_RELEASE="-O2 -Wall -Wextra -pipe -fvisibility=default -fPIC -DNDEBUG"
declare -A QBS=( ["Debug"]=${QBS_DEBUG} ["Release"]=${QBS_RELEASE} )

for PROFILE in "${!QBS[@]}"; do
  TOOLS["QBS",$PROFILE]=${QBS[$PROFILE]}
done

#SPHERE ENGINE
SE_DEFAULT="-O2 -lm -fomit-frame-pointer"
declare -A SE=( ["Default"]=${SE_DEFAULT} )

for PROFILE in "${!SE[@]}"; do
  TOOLS["SphereEngine",$PROFILE]=${SE[$PROFILE]}
done

#AWS Cloud9
CLOUD9_DEBUG="-ggdb3"
declare -A CLOUD9=( ["Debug"]=${CLOUD9_DEBUG} )

for PROFILE in "${!CLOUD9[@]}"; do
  TOOLS["Cloud9",$PROFILE]=${CLOUD9[$PROFILE]}
done