
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

# Ensure we are asked no questions for installs
ARG DEBIAN_FRONTEND=noninteractive 

# Install required packages
RUN apt-get update && apt-get install -y \
        python3-pip \
        python3-netcdf4

# Select Python3 as the default
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1

# Upgrade pip
RUN pip3 install -i https://pypi.python.org/simple/ --upgrade pip setuptools

# Install motuclient
RUN python3 -m pip install motuclient==1.8.4

# Add a user
RUN adduser --disabled-password --gecos "" motutest

# Switch user
USER motutest
WORKDIR /home/motutest

# Copy over files needed for the test
COPY --chown=motutest:motutest cmems_secret.py /home/motutest/
COPY --chown=motutest:motutest test.sh /home/motutest/

# Provide some information about the environment
RUN echo "DEBUGASC"
RUN python3 --version
RUN python3 -m motuclient --version
RUN python3 -c "import ssl; print(ssl.OPENSSL_VERSION)"
RUN python3 -v -c "import motuclient" 2>&1 | grep motuclient


