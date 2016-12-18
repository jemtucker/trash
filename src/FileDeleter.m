#include "FileDeleter.h"
#include "Log.h"

@implementation FileDeleter {
    NSFileManager* _manager;
    NSURL* _baseURL;
}

- (id) init {
    self = [super init];
    if (self) {
        _manager = [NSFileManager defaultManager];

        NSString* basePath = [_manager currentDirectoryPath];
        _baseURL = [NSURL fileURLWithPath: basePath];

        DEBUG(@"Initialized with url [%@]", basePath);
    }

    return self;
}

- (BOOL) deleteFile:(NSString*) path {
    if ([path hasPrefix: @"."]) {
        ERROR(@"Unsupported path");
        return NO;
    }

    NSURL *url;
    if ([path hasPrefix: @"/"]) {
        url = [NSURL fileURLWithPath: path];
    } else {
        url = [NSURL URLWithString: path relativeToURL: _baseURL];
    }

    DEBUG(@"Built URL [%@]", [url absoluteURL]);

    // Check the path exists before doing anything else
    BOOL isDirectory = NO;
    if (![_manager fileExistsAtPath: path isDirectory: &isDirectory]) {
        ERROR(@"File [%@] does not exist", path);
        return NO;
    }

    // Check the path is not a directroy
    if (isDirectory) {
        ERROR(@"File [%@] is a directory", path);
        return NO;
    }

    // Safe to delete/move to trash
    if ([_manager trashItemAtURL: url resultingItemURL: nil error: nil]) {
        DEBUG(@"Deleted file [%@]", path);
        return YES;
    } else {
        ERROR(@"Could not delete file [%@]", path);
        return NO;
    }
}

@end
