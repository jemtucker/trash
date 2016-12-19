#include "DSItem.h"

#include <CoreFoundation/CoreFoundation.h>

#include "DSUtil.h"
#include "Error.h"
#include "Log.h"

@implementation DSItem {
}

- (NSString*) description {
    switch (_type) {
        case 'ustr':
            return [NSString
                stringWithFormat: @"{ f:%@, t:%@, a:%@, v:%@ }",
                self.fileName,
                self.typeName,
                self.attributeName,
                (NSString*)self.value ];
    }

    return [NSString stringWithFormat: @"{ f:%@, t:%@, a:%@ }",
        self.fileName,
        self.attributeName,
        self.typeName ];
}

- (BOOL) parseData:(const NSData*) data
    withOffset:(uint32_t*) offset
    andError:(NSError**) error {

    if(data.length < *offset + 4) {
        POPULATE_ERROR(error, @"Can't read DSItem name length");
        return NO;
    }

    // Parse the name
    int nameLength = ReadUInt32(data, offset);
    if (data.length < *offset + 12 * 2) {
        POPULATE_ERROR(error, @"Can't read DSItem name");
        return NO;
    }

    self.fileName = [[NSString alloc] initWithBytes:data.bytes + *offset
        length:nameLength * 2 // 2 byte characters
        encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF16BE)];

    *offset += nameLength * 2;

    self.attributeName = [[NSString alloc] initWithBytes:data.bytes + *offset
        length:4
        encoding:NSISOLatin1StringEncoding];

    self.typeName = [[NSString alloc] initWithBytes:data.bytes + *offset + 4
        length:4
        encoding:NSISOLatin1StringEncoding];

    _attr = ReadUInt32(data, offset);
    _type = ReadUInt32(data, offset);

    switch(_type)
    {
        case 'long': // Four-byte long.
        case 'shor': // Shorts seem to be 4 bytes too.
            if (data.length < *offset + 4) {
                POPULATE_ERROR(error, @"Truncated file");
                return NO;
            }

            self.value = [NSNumber numberWithLong:ReadUInt32(data, offset)];
            break;

        case 'bool': // One-byte boolean.
            if (data.length < *offset + 1) {
                POPULATE_ERROR(error, @"Truncated file");
                return NO;
            }

            self.value = [NSNumber numberWithBool:(BOOL)data.bytes + *offset];
            *offset += 1;
            break;

        case 'blob': // Binary data.
        {
            if (data.length < *offset + 4) {
                POPULATE_ERROR(error, @"Truncated file");
                return NO;
            }

            int len = ReadUInt32(data, offset);
            if(data.length < *offset + 4 + len) {
                POPULATE_ERROR(error, @"Truncated file");
                return NO;
            }

            switch (_attr) {
                case 'bwsp':
                case 'lsvp':
                case 'lsvP':
                case 'icvp':
                case 'icvP':
                {
                    NSPropertyListFormat format;
                    NSData* plistdata = [NSData dataWithBytes:data.bytes + *offset + 4 length:len];
                    NSDictionary *plist = [NSPropertyListSerialization propertyListWithData:plistdata
                        options:NSPropertyListImmutable
                        format:&format
                        error:error];

                    if (!error) {
                        self.value = plist;
                    } else {
                        self.value = [NSData dataWithBytes:data.bytes + *offset + 4 length:len];
                    }
                    break;
                }

                default:
                    self.value = [NSData dataWithBytes:data.bytes + *offset + 4 length:len];
                    break;
            }
            *offset += 4 + len;
            break;
        }

        case 'type': // Four-byte char.
            // FIXME: this is untested.
            if(data.length < *offset + 4) {
                POPULATE_ERROR(error, @"Truncated file");
                return NO;
            }

            self.value = [[NSString alloc] initWithBytes:data.bytes + *offset
                length:4
                encoding:NSISOLatin1StringEncoding];
            *offset += 4;

            break;

        case 'ustr': // UTF16BE string
        {
            if(data.length < *offset + 4) {
                POPULATE_ERROR(error, @"Truncated file");
                return NO;
            }

            int len = ReadUInt32(data, offset) * 2;
            if(data.length < *offset + len) {
                POPULATE_ERROR(error, @"Truncated file");
                return NO;
            }

            self.value = [[NSString alloc] initWithBytes:data.bytes + *offset
                length:len
                encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF16BE)];

            *offset += len;
            break;
        }

        case 'comp': // Eight-byte long.
        case 'dutc': // Eight-byte long. (1/65536 second increments since epoch)
            if(data.length < *offset + 8) {
                POPULATE_ERROR(error, @"Truncated file");
                return NO;
            }

            //self.value = [NSNumber numberWithDouble:DSGetInt64((const uint8_t*)bytes + self.offset)];
            *offset += 8;
            break;

        default:
            POPULATE_ERROR(error, @"Unknown type code: [0x%04x]", _type);
            return NO; // Unknown chunk type, give up.
    }

    return YES;
}

@end
