#import <Foundation/Foundation.h>

/**
Class to delete files 'safely' by moving them into the current users Trash
folder.
*/
@interface FileDeleter : NSObject {

}

/**
Moves a single file into the current users trash folder. Does not support
directories.
@param path Full path to the file to delete
*/
- (BOOL) deleteFile: (NSString*) path;

@end
