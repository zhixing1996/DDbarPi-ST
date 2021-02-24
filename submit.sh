#!/usr/bin/env bash

# Main driver to submit jobs 
# Author SHI Xin <shixin@ihep.ac.cn>
# Modified by JING Maoqiang <jingmq@ihep.ac.cn>
# Created [2019-12-11 Dec 14:56]

usage() {
    printf "NAME\n\tsubmit.sh - Main driver to submit jobs\n"
    printf "\nSYNOPSIS\n"
    printf "\n\t%-5s\n" "./submit.sh [OPTION]" 
    printf "\nOPTIONS\n" 
    printf "\n\t%-9s  %-40s"  "0.1"       "[run on data sample for DDbarPi-ST @703]"
    printf "\n\t%-9s  %-40s"  "0.2"       "[run on data sample for DDbarPi-ST @705]"
    printf "\n\t%-9s  %-40s"  "0.3"       "[run on MC samples for DDbarPi-ST @705]"
    printf "\n\n" 
}

usage_0_1() {
    printf "\n\t%-9s  %-40s"  ""          ""
    printf "\n\t%-9s  %-40s"  "0.1.1"     "Split data sample with each group 20G"
    printf "\n\t%-9s  %-40s"  "0.1.2"     "Generate Condor jobs on data ---- 1"
    printf "\n\t%-9s  %-40s"  "0.1.3"     "Test for data"
    printf "\n\t%-9s  %-40s"  "0.1.4"     "Submit Condor jobs on data ---- 2"
    printf "\n\t%-9s  %-40s"  "0.1.5"     "Synthesize data root files"
    printf "\n\t%-9s  %-40s"  "0.1.6"     "Get necessary info"
    printf "\n\t%-9s  %-40s"  "0.1.7"     "Apply cuts"
    printf "\n\t%-9s  %-40s"  ""           ""
    printf "\n"
}

usage_0_2() {
    printf "\n\t%-9s  %-40s"  ""          ""
    printf "\n\t%-9s  %-40s"  "0.2.1"     "Split data sample with each group 20G"
    printf "\n\t%-9s  %-40s"  "0.2.2"     "Generate Condor jobs on data ---- 1"
    printf "\n\t%-9s  %-40s"  "0.2.3"     "Test for data"
    printf "\n\t%-9s  %-40s"  "0.2.4"     "Submit Condor jobs on data ---- 2"
    printf "\n\t%-9s  %-40s"  "0.2.5"     "Synthesize data root files"
    printf "\n\t%-9s  %-40s"  "0.2.6"     "Get necessary info"
    printf "\n\t%-9s  %-40s"  "0.2.7"     "Apply cuts"
    printf "\n\t%-9s  %-40s"  ""           ""
    printf "\n"
}

usage_0_3() {
    printf "\n\t%-9s  %-40s"  ""          ""
    printf "\n\t%-9s  %-40s"  "0.3.1"     "Generate MC samples ---- Simulation && Reconstruction"
    printf "\n\t%-9s  %-40s"  "0.3.2"     "Generate MC samples ---- Event Selection"
    printf "\n\t%-9s  %-40s"  "0.3.3"     "Synthesize inclusive MC samples root files"
    printf "\n\t%-9s  %-40s"  "0.3.4"     "Get necessary info"
    printf "\n\t%-9s  %-40s"  "0.3.5"     "Apply cuts"
    printf "\n\t%-9s  %-40s"  ""           ""
    printf "\n"
}

if [[ $# -eq 0 ]]; then
    usage
    echo "Please enter your option: "
    read option
else
    option=$1
fi

sub_0_1() {

case $option in
    
    # --------------------------------------------------------------------------
    #  run on data sample for DDbarPi-ST @703 
    # --------------------------------------------------------------------------

    0.1.1) echo "Split data sample with each group 20G ..."
           cd ./run/DDbarPi/gen_script
           ./make_file_list_Data_DDbarPi.sh 703
           chmod u+x Gen_FileList_Data_703
           bash Gen_FileList_Data_703
           rm -r Gen_FileList_Data_703
           cd /besfs5/groups/cal/dedx/$USER/bes/DDbarPi-ST
	       ;;

    0.1.2) echo "Generate Condor jobs on data ---- 1..." 
	       cd ./run/DDbarPi/gen_script
	       ./make_jobOption_file_Data_DDbarPi.sh 703
	       cd /besfs5/groups/cal/dedx/$USER/bes/DDbarPi-ST/run/DDbarPi/jobs_text/data/4600
	       cp -r jobOptions_DDbarPi_data_4600-1.txt jobOptions_DDbarPi_data_4600-0.txt
           sed -i "s/ApplicationMgr\.EvtMax = -1/ApplicationMgr\.EvtMax = 20000/g" jobOptions_DDbarPi_data_4600-0.txt
           sed -i "s/DDbarPi_data_4600-1\.root/DDbarPi_data_4600-0\.root/g" jobOptions_DDbarPi_data_4600-0.txt
	       ;;

    0.1.3) echo "Test for data" 
           echo "have you changed test number?(yes / no)
           ./run/DDbarPi/jobs_text/data/4600/jobOptions_DDbarPi_data_4600-0.txt"
           read opt
           if [ $opt == "yes" ]
               then
               echo "now in yes"  
               cd ./run/DDbarPi/jobs_text/data/4600
               boss.exe jobOptions_DDbarPi_data_4600-0.txt
           else
               echo "Default value is 'no', please change test number."
           fi
           ;;

    0.1.4) echo "Submit Condor jobs on data ---- 2..." 
	       cd ./run/DDbarPi/gen_script
           ./sub_jobOption_file_Data_DDbarPi.sh 703
	       ;;

    0.1.5) echo "Synthesize data root files..."
	       cd ./run/DDbarPi/gen_script
           ./syn_Data_DDbarPi.sh 703
	       ;;

    0.1.6) echo "Get necessary info..."
	       cd ./run/DDbarPi/gen_script
           ./get_info_Data_DDbarPi.sh 703
           mv Get_Info_Data_703 ../logfile
           cd ../logfile
           chmod u+x Get_Info_Data_703
           mkdir -p jobs.out jobs.err
           hep_sub -g physics Get_Info_Data_703 -o jobs.out -e jobs.err
	       ;;

    0.1.7) echo "Apply cuts ..."
           cd ./run/DDbarPi/gen_script
           ./apply_cuts_Data_DDbarPi.sh 703
           mv Apply_Cuts_Data_703 ../logfile
           cd ../logfile
           chmod u+x Apply_Cuts_Data_703
           bash Apply_Cuts_Data_703
           cd /besfs5/groups/cal/dedx/$USER/bes/DDbarPi-ST
	       ;;

esac

}

sub_0_2() {

case $option in
    
    # --------------------------------------------------------------------------
    #  run on data sample for DDbarPi-ST @705 
    # --------------------------------------------------------------------------

    0.2.1) echo "Split data sample with each group 20G ..."
           cd ./run/DDbarPi/gen_script
           ./make_file_list_Data_DDbarPi.sh 705
           chmod u+x Gen_FileList_Data_705
           bash Gen_FileList_Data_705
           rm -r Gen_FileList_Data_705
           cd /besfs5/groups/cal/dedx/$USER/bes/DDbarPi-ST
	       ;;

    0.2.2) echo "Generate Condor jobs on data ---- 1..." 
	       cd ./run/DDbarPi/gen_script
	       ./make_jobOption_file_Data_DDbarPi.sh 705
	       cd /besfs5/groups/cal/dedx/$USER/bes/DDbarPi-ST/run/DDbarPi/jobs_text/data/4620
	       cp -r jobOptions_DDbarPi_data_4620-1.txt jobOptions_DDbarPi_data_4620-0.txt
           sed -i "s/ApplicationMgr\.EvtMax = -1/ApplicationMgr\.EvtMax = 20000/g" jobOptions_DDbarPi_data_4620-0.txt
           sed -i "s/DDbarPi_data_4620-1\.root/DDbarPi_data_4620-0\.root/g" jobOptions_DDbarPi_data_4620-0.txt
	       ;;

    0.2.3) echo "Test for data" 
           echo "have you changed test number?(yes / no)
           ./run/DDbarPi/jobs_text/data/4620/jobOptions_DDbarPi_data_4620-0.txt"
           read opt
           if [ $opt == "yes" ]
               then
               echo "now in yes"  
               cd ./run/DDbarPi/jobs_text/data/4620
               boss.exe jobOptions_DDbarPi_data_4620-0.txt
           else
               echo "Default value is 'no', please change test number."
           fi
           ;;

    0.2.4) echo "Submit Condor jobs on data ---- 2..." 
	       cd ./run/DDbarPi/gen_script
           ./sub_jobOption_file_Data_DDbarPi.sh 705
	       ;;

    0.2.5) echo "Synthesize data root files..."
	       cd ./run/DDbarPi/gen_script
           ./syn_Data_DDbarPi.sh 705
	       ;;

    0.2.6) echo "Get necessary info..."
	       cd ./run/DDbarPi/gen_script
           ./get_info_Data_DDbarPi.sh 705
           mv Get_Info_Data_705 ../logfile
           cd ../logfile
           chmod u+x Get_Info_Data_705
           mkdir -p jobs.out jobs.err
           hep_sub -g physics Get_Info_Data_705 -o jobs.out -e jobs.err
	       ;;

    0.2.7) echo "Apply cuts ..."
           cd ./run/DDbarPi/gen_script
           ./apply_cuts_Data_DDbarPi.sh 705
           mv Apply_Cuts_Data_705 ../logfile
           cd ../logfile
           chmod u+x Apply_Cuts_Data_705
           bash Apply_Cuts_Data_705
           cd /besfs5/groups/cal/dedx/$USER/bes/DDbarPi-ST
	       ;;

esac

}

sub_0_3() {

case $option in
    
    # --------------------------------------------------------------------------
    #  run on MC samples for DDbarPi-ST @705 
    #      DDPI    --> e+e- --> D-D0-barpi+
    # --------------------------------------------------------------------------

    0.3.1) echo "Generate MC samples ---- Simulation && Reconstruction ..."
           echo "which MC sample do you want to simulate?"
           read opt
           if [ $opt == "DDPI" ]; then
               cd /besfs5/groups/cal/dedx/$USER/bes/DDbarPi-ST/run/DDbarPi/gen_script/gen_mc/DDPI
               echo "which BOSS version do you want to simulate?"
               read boss
               if [ $boss -ne "703" ] or [ $boss -ne "705" ]; then
                   echo "Boss version is 703 or 705!"
                   exit -1
               fi
               ./sub_jobOption_D_D_PI.sh $boss
           else
               echo "Please add the MC simulation joboption files!"
           fi
	       ;;

    0.3.2) echo "Generate MC samples ---- Event Selection ..."
           echo "which MC sample do you want to select?"
           read opt
           if [ $opt == "DDPI" ]; then
               cd /besfs5/groups/cal/dedx/$USER/bes/DDbarPi-ST/run/DDbarPi/gen_script/gen_mc/DDPI
               echo "which BOSS version do you want to simulate?"
               read boss
               if [ $boss -ne "703" ] or [ $boss -ne "705" ]; then
                   echo "Boss version is 703 or 705!"
                   exit -1
               fi
               ./sub_Ana_D_D_PI.sh $boss
           else
               echo "Please add the MC simulation joboption files!"
           fi
	       ;;

    0.3.3) echo "Synthesize inclusive MC samples root files ..."
           cd ./run/DDbarPi/gen_script
           echo "which MC sample do you want to synthesize?"
           read opt
           if [ $opt == "DDPI" ]; then
               echo "which BOSS version do you want to simulate?"
               read boss
               if [ $boss -ne "703" ] or [ $boss -ne "705" ]; then
                   echo "Boss version is 703 or 705!"
                   exit -1
               fi
               ./syn_MC_DDbarPi.sh $boss $opt
           else
               echo "Please add the MC simulation joboption files!"
           fi
	       ;;

    0.3.4) echo "Get necessary info..."
           echo "which MC sample's info do you want to get?"
           read opt
           if [ $opt == "DDPI" ]; then
	           cd /besfs5/groups/cal/dedx/$USER/bes/DDbarPi-ST/run/DDbarPi/gen_script
               echo "which BOSS version do you want to simulate?"
               read boss
               if [ $boss -ne "703" ] or [ $boss -ne "705" ]; then
                   echo "Boss version is 703 or 705!"
                   exit -1
               fi
               ./get_info_MC_DDbarPi.sh $boss $opt
               mkdir -p ../logfile
               mv Get_Info_MC_${opt}_${boss} ../logfile
               cd /besfs5/groups/cal/dedx/$USER/bes/DDbarPi-ST/run/DDbarPi/logfile
               chmod u+x Get_Info_MC_${opt}_${boss}
               mkdir -p jobs.out jobs.err
               hep_sub -g physics Get_Info_MC_${opt}_${boss} -o jobs.out -e jobs.err
           else
               echo "Please add the MC simulation joboption files!"
           fi
           ;;

    0.3.5) echo "Apply cuts ..."
           cd ./run/DDbarPi/gen_script
           echo "which MC sample do you want to apply cuts?"
           read opt
           if [ $opt == "DDPI" ]; then
               echo "which BOSS version do you want to simulate?"
               read boss
               if [ $boss -ne "703" ] or [ $boss -ne "705" ]; then
                   echo "Boss version is 703 or 705!"
                   exit -1
               fi
               ./apply_cuts_MC_DDbarPi.sh ${boss} ${opt}
               chmod u+x Apply_Cuts_${opt}_${boss}
               bash Apply_Cuts_${opt}_${boss}
               rm -r Apply_Cuts_${opt}_${boss}
           else
               echo "Please add the MC simulation joboption files!"
           fi
	       ;;

esac

}


case $option in
   
    # --------------------------------------------------------------------------
    #  Data @703 
    # --------------------------------------------------------------------------

    0.1) echo "Running on data sample @703..."
         usage_0_1 
         echo "Please enter your option: " 
         read option  
         sub_0_1 option 
	     ;;

    0.1.*) echo "Running on data sample @703..."
           sub_0_1 option  
           ;;  
        
    # --------------------------------------------------------------------------
    #  Data @705 
    # --------------------------------------------------------------------------

    0.2) echo "Running on data sample @705..."
         usage_0_2 
         echo "Please enter your option: " 
         read option  
         sub_0_2 option 
	     ;;

    0.2.*) echo "Running on data sample @705..."
           sub_0_2 option  
           ;;  

    # --------------------------------------------------------------------------
    #  signal MC samples
    # --------------------------------------------------------------------------

    0.3) echo "Running on MC samples for DDbarPi-ST ..."
         usage_0_3
         echo "Please enter your option: " 
         echo "    DDPI    --> e+e- --> D-D0-barpi+"
         read option  
         sub_0_3 option 
	     ;;

    0.3.*) echo "Running on MC samples for DDbarPi-ST ..."
           sub_0_3 option  
           ;;  

esac
