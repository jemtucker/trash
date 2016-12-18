#include "Log.h"

static Log* getLog();

@implementation Log {

}

- (id) init {
    self = [super init];
    if (self) {
        _level = ERROR;
    }

    return self;
}

- (void) write: (NSString*) msg withLevel: (Level) level {
    if (_level < level) {
        return;
    }

    switch (level) {
        case DEBUG:
            NSLog(@"DEBUG %@", msg);
            break;
        case ERROR:
            NSLog(@"ERROR %@", msg);
            break;
        case INFO:
            NSLog(@"INFO  %@", msg);
            break;
    }
}

+ (void) info: (NSString*) msg {
    Log* log = getLog();
    [log write: msg withLevel: INFO];
}

+ (void) error: (NSString*) msg {
    Log* log = getLog();
    [log write: msg withLevel: ERROR];
}

+ (void) debug: (NSString*) msg {
    Log* log = getLog();
    [log write: msg withLevel: DEBUG];
}

+ (void) setVerbose {
    Log* log = getLog();
    [log setLevel: DEBUG];
}

@end

Log* getLog() {
    static Log* log = NULL;

    if (!log) {
        log = [[Log alloc] init];
    }

    return log;
}
