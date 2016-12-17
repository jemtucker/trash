#include <Foundation/Foundation.h>

#include "Log.h"
#include "FileDeleter.h"

void usage() {
    printf("Usage: trash FILE \n");
}

int main(const int argc, const char* argv[]) {
    @autoreleasepool {

        // Currently we only support deleting 1 file at a time
        if (argc != 2) {
            DEBUG(@"Not enough arguments");

            usage();
            return EXIT_FAILURE;
        }

        // Delete each file
        for (int i = 1; i < argc; i++) {
            NSString* path = [NSString stringWithUTF8String: argv[i]];

            DEBUG(@"Read argument [%@]", path);

            FileDeleter* deleter = [[FileDeleter alloc] init];

            if ([deleter deleteFile: path]) {
                return EXIT_SUCCESS;
            } else {
                return EXIT_FAILURE;
            }
        }
    }
}
