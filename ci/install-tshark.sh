#!/bin/bash

wget https://2.na.dl.wireshark.org/src/wireshark-1.10.13.tar.bz2
tar xjf wireshark-1.10.13.tar.bz2
cd wireshark-1.10.13

./configure --prefix /usr \
    --disable-wireshark \
    --disable-capinfos \
    --disable-captype \
    --disable-editcap \
    --disable-dumpcap \
    --disable-mergecap \
    --disable-reordercap \
    --disable-text2pcap \
    --disable-randpkt \
    --disable-dftest \
    --disable-rawshark

make
sudo make install