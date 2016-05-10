#!/usr/bin/env bash
# kickstart bigfix install
# current target - ubuntu/debian
# 
# Reference: https://support.bigfix.com/bes/install/besclients-nonwindows.html
#
# Usage:
#   wget install_bigfix_ubuntu.sh
#   chmod u+x install_bigfix_ubuntu.sh
#   ./install_bigfix_ubuntu.sh


# TODO: check for the masthead file in current directory
# TODO: allow masthead URL to be specified as argument
MASTHEAD="http://_ROOT_OR_RELAY_SERVER_FQDN_:52311/masthead/masthead.afxm"

if [ "$(id -u)" != "0" ]; then
  echo "Sorry, you are not root."
  exit 1
fi

# use this to check if Mac (darwin)
echo $OSTYPE

INSTALLDIR="/etc/opt/BESClient"
INSTALLERURL="http://software.bigfix.com/download/bes/95/BESAgent-9.5.1.9-ubuntu10.amd64.deb"
INSTALLER="BESAgent.deb"

if [ ! -d "$INSTALLDIR" ]; then
  # Control will enter here if $INSTALLDIR doesn't exist.
  mkdir $INSTALLDIR
fi

# Download the BigFix agent (using cURL because it is on Linux & OS X by default)
curl -o $INSTALLER $INSTALLERURL
# Download the masthead, renamed, into the correct location
curl -o $INSTALLDIR/actionsite.afxm $MASTHEAD

# install BigFix client
if [[ $INSTALLER == *.deb ]]; then
  #  debian (DEB)
  dpkg -i $INSTALLER
fi
if [[ $INSTALLER == *.pkg ]]; then
  #  Mac OS X (PKG)
  installer -pkg $INSTALLER -target /
  # TODO: add case for Solaris
  # pkgadd -d $INSTALLER  #  Solaris (PKG)
fi
if [[ $INSTALLER == *.rpm ]]; then
  #  linux (RPM)
  rpm -ivh $INSTALLER
fi

if [ -f /etc/init.d/besclient ]; then
  # start the BigFix client
  /etc/init.d/besclient start
fi

### Referenes:
# - http://stackoverflow.com/questions/733824/how-to-run-a-sh-script-in-an-unix-console-mac-terminal
# - http://stackoverflow.com/questions/394230/detect-the-os-from-a-bash-script
