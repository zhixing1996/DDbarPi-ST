#!/usr/bin/env bash

# Main driver to setup the environment 
# Author SHI Xin <shixin@ihep.ac.cn>
# Modified by Jing Maoqiang <jingmq@ihep.ac.cn>
# Created [2019-12-11 Wed 13:21]

usage() {
    printf "NAME\n\tsetup.sh - Main driver to setup the environment \n"
    printf "\nSYNOPSIS\n"
    printf "\n\t%-5s\n" "source setup.sh [OPTION]" 
    printf "\nOPTIONS\n" 
    printf "\n" 
    printf "\n\t%-20s  %-40s"  "boss-7.0.5"               "setup the boss 7.0.5"
    printf "\n\t%-20s  %-40s"  "boss-7.0.3.p01"           "setup the boss 7.0.3.p01"
    printf "\n\t%-20s  %-40s"  "init-boss-7.0.5"          "initialize the boss 7.0.5"
    printf "\n\t%-20s  %-40s"  "init-boss-7.0.3.p01"      "initialize the boss 7.0.3.p01"
    printf "\n\n" 
}
if [[ $# -eq 0 ]]; then
    usage
    echo "Please enter your option: "
    read option
else
    option=$1    
fi

case $option in

    init-boss-7.0.3.p01) echo "Initializing the boss 7.0.3.p01..."
                         mkdir -p besenv/7.0.3.p01
                         cd besenv/7.0.3.p01
                         cp -r /cvmfs/bes3.ihep.ac.cn/bes3sw/cmthome/cmthome-7.0.3.p01-Slc6Centos7Compat ./cmthome
                         cd cmthome
                         # cmthome
                         echo "set WorkArea \"/besfs5/groups/cal/dedx/$USER/bes/DDbarPi-ST\"" >> requirements
                         echo "path_remove CMTPATH  \"\${WorkArea}\"" >> requirements
                         echo "path_prepend CMTPATH  \"\${WorkArea}\"" >> requirements
                         source setupCMT.sh
                         cmt config
                         source setup.sh
                         cd ..
                         # TestRelease: go to /afs/ihep.ac.cn/bes3/offline/Boss/7.0.3.p01/TestRelease/TestRelease-00-00-86 to check TestRelease patch
                         mkdir -p TestRelease
                         cd TestRelease
                         cp -r /cvmfs/bes3.ihep.ac.cn/bes3sw/Boss/7.0.3.p01/TestRelease/TestRelease-00-00-86 .
                         cd TestRelease-00-00-86/cmt
                         cmt config
                         cd /besfs5/groups/cal/dedx/$USER/bes/DDbarPi-ST
                         ;; 

    init-boss-7.0.5) echo "Initializing the boss 7.0.5..."
                     mkdir -p besenv/7.0.5
                     cd besenv/7.0.5
                     cp -r /cvmfs/bes3.ihep.ac.cn/bes3sw/cmthome/cmthome-7.0.5-Slc6Centos7Compat ./cmthome
                     cd cmthome
                     # cmthome
                     echo "set WorkArea \"/besfs5/groups/cal/dedx/$USER/bes/DDbarPi-ST\"" >> requirements
                     echo "path_remove CMTPATH  \"\${WorkArea}\"" >> requirements
                     echo "path_prepend CMTPATH  \"\${WorkArea}\"" >> requirements
                     source setupCMT.sh
                     cmt config
                     source setup.sh
                     cd ..
                     # TestRelease: go to /afs/ihep.ac.cn/bes3/offline/Boss/7.0.5/TestRelease/TestRelease-00-00-92 to check TestRelease patch
                     mkdir -p TestRelease
                     cd TestRelease
                     cp -r /cvmfs/bes3.ihep.ac.cn/bes3sw/Boss/7.0.5/TestRelease/TestRelease-00-00-92 .
                     cd TestRelease-00-00-92/cmt
                     cmt config
                     cd /besfs5/groups/cal/dedx/$USER/bes/DDbarPi-ST
                     ;; 

    boss-7.0.3.p01) echo "Setting up boss 7.0.3.p01"
                    cd besenv/7.0.3.p01/cmthome
                    source setupCMT.sh
                    cmt config
                    source setup.sh
                    cd ../TestRelease/TestRelease-00-00-86/cmt
                    source setup.sh
                    cd /besfs5/groups/cal/dedx/$USER/bes/DDbarPi-ST
                    if [ ! -f "./Analysis/Physics/DDecayAlg/DDecayAlg-00-00-01/cmt/setup.sh" ]; then
                        echo "Please use ./build.sh 0.1.1 command to compile DDECAYALG analyzer and setup it..."
                    else
                        source ./Analysis/Physics/DDecayAlg/DDecayAlg-00-00-01/cmt/setup.sh
                    fi
                    ;;

    boss-7.0.5) echo "Setting up boss 7.0.5"
                cd besenv/7.0.5/cmthome
                source setupCMT.sh
                cmt config
                source setup.sh
                cd ../TestRelease/TestRelease-00-00-92/cmt
                source setup.sh
                cd /besfs5/groups/cal/dedx/$USER/bes/DDbarPi-ST
                if [ ! -f "./Analysis/Physics/DDecayAlg/DDecayAlg-00-00-01/cmt/setup.sh" ]; then
                    echo "Please use ./build.sh 0.1.1 command to compile DDECAYALG analyzer and setup it..."
                else 
                    source ./Analysis/Physics/DDecayAlg/DDecayAlg-00-00-01/cmt/setup.sh
                fi
                ;;

esac
