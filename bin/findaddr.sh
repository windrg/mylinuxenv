#!/bin/sh
MODULE_NAME=$1
MODULE_FILE=$(modinfo $MODULE_NAME | awk '/filename/{print $2}')
DIR="/sys/module/${MODULE_NAME}/sections"
echo add-symbol-file ${MODULE_NAME}.ko -s .text $(cat "$DIR/.text") -s .bss $(cat "$DIR/.bss") -s .data $(cat "$DIR/.data")
#echo add-symbol-file ${MODULE_NAME}.ko $(cat "$DIR/.text") -s .bss $(cat "$DIR/.bss") -s .data $(cat "$DIR/.data") -s .exit.text $(cat "$DIR/.exit.text")
