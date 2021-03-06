#include "TrashManager.h"
#include "Log.h"
#include "DSStore.h"

@implementation TrashManager {
    NSFileManager* _manager;
    NSURL* _baseURL;
}

- (id) init {
    self = [super init];
    if (self) {
        _manager = [NSFileManager defaultManager];

        NSString* basePath = [_manager currentDirectoryPath];
        NSString* encodedPath = 
            [basePath stringByAddingPercentEncodingWithAllowedCharacters:[
                NSCharacterSet URLQueryAllowedCharacterSet]];
        _baseURL = [NSURL fileURLWithPath:encodedPath];

        DEBUG(@"Initialized TrashManager with url [%@]", basePath);
    }

    return self;
}

- (BOOL) getTrashContents: (NSArray**)contents {
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

    NSArray *raw = [_manager contentsOfDirectoryAtURL:url
        includingPropertiesForKeys:nil
        options: 0 
        error: &error];

    if (!raw) {
        ERROR(@"Error listing Trash contents [%@]",
            error.localizedDescription);
        return NO;
    }
    
    // Copy the files we care about into a new list to be returned. This is 
    // just so we can filter out anything we don't want to return. 
    NSMutableArray *clean = [NSMutableArray new];
    for (NSString *file in raw) {
        DEBUG(@"Trashed file: %@", file);
        // We need to remove .DS_Store when listing the trash as this file
        // is 'special'. It contains all the info of where trashed files came
        // from!
        if (![[file lastPathComponent] isEqualToString: @".DS_Store"]) {
            [clean addObject:file];
        }
    }

    *contents = clean;

    return YES;
}

- (BOOL) listTrash {
    NSArray* contents = nil;
    if (![self getTrashContents:&contents]) {
        return NO;
    }

    for (NSURL* url in contents) {
        printf("%s\n", url.lastPathComponent.UTF8String);
    }

    return YES;
}

- (BOOL) restoreFile:(NSString*) path {
    NSError* error = nil;
    NSURL *trashUrl = [_manager URLForDirectory:NSTrashDirectory
        inDomain:NSUserDomainMask
        appropriateForURL:nil
        create:NO
        error:&error];

    if (!trashUrl) {
        ERROR(@"Error getting Trash URL [%@]", [error localizedDescription]);
        return NO;
    }

    // We first need to work out where the file came from. This information
    // is stored in the .DS_Store inside the Trash. Load this and parse its
    // items.
    NSString* dsStorePath = [NSString stringWithFormat: @"%@/.DS_Store",
        trashUrl.path];
    NSData* data = [_manager contentsAtPath:dsStorePath];
    DSStore* dsStore = [[DSStore alloc] initWithData:data];
    if (![dsStore parseWithError:&error]) {
        ERROR(@"Error parsing .DS_Store [%@]", error.localizedDescription);
        return NO;
    }

    // Find the existing DSItems with the put-back name attribute (ptbN) and
    // put-back location (ptbL).
    NSString* putBackName = nil;
    NSString* putBackLocation = nil;
    for (DSSection* s in dsStore.sections) {
        for (DSItem* i in s.items) {
            if (![i.fileName isEqualToString:path] || i.type != 'ustr') {
                continue;
            }

            if (i.attr == 'ptbN') {
                putBackName = (NSString*) i.value;
            } else if (i.attr == 'ptbL') {
                putBackLocation = (NSString*) i.value;
            }

            // If we have both stop iterating
            if (putBackName && putBackLocation) {
                goto breakbreak;
            }
        }
    }

    breakbreak:
    if (!putBackName || !putBackLocation) {
        ERROR(@"Error finding path [%@] in .DS_Store", path);
        return NO;
    }

    // Move the trashFile to its original location.
    NSString* fullPath = [NSString stringWithFormat:@"%@/%@",
        trashUrl.path,
        path];
    NSString* destPath = [NSString stringWithFormat:@"/%@%@",
        putBackLocation,
        putBackName];

    if (![_manager moveItemAtPath:fullPath toPath:destPath error:&error]) {
        ERROR(@"Error restoring file [%@]", error.localizedDescription);
        return NO;
    }

    return YES;
}

- (BOOL) trashFile:(NSString*) path recursive:(BOOL) recursive {
    NSString* encodedPath = 
        [path stringByAddingPercentEncodingWithAllowedCharacters:[
            NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url;
    if ([encodedPath hasPrefix: @"/"]) {
        url = [NSURL fileURLWithPath:encodedPath];
    } else {
        url = [NSURL URLWithString:encodedPath relativeToURL:_baseURL];
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

- (BOOL) emptyTrash {
    NSArray* contents = nil;
    if (![self getTrashContents:&contents]) {
        return NO;
    }

    for (NSURL* file in contents) {
        if ([self restoreFile:file.lastPathComponent]) {
            DEBUG(@"Put-back file [%@]", file.lastPathComponent);
        } else {
            ERROR(@"Could not put-back file [%@]", file.lastPathComponent);
        }
    }

    return YES;
}
@end
