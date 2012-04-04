#!/bin/sh

if [ $# -eq 0  ]
then
    echo "Error in $0 - Invalid Argument Count"
    echo "Syntax: $0 input_file"
    echo "or"
    echo "Syntax: $0 input_file output_file"
    exit
fi

if [ $# -eq 1 ]
then
    ./pas2c < $1 > output.c
    astyle --style=ansi output.c 1>/dev/null
else
    ./pas2c < $1 > $2
    astyle --style=ansi $2  1>/dev/null
fi

echo "Conversation successful"
