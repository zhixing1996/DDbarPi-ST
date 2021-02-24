#!/bin/sh
BOSS=$1
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
    ECMS=("4.1888"
    "4.1989"
    "4.2092"
    "4.2187"
    "4.2263"
    "4.2357"
    "4.2417"
    "4.2438"
    "4.25797"
    "4.2668"
    "4.2777"
    "4.3079"
    "4.35826"
    "4.3874"
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

WORKAREA=/besfs5/groups/cal/dedx/$USER/bes/DDbarPi-ST
COUNT=0
for SAMPLE in ${SAMPLES[@]}; do
    mkdir -p $WORKAREA/run/DDbarPi/rootfile/mc/DDPI/$SAMPLE
    mkdir -p $WORKAREA/run/DDbarPi/jobs_text/mc/DDPI/$SAMPLE
    cd $WORKAREA/run/DDbarPi/jobs_text/mc/DDPI/$SAMPLE
    rm -rf mc_D_D_PI_PHSP_$SAMPLE*txt
    cp -rf $WORKAREA/python/make_mc.py ./
    cp -rf $WORKAREA/python/tools.py ./
    ./make_mc.py /besfs5/groups/cal/dedx/$USER/bes/DDbarPi-ST/run/DDbarPi/dst/mc/DDPI/$SAMPLE mc D_D_PI PHSP DDPI ${ECMS[$COUNT]} $SAMPLE 2
    cp -rf /besfs5/groups/cal/dedx/$USER/bes/DDbarPi-ST/run/DDbarPi/gen_script/gen_mc/subAna.sh ./
    rm -rf *boss*
    rm -rf $WORKAREA/run/DDbarPi/rootfile/mc/DDPI/$SAMPLE/*root
    ./subAna.sh $SAMPLE D_D_PI_PHSP
    COUNT=$COUNT+1
done
