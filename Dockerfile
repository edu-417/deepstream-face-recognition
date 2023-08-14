FROM --platform=arm64 nvcr.io/nvidia/deepstream-l4t:6.3-samples
ARG PYDS_BINDING=pyds-1.1.8-py3-none-linux_aarch64.whl
ENV DISPLAY=$DISPLAY
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES all

RUN apt-get update && apt-get install -y python3-gi python3-dev python3-gst-1.0 python-gi-dev git \
    python3 python3-pip python3.8-dev cmake g++ build-essential libglib2.0-dev \
    libglib2.0-dev-bin libgstreamer1.0-dev libtool m4 autoconf automake libgirepository1.0-dev libcairo2-dev

RUN cd sources && git clone https://github.com/NVIDIA-AI-IOT/deepstream_python_apps
RUN cd sources/deepstream_python_apps/ && git submodule update --init

RUN apt-get install -y apt-transport-https ca-certificates -y
RUN update-ca-certificates

RUN cd sources/deepstream_python_apps/3rdparty/gst-python/ && ./autogen.sh && make && make install

RUN wget https://github.com/NVIDIA-AI-IOT/deepstream_python_apps/releases/download/v1.1.8/${PYDS_BINDING}
RUN pip install ${PYDS_BINDING}

RUN pip install jupyter jupyterlab
RUN jupyter lab --generate-config
RUN ./user_additional_install.sh

RUN apt-get install gobject-introspection gir1.2-gst-rtsp-server-1.0 -y

EXPOSE 8554
EXPOSE 8888