//
//  NSData+AES.h
//  AESSample
//
//  Created by HO-27 on 17/10/13.
//  Copyright (c) 2013 hidden brains. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (NSData_AES)
- (NSData*)AES256EncryptWithKey:(NSString*)key;
- (NSData*)AES256DecryptWithKey:(NSString*)key;
@end
