//
//  Cat.h
//  doodleCalls
//
//  Created by Vlad on 14.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Cat: CCNode
{
    CCSprite *catSprite;
    
    BOOL isRun;
}

+ (Cat *) create;

- (void) walkFromPoint: (CGPoint) point andDirection: (NSInteger) direction;
- (void) runToPoint: (CGPoint) escapePoint andDirection: (NSInteger) direction;

@property (nonatomic, assign) BOOL isRun;

@end
