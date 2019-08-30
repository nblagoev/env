FROM alpine:latest

RUN apk update && apk upgrade && apk add \
    bash curl git sudo
RUN echo "%root ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/root

WORKDIR /root

COPY . .

RUN ./linux

CMD ["/bin/zsh"]
