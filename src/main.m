#include <Foundation/Foundation.h>

#include "Log.h"
#include "TrashManager.h"

static BOOL g_empty = NO;
static BOOL g_help = NO;
static BOOL g_list = NO;
static BOOL g_putback = NO;
static BOOL g_recursive = NO;
static BOOL g_verbose = NO;

void usage(const int code) {
    printf("Usage: trash [-ehlprv] [FILE...]\n");
    printf("    -e --empty      Empty the trash\n");
    printf("    -h --help       Show this help\n");
    printf("    -l --list       List the current Trash contents\n");
    printf("    -p --put-back   Restore a file from the Trash\n");
    printf("    -r --recursive  Delete folders recursively\n");
    printf("    -v --verbose    Set verbose mode\n");
    exit(code);
}

BOOL isEither(NSString* arg, NSString* a, NSString* b) {
    return [arg isEqualToString:a] || [arg isEqualToString:b];
}

void parseArgument(NSString* arg) {
    if (isEither(arg, @"--verbose", @"-v")) {
        g_verbose = YES;
    } else if (isEither(arg, @"--help", @"-h")) {
        g_help = YES;
    } else if (isEither(arg, @"--recursive", @"-r")) {
        g_recursive = YES;
    } else if (isEither(arg, @"--list", @"-l")) {
        g_list = YES;
    } else if (isEither(arg, @"--put-back", @"-p")) {
        g_putback = YES;
    } else if (isEither(arg, @"--empty", @"-e")) {
        g_empty = YES;
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

        if (g_help) {
            usage(EXIT_SUCCESS);
        }

        if (g_verbose) {
            [Log setVerbose];
        }

        if (g_list) {
            // List the current contents of the trash
            TrashManager* tm = [[TrashManager alloc] init];
            [tm listTrash];
            exit(EXIT_SUCCESS);
        }

        if (g_empty) {
            // Completely empty the trash
            TrashManager* tm = [[TrashManager alloc] init];
            exit([tm emptyTrash]);
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

            if (g_putback) {
                success = [manager restoreFile:path];
            } else {
                success = [manager trashFile:path recursive:g_recursive];
            }

            if (!success) {
                return EXIT_FAILURE;
            }
        }

        return EXIT_SUCCESS;
    }
}
