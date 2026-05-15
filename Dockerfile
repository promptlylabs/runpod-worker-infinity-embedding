FROM nvidia/cuda:12.4.1-cudnn-runtime-ubuntu22.04 AS base

ENV HF_HOME=/runpod-volume

# install python 3.11 stable from deadsnakes PPA (ubuntu 22.04 only ships python3.11.0rc1
# which breaks torch >=2.4 because sys.get_int_max_str_digits was added in 3.11.0 final)
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC
RUN apt-get update && apt-get install -y software-properties-common \
    && add-apt-repository -y ppa:deadsnakes/ppa \
    && apt-get update && apt-get install -y \
    python3.11 \
    python3.11-dev \
    python3.11-distutils \
    git \
    wget \
    libgl1 \
    && ln -sf /usr/bin/python3.11 /usr/bin/python \
    && ln -sf /usr/bin/python3.11 /usr/bin/python3
RUN wget https://bootstrap.pypa.io/get-pip.py && python get-pip.py && rm get-pip.py

# install uv
RUN pip install uv

# install python dependencies
COPY requirements.txt /requirements.txt
RUN uv pip install -r /requirements.txt --system

# install torch
RUN pip install torch==2.6.0+cu124 --index-url https://download.pytorch.org/whl/cu124 --no-cache-dir

# Add src files
ADD src .

# Add test input
COPY test_input.json /test_input.json

# start the handler
CMD python -u /handler.py
