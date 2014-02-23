//
//  Task.m
//  Todo
//
//  Created by Ivan Bruel on 23/02/14.
//  Copyright (c) 2014 iOSOnRails. All rights reserved.
//

#import "Task.h"

// Private Model Properties
@interface Task ()

@property(nonatomic, retain) NSNumber* state;

@end

@implementation Task

-(id)initWithIdentifier:(NSNumber *)identifier withTitle:(NSString *)title withState:(NSNumber *)state{
    if ((self = [super init]))
    {
        self.identifier = identifier;
        self.title = title;
        self.state = state;
    }
    return self;
}

-(BOOL)isDone{
    return [self.state boolValue];
}
-(void)setIsDone:(BOOL)isDone{
    self.state = [NSNumber numberWithBool:isDone];
}

@end
