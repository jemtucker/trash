#include <Foundation/Foundation.h>

#include "DSItem.h"

@interface DSSection : NSObject {

}

@property (assign) NSArray<DSItem*>* items;

/**
Populate a DSSection from a binary blob, updating the passed offset to point
to the byte past the section.
@param data Pointer to NSData object to be parsed
@param offset Offest to start parsing at, updated to point to end of the section
@param error Error populated on failure
@return YES on success
*/
- (BOOL) parseData:(const NSData*) data
    withOffset:(uint32_t*) offset
    andError:(NSError**) error;

@end
