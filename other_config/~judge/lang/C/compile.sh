#!/bin/dash
export LD_LIBRARY_PATH=/usr/lib:/lib:/usr/lib/gcc/i686-pc-linux-gnu/4.5.1
export LIBRARY_PATH=$LD_LIBRARY_PATH
export PATH=/bin:/usr/bin

#cp code code.c && gcc ./code.c -O2 -pipe -lm -o run
cp code code.c && tcc ./code.c -lm -o run

