#/bin/bash

BOSS=$1

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

for SAMPLE in ${SAMPLES[@]}; do
    cd /besfs5/groups/cal/dedx/$USER/bes/DDbarPi-ST/run/DDbarPi/rootfile/data/$SAMPLE
    rm -rf DDbarPi_data_${SAMPLE}-0.root
    rm -rf DDbarPi_data_${SAMPLE}.root
    hadd DDbarPi_data_${SAMPLE}.root *.root
    cd ..
    shortbar1="-1"
    shortbar2="-2"
    if [[ $SAMPLE == *$shortbar1* ]]; then
        dir=$(echo $SAMPLE | sed 's/-1//g')
        mkdir -p $dir
        mv /besfs5/groups/cal/dedx/$USER/bes/DDbarPi-ST/run/DDbarPi/rootfile/data/$SAMPLE/DDbarPi_data_$SAMPLE\.root ./$dir
    elif [[ $SAMPLE == *$shortbar2* ]]; then
        dir=$(echo $SAMPLE | sed 's/-2//g')
        mkdir -p $dir
        mv /besfs5/groups/cal/dedx/$USER/bes/DDbarPi-ST/run/DDbarPi/rootfile/data/$SAMPLE/DDbarPi_data_$SAMPLE\.root ./$dir
        cd $dir
        rm -rf DDbarPi_data_$dir\.root
        hadd DDbarPi_data_$dir\.root DDbarPi_data_$dir-1.root DDbarPi_data_$dir-2.root
    else
        echo "No need to change for $SAMPLE"
    fi
done
