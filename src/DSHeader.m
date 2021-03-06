#include "DSHeader.h"

#include "DSUtil.h"
#include "Error.h"

#include "Log.h"

@implementation DSHeader {
}

- (BOOL) parseData:(NSData*) data
    withOffset:(uint32_t*) offset
    andError:(NSError**) error {

    if ([data length] < 36) {
        POPULATE_ERROR(error, @"Not enough data");
        return NO;
    }

    DEBUG(@"Reading version with offset [%d]", *offset);

    const uint32_t version = ReadUInt32(data, offset);
    if (version != 1) {
        POPULATE_ERROR(error, @"Unsupported version [%u]", version);
        return NO;
    }

    DEBUG(@"Reading magic with offset [%d]", *offset);

    const uint32_t magic = ReadUInt32(data, offset);
    if (magic != 'Bud1') {
        POPULATE_ERROR(error, @"Invalid magic number [%u]", magic);
        return NO;
    }

    DEBUG(@"Reading allocator with offset [%d]", *offset);

    const uint32_t allocOffset1 = ReadUInt32(data, offset);
    const uint32_t allocSize = ReadUInt32(data, offset);
    const uint32_t allocOffset2 = ReadUInt32(data, offset);

    if (allocOffset1 != allocOffset2) {
        POPULATE_ERROR(error, @"Malformed allocator header");
        return NO;
    }

    if (!allocSize) {
        POPULATE_ERROR(error, @"Empty allocator");
        return NO;
    }
    //*offset += allocSize;

    // Header left no room for anything else
    if (*offset > [data length]) {
        POPULATE_ERROR(error, @"Not enough data for Allocator");
        return NO;
    }

    return YES;
}

@end
