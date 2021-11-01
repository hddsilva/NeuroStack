FROM amazonlinux:2

RUN yum update -y \
  && yum install -y unzip \
  && curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscli-exe-linux-x86_64.zip \
  && unzip awscli-exe-linux-x86_64.zip \
  && ./aws/install

RUN yum -y install tcsh
RUN yum -y install bc
RUN yum -y groupinstall "Development Tools"
  
ADD fetch_and_run_mod.sh /usr/bin/fetch_and_run_mod.sh
ADD bashrc /nitrc/home/ubuntu/.bashrc
ADD profile /nitrc/home/ubuntu/.profile

ENTRYPOINT ["/usr/bin/fetch_and_run_mod.sh"]