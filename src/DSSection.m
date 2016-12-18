#include "DSSection.h"

#include "DSUtil.h"
#include "Log.h"
#include "Error.h"

@implementation DSSection {

}

- (id) init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (BOOL) parseData:(const NSData*) data
    withOffset:(uint32_t*) offset
    andError:(NSError**) error {

    DEBUG(@"Starting Offset: [%d]", *offset);
    DEBUG(@"Data Length: [%lu]", (unsigned long) data.length);

    if (data.length < (*offset + 8)) {
        POPULATE_ERROR(error, @"Passed end of buffer parsing section");
    }

    int chunk_offs = *offset;
    DEBUG(@"Offset: [%d]", *offset);

    int val2 = ReadUInt32(data, offset);
    DEBUG(@"Offset: [%d]", *offset);

    int numchunks = ReadUInt32(data, offset);
    DEBUG(@"Offset: [%d]", *offset);

    DEBUG(@"Val2 [%d], numchunks [%d], chunk_offs [%d]", val2, numchunks, chunk_offs);

    // NSMutableArray *parsedChunks = [NSMutableArray arrayWithCapacity:numchunks];

    // for (int i = 0; i < numchunks; i++) {
    //     if (val2 & 2) chunk_offs += 4; // Extra four-byte value before each chunk.
    //     DSChunk *chunk = [DSChunk chunkWithData:self.data atOffset:chunk_offs];
    //
    //     if (![chunk parse]) return NO; // Done (or something went wrong
    //
    //     [parsedChunks addObject:chunk];
    //     chunk_offs = chunk.offset;
    // }

    return NO;
}

@end
