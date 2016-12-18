#include <Foundation/Foundation.h>

#include "DSHeader.h"
#include "DSSection.h"

@interface DSStore : NSObject {

}

@property (assign) NSData* data;
@property (assign) DSHeader* header;
@property (assign) NSMutableArray<DSSection*>* sections;

- (id) initWithData:(NSData*) data;

- (BOOL) parseWithError:(NSError**) error;

@end
