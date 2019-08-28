FROM alpine:latest

RUN apk update && apk upgrade && apk add \
    bash curl git sudo
RUN echo "%root ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/root

RUN adduser -DG root self

WORKDIR /home/self

USER self

RUN curl -fsSL https://raw.githubusercontent.com/nblagoev/env/master/.install/linux | sh

CMD ["/bin/zsh"]
