#include <Foundation/Foundation.h>

@interface DSHeader : NSObject {

}

/**
Populate a DSHeader from a binary blob, updating the passed offset to point
to the byte past the header.
@param data Pointer to NSData object to be parsed
@param offset Offest to start parsing at, updated to point to end of header
@param error Error populated on failure
@return YES on success
*/
- (BOOL) parseData:(NSData*) data
    withOffset:(uint32_t*) offset
    andError:(NSError**) error;

@end
