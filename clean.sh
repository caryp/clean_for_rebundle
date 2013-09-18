#!/bin/bash -ex
source functions.sh

#
# Clean image before bundling
#

clean()
{
  echo "Cleaning logfile: $1"
  [ -f "$1" ] && cat /dev/null > $1
  rm -f $1.[12345]
}


# Clean up repo with ruby 1.8.7 install
rm -f /etc/yum.repos.d/CentOS-ruby-custom.repo

#
# State information
#
rm -rf /var/spool/cloud/*
service postfix stop
find /var/spool -type f -exec ~/truncate.sh {} \;
rm -rf /tmp/*
rm -rf /tmp/.[^.]*
rm -rf /tmp/..?*

#
# Package manager cleanup /
# Distro specific stuff
# 
case $os in
"centos"|"redhatenterpriseserver")
  # Ensure php package isn't installed.
  yum -y remove php*

  yum -y clean all
  ;;
"ubuntu")
  apt-get clean

  service ntp stop
  ;; 
esac

# Remove empty password from root
sed -i s/root::/root:*:/ /etc/shadow

#
# Log files
#
find /var/log -type f -exec ~/truncate.sh {} \;

rm -rf /var/cache/*

# Recreate needed directories (w-4381)
mkdir /var/cache/logwatch /var/cache/man

rm -rf /var/mail/*

find /etc -name \*~ -exec rm -- {} \;
find /etc -name \*.backup* -exec rm -- {} \;

if [ "$os" == "ubuntu" ]; then
  # Rebuild Apt cache
  mkdir -p /var/cache/apt/archives/partial /var/cache/debconf
  apt-cache gencaches

  # Create man cache
  mandb --create

  mkdir /var/cache/nscd  
  rm -rf /var/lib/ntp/ntp.drift
fi

#
# /etc
#
rm -f /etc/hosts.backup.*
find /etc/ssh/ssh_host_* -type f -exec ~/truncate.sh {} \;
rm -rf /etc/pki/tls/private/*

#
# /root
#
rm -rf /root/.ssh
rm -rf /root/.gem
rm -f /root/*.tar
rm -rf /root/files
rm -f /root/*
rm -rf /root/.*_history /root/.vim* /root/.lesshst /root/.gemrc
rm -rf /root/.cache /root/.vim

updatedb
sync
