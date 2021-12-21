FROM ubuntu:18.04

RUN apt-get update && apt-get -y install python-pip \
  && pip install --upgrade pip
  
RUN pip install awscli
RUN apt-get install tcsh
RUN apt-get install bc
  
ADD fetch_and_run_mod.sh /usr/bin/fetch_and_run_mod.sh
ADD bashrc /usr/bin/nitrc_bashrc.sh
ADD profile /usr/bin/nitrc_profile.sh

ENTRYPOINT ["/usr/bin/fetch_and_run_mod.sh"]