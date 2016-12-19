#include <Foundation/Foundation.h>

#include "DSHeader.h"
#include "DSSection.h"

@interface DSStore : NSObject {

}

@property (strong) NSData* data;
@property (strong) DSHeader* header;
@property (strong) NSMutableArray<DSSection*>* sections;

- (id) initWithData:(NSData*) data;

- (BOOL) parseWithError:(NSError**) error;

@end
