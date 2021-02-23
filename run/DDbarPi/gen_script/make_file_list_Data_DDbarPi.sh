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
    SOURCES=("/besfs3/offline/data/703-1/xyz/round10/4190/dst/"
    "/besfs3/offline/data/703-1/xyz/round06/4260scan/4190/dst/"
    "/besfs3/offline/data/703-1/xyz/round10/4200/dst/"
    "/besfs3/offline/data/703-1/xyz/round10/4210/dst/"
    "/besfs3/offline/data/703-1/xyz/round06/4260scan/4210/dst/"
    "/besfs3/offline/data/703-1/xyz/round10/4220/dst/"
    "/besfs3/offline/data/703-1/xyz/round06/4260scan/4220/dst/"
    "/besfs3/offline/data/703-1/xyz/round06/4260scan/4230/dst/"
    "/besfs3/offline/data/703-1/xyz/round06/4230/dst/"
    "/besfs3/offline/data/703-1/xyz/round10/4237/dst/"
    "/besfs3/offline/data/703-1/xyz/round06/4260scan/4245/dst/"
    "/besfs3/offline/data/703-1/xyz/round10/4246/dst/"
    "/besfs3/offline/data/703-1/xyz/round06/4260/dst/"
    "/besfs3/offline/data/703-1/xyz/round06/4260/dst/"
    "/besfs3/offline/data/703-1/xyz/round10/4270/dst/"
    "/besfs3/offline/data/703-1/xyz/round10/4280/dst/"
    "/besfs3/offline/data/703-1/xyz/round06/4260scan/4310/dst/"
    "/besfs3/offline/data/703-1/xyz/round06/4360/dst/"
    "/besfs3/offline/data/703-1/xyz/round06/4360scan/4390/dst/"
    "/besfs3/offline/data/703-1/xyz/round06/4360scan/4420/dst/"
    "/besfs3/offline/data/703-1/xyz/round07/4420/dst/"
    "/besfs3/offline/data/703-1/xyz/round07/4470/dst/"
    "/besfs3/offline/data/703-1/xyz/round07/4530/dst/"
    "/besfs3/offline/data/703-1/xyz/round07/4575/dst/"
    "/besfs3/offline/data/703-1/xyz/round07/4600/dst/")
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
    SOURCES=("/besfs4/offline/data/705-1/xyz/round12/4290/dst/"
    "/besfs4/offline/data/705-1/xyz/round12/4315/dst/"
    "/besfs4/offline/data/705-1/xyz/round12/4340/dst/"
    "/besfs4/offline/data/705-1/xyz/round12/4380/dst/"
    "/besfs4/offline/data/705-1/xyz/round12/4400/dst/"
    "/besfs4/offline/data/705-1/xyz/round12/4440/dst/"
    "/besfs4/offline/data/705-1/xyz/round13/4612/dst/"
    "/besfs4/offline/data/705-1/xyz/round13/4620/dst/"
    "/besfs4/offline/data/705-1/xyz/round13/4640/dst/"
    "/besfs4/offline/data/705-1/xyz/round13/4660/dst/"
    "/besfs4/offline/data/705-1/xyz/round13/4680/dst/"
    "/besfs4/offline/data/705-1/xyz/round13/4700/dst/")
fi

FILENAME="Gen_FileList_Data_"$BOSS
echo "#!/usr/bin/env bash" > $FILENAME
echo "cd /besfs5/groups/cal/dedx/$USER/bes/DDbarPi-ST" >> $FILENAME 
COUNT=0
for SAMPLE in ${SAMPLES[@]}; do
    echo "rm -r /besfs5/groups/cal/dedx/$USER/bes/DDbarPi-ST/run/DDbarPi/samples/data/$SAMPLE/*txt" >> $FILENAME
    echo "./python/get_samples.py ${SOURCES[$COUNT]} ./run/DDbarPi/samples/data/$SAMPLE/data_${SAMPLE}_DDbarPi.txt 20G" >> $FILENAME
    COUNT=$COUNT+1
done
