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
RUN cd /root ; mkdir -p .zsh/themes ; cd /root/.zsh/themes ; git clone https://github.com/sindresorhus/pure.git pure
RUN ln -s /root/.zsh/themes/pure/pure.zsh /root/.oh-my-zsh/themes/pure.zsh-theme ; ln -s /root/.zsh/themes/pure/async.zsh /root/.oh-my-zsh/custom/async.zsh

# install tmux
RUN apk add --no-cache tmux
RUN cd  root ; mkdir -p .tmux/plugins
RUN cd /root/.tmux/plugins ; git clone https://github.com/tmux-plugins/tpm.git
RUN cd /root/.tmux/plugins ; git clone https://github.com/tmux-plugins/tmux-sensible.git
RUN cd /root/.tmux/plugins ; git clone https://github.com/tmux-plugins/tmux-resurrect.git
ADD .tmux.conf /root/
RUN chmod 700 /root/.tmux.conf ; tmux source /root/.tmux.conf >& /dev/null | true
#RUN tmux source /root/.tmux.conf

# set some custom env
ADD .zshrc /root/
ADD .alias /root/
#ADD .promptrc /root/
ADD .vimrc /root/
ADD .inputrc /root/

RUN unalias -a ;\
#    echo ". .promptrc" >> /root/.bashrc ;\
    chmod 700 /root/.zshrc    ;\
    chmod 700 /root/.alias    ;\
#    chmod 700 /root/.promptrc ;\
    chmod 700 /root/.vimrc    ;\
    chmod 700 /root/.inputrc  ;\
    chmod 700 /root/.zshrc



ENTRYPOINT ["/bin/zsh"]
WORKDIR /root
