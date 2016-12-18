#include "TrashManager.h"
#include "Log.h"

@implementation TrashManager {
    NSFileManager* _manager;
    NSURL* _baseURL;
}

- (id) init {
    self = [super init];
    if (self) {
        _manager = [NSFileManager defaultManager];

        NSString* basePath = [_manager currentDirectoryPath];
        _baseURL = [NSURL fileURLWithPath:basePath];

        DEBUG(@"Initialized TrashManager with url [%@]", basePath);
    }

    return self;
}

- (BOOL) listTrash {
    NSError* error = nil;
    NSURL *url = [_manager URLForDirectory:NSTrashDirectory
        inDomain:NSUserDomainMask
        appropriateForURL:nil
        create:NO
        error:&error];

    if (!url) {
        ERROR(@"Error getting Trash URL [%@]", [error localizedDescription]);
        return NO;
    }

    NSArray *contents = [_manager contentsOfDirectoryAtURL:url
        includingPropertiesForKeys:nil
        options:NSDirectoryEnumerationSkipsHiddenFiles
        error: &error];

    if (!contents) {
        ERROR(@"Error listing Trash contents [%@]",
            [error localizedDescription]);
        return NO;
    }

    for (NSURL* url in contents) {
        printf("%s\n", url.path.UTF8String);
    }

    return YES;
}

- (BOOL) trashFile:(NSString*) path recursive:(BOOL) recursive {
    if ([path hasPrefix: @"."]) {
        ERROR(@"Unsupported path");
        return NO;
    }

    NSURL *url;
    if ([path hasPrefix: @"/"]) {
        url = [NSURL fileURLWithPath:path];
    } else {
        url = [NSURL URLWithString:path relativeToURL:_baseURL];
    }

    DEBUG(@"Built URL [%@]", [url absoluteURL]);

    // Check the path exists before doing anything else
    BOOL isDirectory = NO;
    if (![_manager fileExistsAtPath:path isDirectory:&isDirectory]) {
        ERROR(@"File [%@] does not exist", path);
        return NO;
    }

    // Check the path is not a directroy
    if (isDirectory && !recursive) {
        ERROR(@"File [%@] is a directory", path);
        return NO;
    }

    // Safe to delete/move to trash
    if ([_manager trashItemAtURL:url resultingItemURL:nil error:nil]) {
        DEBUG(@"Deleted file [%@]", path);
        return YES;
    } else {
        ERROR(@"Could not delete file [%@]", path);
        return NO;
    }
}

@end