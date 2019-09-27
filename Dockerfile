# syntax = docker/dockerfile:experimental
# MAINTAINER Katsumi WATANABE docker@xenon11.sakura.ne.jp

FROM kaz3w/pyenv:latest

ARG http_proxy
ARG https_proxy
ARG apt_proxy
ARG git_proxy
ARG username

ENV HTTP_PROXY=${http_proxy}
ENV HTTPS_PROXY=${http_proxy}

ENV DATASET_PATH '/data/data/cut/train/'
# 20190919 ENV CUDA_VISIBLE_DEVICES ''
ENV DEBIAN_FRONTEND=noninteractive


# END TO END LIPREADING
RUN git clone https://github.com/mpc001/end-to-end-lipreading.git -c http.proxy=${GIT_PROXY}
WORKDIR /end-to-end-lipreading


ENV USER=${username}
ENV HOME /home/${USER}
ENV SHELL '/bin/bash'

RUN useradd -m $USER
RUN gpasswd -a $USER sudo 


RUN chown -R ${USER}:${USER} ${HOME}

WORKDIR ${HOME}
COPY scripts/clone_cut_recog.sh .
RUN chmod +x clone_cut_recog.sh
USER ${USER}
RUN sed -i -e 's/#force_color_prompt=/force_color_prompt=/' .bashrc
RUN sed -i -e 's/\\\[\\033\[01;32m\\\]\\u@\\h/\\\[\\033\[01;36m\\\]\\u@\\h/g' .bashrc


WORKDIR ${HOME}/git_work
CMD ["git clone git@10.78.88.73:~/git/cut_recog.git"]

ENTRYPOINT tail -f /dev/null
CMD ["bash"]
