#include <Foundation/Foundation.h>

@interface DSItem : NSObject {

}

@property (assign) NSString* fileName;
@property (assign) NSString* attributeName;
@property (assign) NSString* typeName;
@property (assign) NSObject* value;
@property (assign) uint32_t attr;
@property (assign) uint32_t type;

- (BOOL) parseData:(const NSData*) data
    withOffset:(uint32_t*) offset
    andError:(NSError**) error;

@end
