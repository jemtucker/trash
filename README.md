# ./trash
Command line utility for OSX 10.8+ to enable safe deleting and restoring of
files using the Trash.

```
Usage: trash [-hlprv] FILE1 [FILE2] [...]
    -h --help       Show this help
    -l --list       List the current Trash contents
    -p --put-back   Restore a file from the Trash
    -r --recursive  Delete folders recursively
    -v --verbose    Set verbose mode
```

## Building
Building trash requires [tup](http://gittup.org/tup/). Once installed simply run
 `tup upd` in the repository root directory. The trash executable will be output
 into the target directory.

 ```
 user$ git clone https://github.com/jemtucker/trash.git
 user$ cd trash
 user$ tup upd
 user$ target/trash -h
 ```
