FROM alpine

LABEL maintainer="bfablet@gmail.com"

RUN apk update ; apk upgrade

# install some tools
#RUN apk add --no-cache vim bash tree wget curl git git-lfs openssh-client openssl rsync dos2unix terraform perl ruby

# set CET timezone
RUN apk add --no-cache tzdata ; cp -vf /usr/share/zoneinfo/CET /etc/localtime ; echo CET > /etc/timezone ; date ; apk del tzdata

#install install minimal tools
RUN apk add --no-cache zsh vim dos2unix tree wget curl git openssh

# install zim
RUN cd /root/ ; git clone --recursive https://github.com/zimfw/zimfw.git ${ZDOTDIR:-${HOME}}/.zim
ADD install-zim.sh /root/
RUN chmod 755 /root/install-zim.sh ; cd /root ; /bin/zsh /root/install-zim.sh ; rm -f /root/.zim/modules/prompt/themes/steeef.zsh-theme
ADD steeef.zsh-theme /root/.zim/modules/prompt/themes/

# install tmux
RUN apk add --no-cache tmux xclip
RUN cd  root ; mkdir -p .tmux/plugins
RUN cd /root/.tmux/plugins ; git clone https://github.com/tmux-plugins/tpm.git
RUN cd /root/.tmux/plugins ; git clone https://github.com/tmux-plugins/tmux-sensible.git
RUN cd /root/.tmux/plugins ; git clone https://github.com/tmux-plugins/tmux-resurrect.git
ADD .tmux.conf /root/
RUN chmod 700 /root/.tmux.conf ; tmux source /root/.tmux.conf >& /dev/null | true
#RUN tmux source /root/.tmux.conf

# set some custom env
ADD .alias /root/
#ADD .promptrc /root/
ADD .vimrc /root/
ADD .inputrc /root/

RUN unalias -a ;\
#    echo ". .promptrc" >> /root/.bashrc ;\
    chmod 700 /root/.alias    ;\
    chmod 700 /root/.vimrc    ;\
    chmod 700 /root/.inputrc  ;\
    echo "source /root/.alias" >> /root/.zshrc

ENV TERM=xterm-256color

ENTRYPOINT ["/bin/zsh"]
WORKDIR /root
