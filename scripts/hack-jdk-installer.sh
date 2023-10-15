#!/usr/bin/env bash

if [ ! -f $1 ]; then
    echo "JDK installer not found in $1"
    exit 1
fi

# Auto accept Sun Microsystems license:
ed $1 << EOF
25,384d
w
q
EOF
echo "Sun Microsystem license accepted!"

sed -ri -e 's/\+766/+406/g' $1

