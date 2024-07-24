#!/usr/bin/env bash

export PYTHONPATH=.

python3 -W ignore llava/eval/run_vila.py \
    --model-path Efficient-Large-Model/Llama-3-VILA1.5-8b-AWQ \
    --conv-mode llama_3 \
    --query "<image>\n Please describe the traffic condition." \
    --image-file "demo_images/av.png"

#python3 -W ignore llava/eval/run_vila.py \
#    --model-path Efficient-Large-Model/VILA1.5-40b-AWQ \
#    --conv-mode hermes-2 \
#    --query "<image>\n Please describe the traffic condition." \
#    --image-file "demo_images/av.png"


