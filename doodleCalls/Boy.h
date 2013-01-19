//
//  Boy.h
//  doodleCalls
//
//  Created by Vlad on 13.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Boy: CCNode
{
    CCSprite *boySprite;
}

+ (Boy *) create;

- (void) playBallBoyAnimation;
- (void) playThrowBallBoyAnimation;

@end
