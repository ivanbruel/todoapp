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
@property(nonatomic, retain) NSNumber* identifier;
@property(nonatomic, retain) NSString* title;

// Custom Initializer
-(id)initWithIdentifier:(NSNumber*)identifier withTitle:(NSString*)title withState:(NSNumber*)state;

// Model logic
-(BOOL)isDone;
-(void)setIsDone:(BOOL)isDone;

@end
