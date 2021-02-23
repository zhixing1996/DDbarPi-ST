#/bin/bash

BOSS=$1
PATH=/besfs5/groups/cal/dedx/$USER/bes/DDbarPi-ST/run/DDbarPi/anaroot/data

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
fi

FILENAME="Apply_Cuts_Data_"$BOSS
echo "#!/usr/bin/env bash" > $FILENAME
echo "cd /besfs5/groups/cal/dedx/$USER/bes/DDbarPi-ST/python" >> $FILENAME 
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
    echo "./apply_cuts.py $PATH/$SAMPLE/data_${SAMPLE}.root $PATH/$SAMPLE/data_${SAMPLE}_after.root" >> $FILENAME
done
