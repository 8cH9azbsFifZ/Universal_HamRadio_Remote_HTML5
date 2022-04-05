FROM debian

# cf. https://github.com/F4HTB/Universal_HamRadio_Remote_HTML5/wiki/Example-of-complete-installation
RUN apt-get update
RUN apt-get install -y git python3 python3-pip python3-numpy python3-tornado python3-serial python3-pyaudio rtl-sdr libasound2-dev
RUN pip3 install pyalsaaudio pam pyrtlsdr
RUN apt-get autoremove -y --purge python3-libhamlib2
RUN apt-get install -y autoconf automake libtool swig

WORKDIR /app
RUN git clone https://github.com/Hamlib/Hamlib.git

WORKDIR /app/Hamlib/
RUN ./bootstrap
RUN ./configure --with-python-binding PYTHON=$(which python3)
RUN make all 
RUN make install 
WORKDIR /app/Hamlib/bindings
RUN make 
RUN make install 
RUN ldconfig

WORKDIR /app
RUN git clone https://github.com/F4HTB/Universal_HamRadio_Remote_HTML5.git
WORKDIR /app/Universal_HamRadio_Remote_HTML5

RUN apt-get -y install libopus-dev

ENV PYTHONPATH=/usr/local/lib/python3.9/site-packages/:$PYTHONPATH 

CMD ["./UHRR"]
