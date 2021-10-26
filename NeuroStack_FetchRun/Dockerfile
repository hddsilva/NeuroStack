FROM amazonlinux:2

RUN yum update -y \
  && yum install -y unzip \
  && curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscli-exe-linux-x86_64.zip \
  && unzip awscli-exe-linux-x86_64.zip \
  && ./aws/install

RUN yum -y install tcsh
  
ADD fetch_and_run_mod.sh /usr/bin/fetch_and_run_mod.sh

ENTRYPOINT ["/usr/bin/fetch_and_run_mod.sh"]