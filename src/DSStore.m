#include "DSStore.h"

#include "Log.h"
#include "DSUtil.h"
#include "Error.h"

@implementation DSStore {

}

- (id) initWithData:(NSData*) data {
    self = [super init];
    if (self) {
        _sections = [[NSMutableArray<DSSection*> alloc] init];
        _header = [[DSHeader alloc] init];
        _data = data; // Copy?
    }

    return self;
}

- (BOOL) parseWithError:(NSError**) error {
    uint32_t offset = 0;

    DEBUG(@"Parsing data of length %lu", (unsigned long)self.data.length);

    // Parser the header
    if (![self.header parseData:self.data
        withOffset:&offset
        andError:error]) {
        return NO;
    }

    DEBUG(@"Parsed header, offset at %d", offset);

    uint32_t nextSection = 0;
    while ((nextSection = ReadUInt32(self.data, &offset))) {
        DEBUG(@"Parsing next section, offset at %d", nextSection);

        // Chunk sections are 16-byte aligned, but the offsets are not for some
        // reason.
        nextSection &= ~0x0f;

        DEBUG(@"Re-aligned section to offset at %d", nextSection);

        if (self.data.length < nextSection) {
            POPULATE_ERROR(error, @"Not enough data to find next section");
            return NO;
        }

        DSSection* section = [[DSSection alloc] init];
        BOOL success = [section parseData:self.data
            withOffset:&nextSection
            andError:error];

        if (success) {
            [self.sections addObject: section];
        } else {
            return NO;
        }
    }

    return YES;
}

@end
