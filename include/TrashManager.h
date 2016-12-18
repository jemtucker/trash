#include <Foundation/Foundation.h>

@interface TrashManager : NSObject {

}

/**
List the conents of the current users Trash directory.
@return TRUE if successful
*/
- (BOOL) listTrash;

/**
Restore a file from the current users Trash directory.
@param path Full path to the file to restore
@return TRUE if successful
*/
- (BOOL) restoreFile:(NSString*) path;

/**
Delete a file from disk safely by sending to the Trash.
@param path Full path to the file to delete
@param recursive Enable recursive deletion
@return TRUE if successful
*/
- (BOOL) trashFile:(NSString*) path recursive:(BOOL) recursive;

@end
