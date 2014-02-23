//
//  Task.m
//  Todo
//
//  Created by Ivan Bruel on 23/02/14.
//  Copyright (c) 2014 iOSOnRails. All rights reserved.
//

#import "Task.h"

@implementation Task

-(id)initWithIdentifier:(NSNumber *)identifier withTitle:(NSString *)title isDone:(BOOL)isDone{
    if ((self = [super init]))
    {
        self.identifier = identifier;
        self.title = title;
        self.isDone = isDone;
    }
    return self;
}

@end
