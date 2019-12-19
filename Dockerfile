
##############################################################################
#
#  Copyright (C) 2017-2019 Dr Adam S. Candy.
#  
#                   Contact: Dr Adam S. Candy, adam@candylab.org
#  
#  This file is part of the CaribbeanWatch project.
#  
#  Please see the AUTHORS file in the main source directory for a full list
#  of contributors.
#  
#  CaribbeanWatch is free software: you can redistribute it and/or modify
#  it under the terms of the GNU Lesser General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#  
#  CaribbeanWatch is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Lesser General Public License for more details.
#  
#  You should have received a copy of the GNU Lesser General Public License
#  along with CaribbeanWatch. If not, see <http://www.gnu.org/licenses/>.
#
##############################################################################

# Use a Xenial base image
FROM ubuntu:bionic

# This DockerFile is looked after by
MAINTAINER Adam Candy <adam@candylab.org>

ARG DEBIAN_FRONTEND=noninteractive 

# Install required packages
RUN apt-get update && apt-get install -y \
        git \
        python3-pip \
        python3-scipy \
        python3-numpy \
        python3-matplotlib \
				python3-mpltoolkits.basemap \
        python3-shapely \
				python3-pil \
        python3-netcdf4 \
				ffmpeg \
				python3-oauth \
				python3-oauth2client \
				python3-oauthlib \
				python3-requests-oauthlib

RUN apt-get upgrade -y openssl
RUN sed -i.bak -e 's/SECLEVEL=2/SECLEVEL=1/' /usr/lib/ssl/openssl.cnf

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1

# Upgrade pip
RUN pip3 install -i https://pypi.python.org/simple/ --upgrade pip setuptools

RUN python3 -m pip install motuclient==1.8.4
RUN pip3 install requests_oauthlib
RUN pip3 install fiona
RUN pip3 install tweepy
RUN pip3 install cloudpickle

# Add a user
RUN adduser --disabled-password --gecos "" motutest

# Switch user
USER motutest
WORKDIR /home/motutest

RUN echo "DEBUGASC"
RUN python --version
RUN python -m motuclient --version
RUN python -c "import ssl; print(ssl.OPENSSL_VERSION)"
RUN python3 -v -c "import motuclient" 2>&1 | grep motuclient

COPY --chown=motutest:motutest cmems_secret.py /home/motutest/
COPY --chown=motutest:motutest test.sh /home/motutest/

RUN /usr/bin/python3 /usr/local/bin/motuclient -u $(grep CMEMS_USER /home/motutest/cmems_secret.py | sed -e "s/'$//" -e "s/^.*'//") -p $(grep CMEMS_PASS /home/motutest/cmems_secret.py | sed -e "s/'$//" -e "s/^.*'//") -m http://nrt.cmems-du.eu/motu-web/Motu -s GLOBAL_ANALYSIS_FORECAST_PHY_001_024-TDS -d global-analysis-forecast-phy-001-024-hourly-t-u-v-ssh -x -72 -X -60 -y 10 -Y 20 -t "2019-12-11 00:00:00" -T "2019-12-28 23:59:59" -z 0.493 -Z 0.4942 -v thetao -v zos -v uo -v vo
RUN ls -lhtr

