#! /bin/sh

# op25 install script for debian based systems
# including ubuntu 14/16 and raspbian

if [ ! -d op25/gr-op25 ]; then
	echo ====== error, op25 top level directories not found
	echo ====== you must change to the op25 top level directory
	echo ====== before running this script
	exit
fi

echo "Updating packages list"
apt-get update

GR_VER=$(apt list gnuradio 2>/dev/null | grep -m 1 gnuradio | cut -d' ' -f2 | cut -d'.' -f1,2)
if [ ${GR_VER} = "3.8" ]; then
    echo "Installing for GNURadio 3.8"
    sed -i -- 's/^# *deb-src/deb-src/' /etc/apt/sources.list
    apt-get build-dep gnuradio
    apt-get install -y gnuradio gnuradio-dev gr-osmosdr librtlsdr-dev libuhd-dev libhackrf-dev libitpp-dev libpcap-dev liborc-dev cmake git swig build-essential pkg-config doxygen python3-numpy python3-waitress python3-requests gnuplot-x11

    # Tell op25 to use python3
    echo "/usr/bin/python3" > op25/gr-op25_repeater/apps/op25_python

else
    echo "Installing for GNURadio 3.7"
    apt-get build-dep gnuradio
    apt-get install -y gnuradio gnuradio-dev gr-osmosdr librtlsdr-dev libuhd-dev  libhackrf-dev libitpp-dev libpcap-dev cmake git swig build-essential pkg-config doxygen python-numpy python-waitress python-requests gnuplot-x11

    # Tell op25 to use python2
    echo "/usr/bin/python2" > op25/gr-op25_repeater/apps/op25_python

fi

if [ ! -f /etc/modprobe.d/blacklist-rtl.conf ]; then
	echo ====== installing blacklist-rtl.conf
	echo ====== please reboot before running op25
	install -m 0644 ./blacklist-rtl.conf /etc/modprobe.d/
fi

rm -rf build
mkdir build
cd build
cmake ../         2>&1 | tee cmake.log
make              2>&1 | tee make.log
make install 2>&1 | tee install.log
ldconfig
