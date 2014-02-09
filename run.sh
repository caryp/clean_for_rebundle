#!/bin/bash
#
# Download latest clean_for_rebundle project tarball
# then run it.  Needs to be run as root.
#
# Use the following command:
#
#  > curl -L https://raw2.github.com/caryp/clean_for_rebundle/master/run.sh | sudo bash
#
# Feel free to fork this and put it your own mirror.
#
# cpenniman@gmail.com
#
curl -L https://github.com/caryp/clean_for_rebundle/archive/master.tar.gz -o /root/clean_for_rebundle.tar.gz`
cd /root
tar xvzf clean_for_rebundle.tar.gz --strip-components=1
./clean.sh


# Copyright 2014 Cary Penniman
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.