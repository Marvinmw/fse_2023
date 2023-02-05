#!/bin/bash -l
#SBATCH -c 4
#SBATCH -N 1
#SBATCH -p gpu
#SBATCH -G 1
#SBATCH --time=2-00:00:00
#SBATCH --qos=normal
#SBATCH -J org
#SBATCH --mail-type=end,fail
#SBATCH --mail-user=wei.ma@uni.lu
#SBATCH -o %x-%j.log
#SBATCH -C volta32
conda activate codebert
cd ../
model_name=$1
model_type=$2 # roberta
repeat=$3
seed=$4
company=$5
mkdir -p ./$model_name/$repeat/org_saved_models
echo $seed > ./$model_name/$repeat/org_saved_models/seed.txt

python run.py \
    --output_dir=./$model_name/$repeat/org_saved_models \
    --model_type=$model_type \
    --tokenizer_name=$company/$model_name-base \
    --model_name_or_path=$company/$model_name-base \
    --do_train \
    --do_test \
    --do_eval \
    --train_data_file=../datasets/devigin/train.jsonl \
    --eval_data_file=../datasets/devigin/valid.jsonl \
    --test_data_file=../datasets/devigin/test.jsonl \
    --epoch 5 \
    --block_size 400 \
    --train_batch_size 32 \
    --eval_batch_size 64 \
    --learning_rate 2e-5 \
    --max_grad_norm 1.0 \
    --evaluate_during_training \
    --seed $seed  2>&1 | tee ./$model_name/$repeat/org_saved_models/train_org.log

cd -