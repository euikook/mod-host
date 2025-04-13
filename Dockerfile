FROM debian:bookworm

RUN apt-get update -y &&  \
    apt-get install -yy build-essential cmake pipewire-jack libreadline-dev liblilv-dev  libjack-jackd2-dev python3 libfftw3-dev libpipewire-0.3-dev

WORKDIR /apps

RUN groupadd -g 1000 user
RUN useradd -r -u 1000  -g 1000 -s /bin/bash user
RUN chown -R user:user /apps
USER user
