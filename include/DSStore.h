#include <Foundation/Foundation.h>

#include "DSHeader.h"
#include "DSSection.h"

@interface DSStore : NSObject {

}

@property (strong) NSData* data;
@property (strong) DSHeader* header;
@property (strong) NSMutableArray<DSSection*>* sections;

/**
Initialise a DSStore with a binary blob of data. None of the data will be
parsed.
@param data Binary DS_Store formatted data.
@return Initialised DSStore
*/
- (id) initWithData:(NSData*) data;

/**
Parse the underlying binary DS_Store formatted data, loading all sections and
items.
@param error Error populated on failure
@return YES if successful
*/
- (BOOL) parseWithError:(NSError**) error;

@end
