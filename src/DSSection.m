#include "DSSection.h"

#include "DSUtil.h"
#include "Log.h"
#include "Error.h"

@implementation DSSection {

}

- (id) init {
    self = [super init];
    if (self) {
        _items = nil;
    }
    return self;
}

- (BOOL) parseData:(const NSData*) data
    withOffset:(uint32_t*) offset
    andError:(NSError**) error {

    if (data.length < (*offset + 8)) {
        POPULATE_ERROR(error, @"Passed end of buffer parsing section");
    }

    int val1 = ReadUInt32(data, offset);
    (void)val1; // Unsused;

    int flags = ReadUInt32(data, offset);

    int numItems = ReadUInt32(data, offset);

    DEBUG(@"Parsing [%d] DSItems", numItems);

    NSMutableArray<DSItem*>* items =
        [NSMutableArray<DSItem*> arrayWithCapacity:numItems];
    for (int i = 0; i < numItems; i++) {
        // Extra four-byte value before each chunk
        if (flags & 2) {
            *offset += 4;
        }

        DSItem *item = [[DSItem alloc] init];
        if (![item parseData:data withOffset:offset andError:error]) {
            return NO;
        }

        [items addObject:item];
    }

    if (self.items) {
        [self.items release];
    }

    self.items = items;

    return YES;
}

@end
