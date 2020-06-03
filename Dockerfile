FROM ubuntu

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y wget zsh git snapd curl apt-transport-https ca-certificates gnupg
RUN systemctl enable snapd.service
RUN wget https://github.com/tsl0922/ttyd/releases/download/1.6.0/ttyd_linux.x86_64 -O /usr/bin/ttyd && chmod +x /usr/bin/ttyd
# nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
# google-cloud-sdk
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
RUN apt-get update && apt-get install -y google-cloud-sdk kubectl

WORKDIR /root

RUN git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

RUN chsh -s /bin/zsh && /bin/zsh -c "setopt EXTENDED_GLOB"
RUN ln -s "${ZDOTDIR:-$HOME}/.zprezto/runcoms/zlogin" "${ZDOTDIR:-$HOME}/.zlogin" && \
    ln -s "${ZDOTDIR:-$HOME}/.zprezto/runcoms/zlogout" "${ZDOTDIR:-$HOME}/.zlogout" && \
    ln -s "${ZDOTDIR:-$HOME}/.zprezto/runcoms/zpreztorc" "${ZDOTDIR:-$HOME}/.zpreztorc" && \
    ln -s "${ZDOTDIR:-$HOME}/.zprezto/runcoms/zprofile" "${ZDOTDIR:-$HOME}/.zprofile" && \
    ln -s "${ZDOTDIR:-$HOME}/.zprezto/runcoms/zshenv" "${ZDOTDIR:-$HOME}/.zshenv" && \
    ln -s "${ZDOTDIR:-$HOME}/.zprezto/runcoms/zshrc" "${ZDOTDIR:-$HOME}/.zshrc"
COPY zsh/* /root/
COPY zsh/.zpreztorc /root/
RUN /bin/zsh -c "source ~/.zshrc && nvm install 12"

CMD ttyd zsh