#/bin/bash
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
    RUNNO_LOW=("47543"
    "48172"
    "48714"
    "49270"
    "30438"
    "49788"
    "32141"
    "50255"
    "29677"
    "50796"
    "51303"
    "30492"
    "30616"
    "31281"
    "31327"
    "36245"
    "36398"
    "36603"
    "35227")
    RUNNO_UP=("48170"
    "48713"
    "49239"
    "49787"
    "30491"
    "50254"
    "32226"
    "50793"
    "30367"
    "51302"
    "51498"
    "30557"
    "31279"
    "31325"
    "31390"
    "36393"
    "36588"
    "36699"
    "36213")
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
    RUNNO_LOW=("59902"
    "60364"
    "60808"
    "61249"
    "61763"
    "62286"
    "64314"
    "63075"
    "63516"
    "63718"
    "63867"
    "64028")
    RUNNO_UP=("60363"
    "60805"
    "61242"
    "61762"
    "62285"
    "62823"
    "64360"
    "63515"
    "63715"
    "63852"
    "64015"
    "64313")
fi

COUN=0
FILENAME="Sub_jobOption_"$BOSS
for SAMPLE in ${SAMPLES[@]}; do
    JobText_SaveDir=/besfs5/groups/cal/dedx/$USER/bes/DDbarPi-ST/run/DDbarPi/jobs_text/mc/DDPI/$SAMPLE
    Script_Dir=/besfs5/groups/cal/dedx/$USER/bes/DDbarPi-ST/run/DDbarPi/gen_script/gen_mc/DDPI
    mkdir -p $JobText_SaveDir
    rm -rf $JobText_SaveDir/jobOptions*txt
    rm -rf $JobText_SaveDir/subSimRec_*.sh
    rm -rf $JobText_SaveDir/fort.*
    rm -rf $JobText_SaveDir/phokhara*
    cd $JobText_SaveDir
    cp -r $Script_Dir/jobOptions_sim_sig_D_D_PI_PHSP_tempE.sh jobOptions_sim_sig_D_D_PI_PHSP_${SAMPLE}.sh
    cp -r $Script_Dir/jobOptions_rec_sig_D_D_PI_PHSP_tempE.sh jobOptions_rec_sig_D_D_PI_PHSP_${SAMPLE}.sh
    cp -r $Script_Dir/xs_user.dat .
    threshold=4.0205
    sh jobOptions_sim_sig_D_D_PI_PHSP_${SAMPLE}.sh 0 19 $SAMPLE ${ECMS[$COUNT]} 5000 $threshold ${RUNNO_LOW[$COUNT]} ${RUNNO_UP[$COUNT]} ${BOSS}
    sh jobOptions_rec_sig_D_D_PI_PHSP_${SAMPLE}.sh 0 19 $SAMPLE
    rm -rf /besfs5/groups/cal/dedx/$USER/bes/DDbarPi-ST/run/DDbarPi/rtraw/DDPI/$SAMPLE/*.rtraw
    rm -rf /besfs5/groups/cal/dedx/$USER/bes/DDbarPi-ST/run/DDbarPi/dst/DDPI/$SAMPLE/*.dst
    cp -rf /besfs5/groups/cal/dedx/$USER/bes/DDbarPi-ST/run/DDbarPi/gen_script/gen_mc/subSimRec.sh ./
    sh subSimRec.sh jobOptions_sim_sig_D_D_PI_PHSP_$SAMPLE jobOptions_rec_sig_D_D_PI_PHSP_$SAMPLE subSimRec_D_D_PI_$SAMPLE 0 19
    COUNT=$((${COUNT}+1))
done
