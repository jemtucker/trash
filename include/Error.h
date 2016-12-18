#include <Foundation/Foundation.h>

#define ERROR_DOMAIN @"com.jemtucker.trash"

#define POPULATE_ERROR(err, f, ...) *err = [NSError                         \
    errorWithDomain:ERROR_DOMAIN                                            \
    code:1                                                                  \
    userInfo:@{ NSLocalizedDescriptionKey:[NSString                         \
    stringWithFormat:f, ##__VA_ARGS__] }]                                   \
