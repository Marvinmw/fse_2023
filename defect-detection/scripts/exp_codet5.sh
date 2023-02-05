#!/bin/bash

low=1
hgh=1000
# MODEL_TYPE=codet5
# TOKENIZER=Salesforce/codet5-base
# MODEL_PATH=Salesforce/codet5-base

for i in $(seq 3)
do
rand=$((low + RANDOM%(1+hgh-low)))
bash run_org.sh  codet5 codet5 $i  $rand Salesforce
bash run_mix.sh  codet5 codet5 $i  $rand Salesforce
bash run_ddg_cdg.sh codet5 codet5 $i $rand Salesforce
bash run_dg.sh  codet5 codet5 $i  $rand Salesforce
bash run_org_oversample_1.sh  codet5 codet5 $i  $rand Salesforce
bash run_org_oversample_2.sh  codet5 codet5 $i  $rand Salesforce
done
