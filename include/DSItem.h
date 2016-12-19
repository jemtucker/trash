#include <Foundation/Foundation.h>

@interface DSItem : NSObject {

}

@property (strong) NSString* fileName;
@property (strong) NSString* attributeName;
@property (strong) NSString* typeName;
@property (strong) NSObject* value;
@property uint32_t attr;
@property uint32_t type;

- (BOOL) parseData:(const NSData*) data
    withOffset:(uint32_t*) offset
    andError:(NSError**) error;

@end
