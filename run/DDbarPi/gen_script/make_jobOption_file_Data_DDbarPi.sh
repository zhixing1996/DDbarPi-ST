#!/bin/bash

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
for SAMPLE in ${SAMPLES[@]}; do
    NUM_UP=$(ls -l /besfs5/groups/cal/dedx/$USER/bes/DDbarPi-ST/run/DDbarPi/samples/data/$SAMPLE | grep "txt" | wc -l)
    JobText_SaveDir=/besfs5/groups/cal/dedx/$USER/bes/DDbarPi-ST/run/DDbarPi/jobs_text/data/$SAMPLE
    ROOT_SaveDir=/besfs5/groups/cal/dedx/$USER/bes/DDbarPi-ST/run/DDbarPi/rootfile/data/$SAMPLE
    mkdir -p $JobText_SaveDir
    mkdir -p $ROOT_SaveDir
    rm -r $JobText_SaveDir/*txt
    rm -r $ROOT_SaveDir/*.root
    
    for ((num = 0; num <= $NUM_UP; num++))
    do
        file_list=data_${SAMPLE}_DDbarPi_20G-${num}.txt
        rootfile=DDbarPi_data_$SAMPLE-${num}.root
        jobOptions=jobOptions_DDbarPi_data_$SAMPLE-${num}.txt
        echo "#include \"\$ROOTIOROOT/share/jobOptions_ReadRec.txt\"                                        "  > ${JobText_SaveDir}/${jobOptions}
        echo "#include \"\$MAGNETICFIELDROOT/share/MagneticField.txt\"                                      " >> ${JobText_SaveDir}/${jobOptions}
        echo "#include \"\$DTAGALGROOT/share/jobOptions_dTag.txt\"                                          " >> ${JobText_SaveDir}/${jobOptions}
        echo "#include \"\$DDECAYALGROOT/share/jobOptions_DDecay.txt\"                                      " >> ${JobText_SaveDir}/${jobOptions}
        if [ "$BOSS" = "705" ]; then
            echo "#include \"\$MEASUREDECMSSVCROOT/share/anaOptions.txt\"                                   " >> ${JobText_SaveDir}/${jobOptions}
        fi
        echo "#include \"/besfs5/groups/cal/dedx/\$USER/bes/DDbarPi-ST/run/DDbarPi/samples/data/$SAMPLE/$file_list\" " >> ${JobText_SaveDir}/${jobOptions}
        echo "                                                                                              " >> ${JobText_SaveDir}/${jobOptions}
        echo "DDecay.Ecms = ${ECMS[$COUNT]};                                                                " >> ${JobText_SaveDir}/${jobOptions}
        echo "                                                                                              " >> ${JobText_SaveDir}/${jobOptions}
        echo "// Set output level threshold (2=DEBUG, 3=INFO, 4=WARNING, 5=ERROR, 6=FATAL )                 " >> ${JobText_SaveDir}/${jobOptions}
        echo "MessageSvc.OutputLevel = 6;                                                                   " >> ${JobText_SaveDir}/${jobOptions}
        echo "                                                                                              " >> ${JobText_SaveDir}/${jobOptions}
        echo "// Number of events to be processed (default is 10)                                           " >> ${JobText_SaveDir}/${jobOptions}
        echo "ApplicationMgr.EvtMax = -1;                                                                   " >> ${JobText_SaveDir}/${jobOptions}
        echo "                                                                                              " >> ${JobText_SaveDir}/${jobOptions}
        echo "ApplicationMgr.HistogramPersistency = \"ROOT\";                                               " >> ${JobText_SaveDir}/${jobOptions}
        echo "NTupleSvc.Output = {\"FILE1 DATAFILE='$ROOT_SaveDir/$rootfile' OPT='NEW' TYP='ROOT'\"};       " >> ${JobText_SaveDir}/${jobOptions}
    done
    COUNT=$COUNT+1
done
