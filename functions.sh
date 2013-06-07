os=$(lsb_release -is|tr '[:upper:]' '[:lower:]'|tr -d '\n')
codename=$(lsb_release -cs)
arch=$(uname -m)
[ "$arch" == "i686" ] && arch="i386"
rightlink_ver=$1
rightlink_os=$os
[ "$rightlink_os" == "redhatenterpriseserver" ] && rightlink_os="rhel"
rightlink_os_ver=$(lsb_release -rs)
rightlink_arch=$arch
[[ "$rightlink_arch" == "x86_64" && "$rightlink_os" == "ubuntu" ]] && rightlink_arch="amd64"
provider=$2
debug=$3
freezedate=$4

download() {
  case $os in
  "centos"|"redhatenterpriseserver")
    rightlink_pkg="rpm"
    ;;
  "ubuntu")
    rightlink_pkg="deb"
    ;;
  *)
    echo "FATAL: Unknown OS"
    exit 1
    ;;
  esac
  
  rightlink_file="rightscale_${rightlink_ver}-${rightlink_os}_${rightlink_os_ver}-${rightlink_arch}.${rightlink_pkg}" 
  buckets=( rightscale_rightlink rightscale_rightlink_dev )
  locations=( /$rightlink_ver/$os/ /$rightlink_ver/$rightlink_os/ /$rightlink_ver/ / )

  [ -f /root/.rightscale/$rightlink_file ] && return 0
 
  set +e 
  for bucket in ${buckets[@]}
  do
    for location in ${locations[@]}
    do
      code=$(curl -o /root/.rightscale/${rightlink_file} --connect-timeout 10 --fail --silent --write-out %{http_code} http://s3.amazonaws.com/$bucket$location${rightlink_file})
      return=$?
      echo "BUCKET: $bucket LOCATION: $location RETURN: $return CODE: $code"
      [[ "$return" -eq "0" && "$code" -eq "200" ]] && break 2
    done
  done

  if [ "$?" == "0" ]; then
    set -e
    post
    set +e
    return 0
  fi

  return 1
}

post() {
  mkdir -p /etc/rightscale.d
  echo $rightlink_ver > /etc/rightscale.d/rightscale-release
  # Translate rackspace-* to a recognizable RightLink provider type
  # Use a separate variable so you don't clobber the old one
  if [[ "$provider" == *rackspace* ]]; then
    _provider="rackspace"
  else
    _provider="$provider"
  fi
  echo -n "$_provider" > /etc/rightscale.d/cloud
  chmod 0770 /root/.rightscale
  chmod 0440 /root/.rightscale/*

  # Install RightLink seed script
  install /root/files/rightimage /etc/init.d/rightimage --mode=0755

  case $os in
  "centos"|"redhatenterpriseserver")
    chkconfig --add rightimage
    ;;
  "ubuntu")
    update-rc.d rightimage start 96 2 3 4 5 . stop 1 0 1 6 .
    ;;
  *)
    echo "FATAL: Unsupported OS"
    exit 1
    ;;
  esac

  set +e
  [[ "$provider" == *rackspace* ]] && sed -i "s/amazon$/nova-agent/g" /etc/init.d/rightimage
}

remove_packages() {
  set +e
  for i in $1; do
    rpm --erase --nodeps --allmatches "${i}";
  done
  set -e
}
