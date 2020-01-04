FROM ubuntu:18.04

# aptの初期化
RUN apt update -y && apt upgrade -y

# stack install
RUN apt install curl -y && curl -sSL https://get.haskellstack.org/ | sh

# stack path
ENV PATH ~/.local/bin:$PATH
ENV PATH $(stack path --local-bin):$PATH
ENV PATH $(stack path --compiler-bin):$PATH

RUN stack setup

# hie dependencies
RUN apt install -y libicu-dev libtinfo-dev libgmp-dev zlib1g-dev

# install haskell-ide-engine
RUN git clone https://github.com/haskell/haskell-ide-engine --recurse-submodules
RUN cd /haskell-ide-engine && stack ./install.hs stack-hie-8.6.5
RUN cd /haskell-ide-engine && stack ./install.hs build-data

# haskell-ide-engine path
RUN echo PATH=~/.local/bin:$PATH >> /root/.bashrc && \
    echo PATH=$(stack path --local-bin):$PATH >> /root/.bashrc && \
    echo PATH=$(stack path --compiler-bin):$PATH >> /root/.bashrc

# install stylish-haskell
RUN apt install -y stylish-haskell
