#include "DSUtil.h"

#import <CoreFoundation/CoreFoundation.h>

uint32_t ReadUInt32(const NSData* data, uint32_t* offset) {
    uint32_t* result = (uint32_t*) (data.bytes + *offset);
    *offset += sizeof(uint32_t);
    return CFSwapInt32BigToHost(*result);
}
