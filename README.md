# P2PSP War Games

[![Join the chat at https://gitter.im/P2PSP/CIS-MPs-estimator](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/P2PSP/CIS-MPs-estimator?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Test bed to measure the impact of several types of attacks in a P2PSP Team.

## Cloning
To clone this projects with all submodules, make sure you
clone with `--recursive` argument: `git clone --recursive ...`

## Pre-requisites
### Linux
```
$ [sudo] apt-get install libboost-all-dev
$ [sudo] apt-get install libssl-dev
$ [sudo] apt-get install python3-numpy
$ [sudo] apt-get install cvlc
$ [sudo] apt-get install cmake
$ [sudo] apt-get install gnuplot
```

## Build the P2PSP Library
### Linux
```
$ cd lib/p2psp
$ ./make.py
$ cd ../..
```

## Run it
```
./simulator [-n -i -t -m -z -d -c]
```
**n** number of peer in the initial team  
**i** number of TPs in the initial team  
**t** total number of TPs  
**m** total number of MPs  
**z** total size of the entire team  
**d** duration of the experiment in seconds  
**c** clean results of the experiment  

## Entities in a Team
- Splitter
- Well-intended peer (WIP)
- Trusted Peer (TP)
- Malicious peer (MP)
