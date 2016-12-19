#include <Foundation/Foundation.h>

#include "Log.h"
#include "TrashManager.h"

static BOOL g_recursive = NO;
static BOOL g_restore = NO;

void usage(const int code) {
    printf("Usage: trash [-hlprv] FILE1 [FILE2] [...]\n");
    printf("    -h --help       Show this help\n");
    printf("    -l --list       List the current Trash contents\n");
    printf("    -p --put-back   Restore a file from the Trash\n");
    printf("    -r --recursive  Delete folders recursively\n");
    printf("    -v --verbose    Set verbose mode\n");
    exit(code);
}

void parseArgument(const NSString* arg) {
    if ([arg isEqualToString:@"--verbose"] ||
        [arg isEqualToString:@"-v"]) {
        [Log setVerbose];
        DEBUG(@"Verbose logging on");
    } else if ([arg isEqualToString:@"--help"] ||
        [arg isEqualToString:@"-h"]) {
        usage(EXIT_SUCCESS);
    } else if ([arg isEqualToString:@"--recursive"] ||
        [arg isEqualToString:@"-r"]) {
        g_recursive = YES;
    } else if ([arg isEqualToString:@"--list"] ||
        [arg isEqualToString:@"-l"]) {
        // List the current contents of the trash
        TrashManager* tm = [[TrashManager alloc] init];
        [tm listTrash];
        exit(EXIT_SUCCESS);
    } else if ([arg isEqualToString:@"--put-back"] ||
        [arg isEqualToString:@"-p"]) {
        // List the current contents of the trash
        g_restore = YES;
    } else {
        // Unknown option
        ERROR(@"Illegal option [%@]", arg);
        usage(EXIT_FAILURE);
    }
}

int main(const int argc, const char* argv[]) {
    @autoreleasepool {
        // Must supply at least one filename to delete
        if (argc < 2) {
            usage(EXIT_FAILURE);
        }

        // Parse the arguments
        int pos = 1;
        for (; pos < argc; pos++) {
            NSString* arg = [NSString stringWithUTF8String:argv[pos]];
            if ([arg hasPrefix:@"-"]) {
                parseArgument(arg);
            } else {
                break;
            }
        }

        // Check there are some filenames to parse, if not then exit
        if (pos == argc) {
            usage(EXIT_FAILURE);
        }

        // Delete each file
        TrashManager* manager = [[TrashManager alloc] init];
        for (; pos < argc; pos++) {
            NSString* path = [NSString stringWithUTF8String:argv[pos]];

            DEBUG(@"Read positional argument [%@]", path);

            BOOL success = TRUE;

            if (g_restore) {
                success = [manager restoreFile:path];
            } else {
                success = [manager trashFile:path recursive:g_recursive];
            }

            if (!success) {
                return EXIT_FAILURE;
            }
        }
    }
}
