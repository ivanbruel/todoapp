//
//  Task.h
//  Todo
//
//  Created by Ivan Bruel on 23/02/14.
//  Copyright (c) 2014 iOSOnRails. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject

// Public model properties
@property(nonatomic, strong) NSNumber* identifier;
@property(nonatomic, strong) NSString* title;
@property(nonatomic, readwrite) BOOL isDone;

// Custom Initializer
-(id)initWithIdentifier:(NSNumber*)identifier
              withTitle:(NSString*)title
              isDone:(BOOL)isDone;


@end
