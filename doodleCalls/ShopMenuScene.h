//
//  ShopMenuScene.h
//  doodleCalls
//
//  Created by Vlad on 05.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ShopMenuScene: CCLayer
{
    CCArray *items;
    
    CCLabelTTF *moneyLabel;
    
    NSString *combination;
    
    NSMutableArray *valuesArray;
}

@end
