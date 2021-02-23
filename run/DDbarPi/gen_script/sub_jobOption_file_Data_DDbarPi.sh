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
    cd /besfs5/groups/cal/dedx/$USER/bes/DDbarPi-ST/run/DDbarPi/jobs_text/data/$SAMPLE
    find . -name "*.bosslog" | xargs rm
    find . -name "*.bosserr" | xargs rm
    NUM_UP=$(ls -l | grep "txt" | wc -l)
    boss.condor -g physics -n $NUM_UP jobOptions_DDbarPi_data_$SAMPLE-%{ProcId}.txt
done
