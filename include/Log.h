#include <Foundation/Foundation.h>

#define DEBUG(f, ...) [Log debug:[NSString stringWithFormat:f, ##__VA_ARGS__]]
#define ERROR(f, ...) [Log error:[NSString stringWithFormat:f, ##__VA_ARGS__]]

typedef enum {
    ERROR = 0,
    INFO  = ERROR + 1,
    DEBUG = ERROR + 2
} Level;

/**
Singleton to handle application logging.
*/
@interface Log : NSObject {

}

@property (nonatomic) Level level;

+ (void) info: (NSString*) msg;

+ (void) error: (NSString*) msg;

+ (void) debug: (NSString*) msg;

+ (void) setVerbose;

@end
