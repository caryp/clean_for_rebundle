Clean For Re-bundle
===================

Simple scripts to to remove ssh keys, logs, rightlink state, etc. before bundling a running Linux VM into an image. This is typically a good idea, especially if you plan to share you image with others.

DISCLAIMER: This code should work on CentOS, RHEL and Ubuntu.  See notes below before running.  This post was written specifically for cleaning RightScale RightImages, but should apply to custom images as well.  ***This is alpha code provided with no warranty, YMMV.***
That being said, feel free to post questions or issues and I will do what I can to help.

Usage
=====

1. configure VM the way you want it
2. from your VM run:

		> curl -L https://raw2.github.com/caryp/clean_for_rebundle/master/run.sh | sudo bash

3. rebundle image using cloud API or "bundle" button on rightscale dashboard.
4. ??
5. profit!


Notes
=====

For CentOS/RHEL, you must first have lsb_release utility installed.  To install run:

		> sudo yum install -y redhat-lsb


License
=======
Copyright 2014 Cary Penniman

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

