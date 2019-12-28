FROM alpine

LABEL maintainer="bfablet@gmail.com"

RUN apk update ; apk upgrade

# install some tools
#RUN apk add --no-cache vim bash tree wget curl git git-lfs openssh-client openssl rsync dos2unix terraform perl ruby

# set CET timezone
RUN apk add --no-cache tzdata ; cp -vf /usr/share/zoneinfo/CET /etc/localtime ; echo CET > /etc/timezone ; date ; apk del tzdata

#install install minimal tools
RUN apk add --no-cache zsh vim dos2unix tree wget curl git openssh

# install oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# set some custom env
ADD .alias /root/
#ADD .promptrc /root/
ADD .vimrc /root/

RUN unalias -a ;\
    echo ". /root/.alias"    >> /root/.zshrc ;\
#    echo ". .promptrc" >> /root/.bashrc ;\
    chmod 700 /root/.alias    ;\
#    chmod 700 /root/.promptrc ;\
    chmod 700 /root/.vimrc    ;\
    chmod 700 /root/.zshrc


ENTRYPOINT ["/bin/zsh"]
WORKDIR /root
