#!/bin/bash

low=1
hgh=1000

for i in $(seq 3)
do
rand=$((low + RANDOM%(1+hgh-low)))
bash run_ddg_cdg.sh codebert roberta $i $rand microsoft
bash run_dg.sh  codebert roberta $i  $rand microsoft
bash run_mix.sh  codebert roberta $i  $rand microsoft
bash run_org_oversample_1.sh  codebert roberta $i  $rand microsoft
bash run_org_oversample_2.sh  codebert roberta $i  $rand microsoft
bash run_org.sh  codebert roberta $i  $rand microsoft
done
