FROM ubuntu

RUN apt-get update &&  \
    apt-get dist-upgrade -yy &&  \
    apt-get install -yy build-essential cmake pipewire-jack libreadline-dev liblilv-dev  libjack-jackd2-dev python3 libfftw3-dev libpipewire-0.3-dev

WORKDIR /apps

