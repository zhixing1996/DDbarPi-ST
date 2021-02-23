#/bin/bash

BOSS=$1
TYPE=$2
PATH=/besfs5/groups/cal/dedx/$USER/bes/DDbarPi-ST/run/DDbarPi/anaroot/mc/$2

if [ "$BOSS" = "703" ]; then
    SAMPLES=("4190"
    "4200"
    "4210"
    "4220"
    "4230"
    "4237"
    "4245"
    "4246"
    "4260"
    "4270"
    "4280"
    "4310"
    "4360"
    "4390"
    "4420"
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

FILENAME="Apply_Cuts_${TYPE}_"$BOSS
echo "#!/usr/bin/env bash" > $FILENAME
echo "cd /besfs5/groups/cal/dedx/$USER/bes/DDbarPi-ST/python" >> $FILENAME 
for SAMPLE in ${SAMPLES[@]}; do
    echo "./apply_cuts.py $PATH/$SAMPLE/mc_${TYPE}_${SAMPLE}.root $PATH/$SAMPLE/mc_${TYPE}_${SAMPLE}_DDbarPi_after.root" >> $FILENAME
done
