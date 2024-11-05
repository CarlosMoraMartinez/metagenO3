FROM continuumio/miniconda3

## GANON -> doesnt work fine
# https://pirovc.github.io/ganon/#installation-from-source

SHELL ["/bin/bash", "-c"]

RUN apt update \
    && apt-get -y install build-essential \
    && apt-get -y install checkinstall zlib1g-dev zlib1g bzip2 libssl-dev gcc g++ git cmake

RUN  conda config --add channels bioconda \
    && conda config --add channels conda-forge \
    && conda config --set channel_priority strict

RUN pip3 install --no-input "pandas>=1.2.0" "multitax>=1.3.1" \
    && conda install -y -c conda-forge "genome_updater>=0.6.3" \
    && conda install -y conda-forge::parallel

RUN conda install -y bioconda::raptor


RUN mkdir /software
WORKDIR /software
RUN git clone --recurse-submodules https://github.com/pirovc/ganon.git

WORKDIR /software/ganon
RUN python3 setup.py install --record files.txt

RUN mkdir -p build
#WORKDIR /software/ganon/build
RUN apt-get -y install g++ make
RUN cmake -DCMAKE_BUILD_TYPE=Release -DVERBOSE_CONFIG=ON -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCONDA=ON -DLONGREADS=OFF -DCMAKE_INSTALL_PREFIX=/opt/conda/ \
    && make -j 4 \
    && make install

## run tests
#python3 -m pip install "parameterized>=0.9.0" # Alternative: conda install -c conda-forge "parameterized>=0.9.0"
#python3 -m unittest discover -s /software/ganon/integration/
#python3 -m unittest discover -s /software/ganon/integration_online/  # optional - downloads large files
#cd build/
#ctest -VV .

WORKDIR /software
RUN rm -rf ganon

