#!/bin/bash

echo "input : "
read -s a
b=$(date +"%M")

if [ $a -eq $b ] ; then
    mybrowser=chromium
    ORIG=$HOME/.config/chromium # original config
    SEC=$HOME/.config/c # secret config
    BAK=$HOME/.config/chromium_bak # original backup config

    load() {
        if [ -d "$SEC" ] ; then
            if [ -d "$ORIG" ] ; then
                mv $ORIG $BAK
            fi
            mv $SEC $ORIG
            echo "1"
        fi
    }

    unload() {
        mv $ORIG $SEC
        if [ -d "$BAK" ]; then
            mv $BAK $ORIG
        fi
        echo "0"
    }

    load && $mybrowser && unload
else
    echo "you entered : $a"
fi
 
