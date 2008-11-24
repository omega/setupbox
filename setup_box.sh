#!/bin/sh

## Setup a new box
# andreas 2008-10-08

# transfer ssh-key

if [ -z "$U" ]; then
	U=$USER
fi

ROOT=`dirname $0`
ROOT="${ROOT}"
echo "finding files in ${ROOT}/root, to copy"

OLDCWD=`pwd`
cd "${ROOT}/root"
items=`find .`
cd $OLDCWD
set -u
for host in "$@"; do
    
    echo "host: ${host} More than 1 pwd prompts means something is fubar"

#   set -v
    
    echo " ssh (from ~/.ssh/):"
    if [ -f ~/.ssh/id_dsa.pub ]; then
        echo "  id_dsa.pub"
        #cat ~/.ssh/id_dsa.pub | ssh ${U}@${host} "mkdir -m 0700 -p .ssh && cat - >> ~/.ssh/authorized_keys && chmod 0600 ~/.ssh/authorized_keys"
    elif [ -f ~/.ssh/id_rsa.pub ]; then
        echo "  id_rsa.pub"
        #    cat ~/.ssh/id_rsa.pub | ssh ${U}@${host} "mkdir -m 0700 -p .ssh && cat - >> ~/.ssh/authorized_keys && chmod 0600 ~/.ssh/authorized_keys"
    fi
    echo " transfering files"
    for i in ${items}; do
        if [ $i == "." ]; then
            continue;
        fi
        i=`echo ${i} | sed -e "s/^\.\///"`
        if [ -f "${ROOT}/root/$i" ]; then
            echo "   file: ${i}"
            echo scp "${ROOT}/root/${i}" ${U}@${host}:$i
        elif [ -d "${ROOT}/root/$i" ]; then
            echo "    dir: ${i}"
            echo ssh ${U}@${host} "mkdir -p ${i}"
        else
            echo "    unk: ${i}  ((( ERROR )))"
        fi
    done;

done;
