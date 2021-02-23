#/bin/bash

BOSS=$1

SOURCE_PATH=/besfs5/groups/cal/dedx/$USER/bes/DDbarPi-ST/run/DDbarPi/rootfile/data
ANA_PATH=/besfs5/groups/cal/dedx/$USER/bes/DDbarPi-ST/run/DDbarPi/anaroot/data
LOG_PATH=/besfs5/groups/cal/dedx/$USER/bes/DDbarPi-ST/run/DDbarPi/logfile
mkdir -p $ANA_PATH
mkdir -p $LOG_PATH
if [ "$BOSS" = "703" ]; then
    SAMPLES=("4190-1"
    "4190-2"
    "4200"
    "4210-1"
    "4210-2"
    "4220-1"
    "4220-2"
    "4230-1"
    "4230-2"
    "4237"
    "4245"
    "4246"
    "4260-1"
    "4260-2"
    "4270"
    "4280"
    "4310"
    "4360"
    "4390"
    "4420-1"
    "4420-2"
    "4470"
    "4530"
    "4575"
    "4600")
    ECMS=("4.1888"
    "4.1886"
    "4.1989"
    "4.2092"
    "4.2077"
    "4.2187"
    "4.2171"
    "4.2263"
    "4.2263"
    "4.2357"
    "4.2417"
    "4.2438"
    "4.25797"
    "4.25797"
    "4.2668"
    "4.2777"
    "4.3079"
    "4.35826"
    "4.3874"
    "4.41558"
    "4.41558"
    "4.4671"
    "4.5271"
    "4.57450"
    "4.59953")
fi

if [ "$BOSS" = "705" ]; then
    SAMPLES=("4290"
    "4315"
    "4340"
    "4380"
    "4400"
    "4440"
    "4610"
    "4620"
    "4640"
    "4660"
    "4680"
    "4700")
    ECMS=("4.28788"
    "4.31205"
    "4.33739"
    "4.37737"
    "4.39645"
    "4.43624"
    "4.61208"
    "4.63129"
    "4.64366"
    "4.66414"
    "4.68271"
    "4.70044")
fi

COUNT=0
FILENAME="Get_Info_Data_"$BOSS
echo "#!/usr/bin/env bash" > $FILENAME
echo "cd /besfs5/groups/cal/dedx/$USER/bes/DDbarPi-ST" >> $FILENAME 
for SAMPLE in ${SAMPLES[@]}; do
    shortbar1="-1"
    shortbar2="-2"
    if [[ $SAMPLE == *$shortbar1* ]]; then
        SAMPLE=$(echo $SAMPLE | sed 's/-1//g')
    fi
    if [[ $SAMPLE == *$shortbar2* ]]; then
        COUNT=$COUNT+1
        continue
    fi
    mkdir -p $ANA_PATH/$SAMPLE
    echo "./python/get_info.py $SOURCE_PATH/$SAMPLE/DDbarPi_data_${SAMPLE}.root $ANA_PATH/$SAMPLE/data_${SAMPLE}.root ${ECMS[$COUNT]}" >> $FILENAME
    COUNT=$COUNT+1
done
