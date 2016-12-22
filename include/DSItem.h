#include <Foundation/Foundation.h>

@interface DSItem : NSObject {

}

@property (strong) NSString* fileName;
@property (strong) NSString* attributeName;
@property (strong) NSString* typeName;
@property (strong) NSObject* value;
@property uint32_t attr;
@property uint32_t type;

/**
Populate a DSItem from a binary blob, updating the passed offset to point
to the byte past the item.
@param data Pointer to NSData object to be parsed
@param offset Offest to start parsing at, updated to point to end of item
@param error Error populated on failure
@return YES on success
*/
- (BOOL) parseData:(const NSData*) data
    withOffset:(uint32_t*) offset
    andError:(NSError**) error;

@end
