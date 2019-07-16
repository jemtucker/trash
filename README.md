# ./trash

[![Build Status](https://travis-ci.org/jemtucker/trash.svg?branch=master)](https://travis-ci.org/jemtucker/trash)

Command line utility for OSX 10.8+ to enable safe deleting and restoring of
files using the Trash.

```
Usage: trash [-ehlprv] [FILE...]
    -e --empty      Empty the trash
    -h --help       Show this help
    -l --list       List the current Trash contents
    -p --put-back   Restore a file from the Trash
    -r --recursive  Delete folders recursively
    -v --verbose    Set verbose mode
```

## Building
Build using make...

```
$ git clone https://github.com/jemtucker/trash.git
$ cd trash && make 
$ target/trash -h
```
