#FROM nvidia/cuda:11.8.0-devel-ubuntu22.04
FROM pytorch/pytorch:2.3.1-cuda11.8-cudnn8-devel

RUN apt-get update
RUN apt-get -y install python3-pip
RUN apt-get -y install wget

RUN pip install --upgrade pip  # enable PEP 660 support
#RUN wget https://github.com/Dao-AILab/flash-attention/releases/download/v2.4.2/flash_attn-2.4.2+cu118torch2.0cxx11abiFALSE-cp310-cp310-linux_x86_64.whl
#RUN wget https://github.com/Dao-AILab/flash-attention/releases/download/v2.6.2/flash_attn-2.6.2+cu118torch2.0cxx11abiFALSE-cp310-cp310-linux_x86_64.whl
#RUN pip install flash_attn-2.4.2+cu118torch2.0cxx11abiFALSE-cp310-cp310-linux_x86_64.whl

RUN apt-get install -y git

ENV FLASH_ATTENTION_FORCE_BUILD=1
ENV FLASH_ATTENTION_FORCE_CXX11_ABI=1

RUN mkdir -p /build/flash_attention && cd /build/flash_attention \
  && git clone https://github.com/Dao-AILab/flash-attention -b v2.4.2 .

RUN cd /build/flash_attention \
  && python3 setup.py build -j 20 bdist_wheel

#RUN wget https://download.pytorch.org/whl/nightly/cu121/torch-2.2.0.dev20231010%2Bcu121-cp39-cp39-linux_x86_64.whl
#RUN ls "torch-2.2.0.dev20231010+cu121-cp39-cp39-linux_x86_64.whl"
#RUN pip install "torch-2.2.0.dev20231010+cu121-cp39-cp39-linux_x86_64.whl"

# Has no positive effect:
#RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
#RUN bash Miniconda3-latest-Linux-x86_64.sh -b
#RUN /root/miniconda3/bin/conda install -c nvidia cuda-toolkit -y

# Manually installing packages one by one for sake of debugging (pyproject.toml should be used):
#RUN pip install "torch>=2.0.1" 
#RUN pip install "torchvision>=0.15.2"
RUN pip install "transformers>=4.36.2" 
RUN pip install "tokenizers>=0.15.2"
RUN pip install "sentencepiece>=0.1.99"
RUN pip install "shortuuid"
RUN pip install "accelerate>=0.27.2"
RUN pip install "peft>=0.5.0"
RUN pip install "bitsandbytes>=0.41.0"
RUN pip install "pydantic<2,>=1"
RUN pip install "markdown2[all]" 
RUN pip install "numpy"
RUN pip install "scikit-learn>=1.2.2"
RUN pip install "gradio==3.35.2"
RUN pip install "gradio_client==0.2.9"
RUN pip install "requests"
RUN pip install "httpx>=0.24.0"
RUN pip install "uvicorn"
RUN pip install "fastapi"
RUN pip install "einops>=0.6.1"
RUN pip install "einops-exts>=0.0.4"
RUN pip install "timm>=0.9.12"
RUN pip install "openpyxl>=3.1.2"
RUN pip install "pytorchvideo>=0.1.5"
RUN pip install "decord>=0.6.0"
RUN pip install "datasets>=2.16.1"
RUN pip install "openai>=1.8.0"
RUN pip install "webdataset>=0.2.86"
RUN pip install "nltk>=3.3"
RUN pip install "pywsd>=1.2.4"
RUN pip install "opencv-python>=4.8.0.74"

RUN pip install "s2wrapper@git+https://github.com/bfshi/scaling_on_scales"

# Doesn't work, seems to take 1.5h and then crashes with unknown subprocess error:
#COPY pyproject.toml .
#RUN MAKEFLAGS="-j$(nproc)" pip install -vvv -e .
#RUN pip install -vvv -e ".[train]"

RUN pip install git+https://github.com/huggingface/transformers@v4.36.2

RUN pip install /build/flash_attention/dist/flash_attn-2.4.2-cp310-cp310-linux_x86_64.whl

# TODO: Seems kind-of dirty, fix? 
# RUN site_pkg_path=$(python3 -c 'import site; print(site.getsitepackages()[0])')
#RUN python3 -c 'import site; print(site.getsitepackages()[0])'
#COPY ./llava/train/transformers_replace/* $(python3 -c 'import site; print(site.getsitepackages()[0])')/transformers/
COPY ./llava/train/transformers_replace/models /usr/local/lib/python3.10/dist-packages/models


WORKDIR /code
