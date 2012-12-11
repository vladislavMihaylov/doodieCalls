//
//  GardenBed.h
//  doodleCalls
//
//  Created by Vlad on 10.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GardenBed : CCNode
{
    CCSprite *gardenBedSprite;
}

+ (GardenBed *) create;

@property (nonatomic, assign) CCSprite *gardenBedSprite;

@end
