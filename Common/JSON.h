//
//  JSON1.h
//  NewsBrowser
//
//  Created by Ethan on 13-11-17.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (JSON)
- (id) JSONValue;
@end

@interface NSData (JSON)
- (id) JSONValue;
@end

@interface NSObject (JSON)
- (NSString *)JSONRepresentation;
@end