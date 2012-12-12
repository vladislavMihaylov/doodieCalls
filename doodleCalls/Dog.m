//
//  Dog.m
//  doodleCalls
//
//  Created by Vlad on 12.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Dog.h"
#import "GameConfig.h"

@implementation Dog

+ (Dog *) create
{
    Dog *dog = [[[Dog alloc] init] autorelease];
    
    return dog;
}

- (void) dealloc
{
    [super dealloc];
}

- (id) init
{
    if(self = [super init])
    {
        CCSprite *dogSprite = [CCSprite spriteWithFile: @"Icon.png"];
        
        [self addChild: dogSprite];
    }
    
    return self;
}

- (void) walk
{
    NSString *path = [[NSBundle mainBundle] pathForResource: [NSString stringWithFormat: @"level%i", curLevel] ofType: @"plist"];
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];                       // делаем Dictionary из файла plist
    
    NSString *pointsString = [NSString stringWithString: [dict valueForKey: @"path"]];            // берём строку с координатами
    
    NSArray *coordinats = [pointsString componentsSeparatedByString: @"/"];                       // получаем массив с координатами
    
    NSInteger minX = [[coordinats objectAtIndex: 0] integerValue];
    NSInteger maxX = [[coordinats objectAtIndex: (coordinats.count - 2)] integerValue];
    
    NSInteger minY = [[coordinats objectAtIndex: (coordinats.count - 1)] integerValue];
    NSInteger maxY = [[coordinats objectAtIndex: 1] integerValue];
    
    NSInteger movementX;
    NSInteger movementY;
    
    float timeOfAction;
    float delayTime = (arc4random() % 30) / 10;
    
    if(delayTime < 1)
    {
        delayTime = 1;
    }
    
    if([self direction])
    {
        movementX = self.position.x;
        movementY = (arc4random() % (maxY - minY)) + minY;
        
        timeOfAction = movementY / 70;
        
        if(timeOfAction < 1)
        {
            timeOfAction = 1;
        }
    }
    else
    {
        movementX = (arc4random() % (maxX - minX)) + minX;
        movementY = self.position.y;
        
        timeOfAction = movementX / 70;
        
        if(timeOfAction < 1)
        {
            timeOfAction = 1;
        }
    }
    
    [self runAction: [CCSequence actions:
                                    [CCMoveTo actionWithDuration: timeOfAction
                                                        position: ccp(movementX, movementY)],
                                    [CCDelayTime actionWithDuration: delayTime],
                                    [CCCallFunc actionWithTarget: self
                                                        selector: @selector(walk)],
                                    nil
                      ]
    ];
}

- (NSInteger) direction
{
    return arc4random()%2;
}

- (void) poo
{
    
}


@end
