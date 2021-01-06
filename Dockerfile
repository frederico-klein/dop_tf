#FROM tensorflow/tensorflow:latest-gpu-jupyter ##2.4.0 is giving me a core dumped
FROM tensorflow/tensorflow:2.3.1-gpu-jupyter

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

ENV DEBIAN_FRONTEND noninteractive

##maybe needs curl, so it goes in the awkward middle:
ADD scripts/ros_key.sh /root/

RUN apt-get update && apt-get install -y --no-install-recommends \
         build-essential \
         cmake \
         git \
         curl \
         vim \
         ca-certificates \
         gnupg2 \
         libjpeg-dev \
         lsb-core \
         libpng-dev && \
    echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list && \
    /root/ros_key.sh && \
    apt-get update &&  apt-get install -y --fix-missing \
         python3-pip \
         python-pip \
         openssh-server\
         libssl-dev \
         lsb-core \
         tar\
         libboost-all-dev \
         ros-melodic-ros-base \
         python-rosdep \
         python-rosinstall \
         python-rosinstall-generator \
         python-wstool &&\
    apt-get clean && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

# some more ros stuff
RUN rosdep init && rosdep update
RUN echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc

# to get sshd working: (adapted from docker docs running_ssh_service)
#add my snazzy banner
ADD banner.txt /etc/

RUN mkdir /var/run/sshd \
     && echo 'root:ros_ros' | chpasswd \
     && sed -i 's/[#\s]*PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
     && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \
     && sed -i 's/[#\s]*Banner none/Banner \/etc\/banner.txt/' /etc/ssh/sshd_config

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22

ADD requirements_tf.txt /root/
RUN pip install -r /root/requirements_tf.txt

ADD scripts/entrypoint.sh /root/
WORKDIR /workspace
ENTRYPOINT ["/root/entrypoint.sh"]
