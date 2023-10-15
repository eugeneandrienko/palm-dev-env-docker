#!/usr/bin/env bash

if [ ! -f $1 ]; then
    echo "WTK installer not found in $1"
    exit 1
fi

# Is given installer matches byte to byte with expected
# file. Only one specific file could be patched by
# this script!
DESIRED_MD5_SUM="6b70b6e6d426eac121db8a087991589f"
md5sum -b $1 | sed -r 's/([0-9a-z]+ ).*/\1/g' | grep -q "$DESIRED_MD5_SUM"
if [ "$?" -ne 0 ]; then
    echo "File $1 is not matched byte to byte with expected installer!"
    echo "Expecting this installer: sun_java_wireless_toolkit-2.5.2_01-linuxi486.bin"
    exit 2
fi


# Auto accept Sun Microsystems license
# and auto select to use first found JDK,
# install in default directory and do not
# check for updates:
sed -ri -e 's/more <<"EOF"/cat <<  EOF/g' \
        -e 's/^agreed=/agreed=1/g' \
        -e 's/^  picked=/ picked=1/g' \
        -e 's/^    read picked/   \#read picked/g' \
        -e 's/^      read user_dir/         user_dir=0/g' \
        -e 's/^    read reply leftover/         reply=N       /g' \
        -e 's/^      read finish/         finish=0/g' \
        $1
