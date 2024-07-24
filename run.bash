#!/usr/bin/env bash

docker run \
    --gpus all \
    --rm \
    -ti \
    -v $PWD:/code \
    -v $PWD/../huggingface:/root/.cache/huggingface \
    vila
    bash
