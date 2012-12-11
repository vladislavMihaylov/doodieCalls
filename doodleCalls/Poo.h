//
//  Poo.h
//  doodleCalls
//
//  Created by Vlad on 11.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Poo: CCNode
{
    CCSprite *pooSprite;
    
    BOOL tap;
}

+ (Poo *) create;

- (BOOL) isTapped: (CGPoint) location;

@property (nonatomic, assign) BOOL tap;

@end
