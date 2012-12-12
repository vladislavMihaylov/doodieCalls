//
//  GameLayer.m
//  doodleCalls
//
//  Created by Vlad on 04.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#import "GameConfig.h"
#import "Mower.h"
#import "GardenBed.h"
#import "Kennel.h"
#import "WaterPool.h"
#import "Rock.h"
#import "Poo.h"
#import "Dog.h"


@implementation GameLayer

@synthesize guiLayer;

+(CCScene *) sceneWithLevelNumber: (NSInteger) numberOfLevel
{
    CCScene *scene = [CCScene node];
    
    GameLayer *layer = [[[GameLayer alloc] initWithLevel: numberOfLevel] autorelease];
    
    GuiLayer *gui = [GuiLayer node];

    [scene addChild: layer];
    [scene addChild: gui];
    
    layer.guiLayer = gui;
    gui.gameLayer = layer;
    
    return scene;
}

- (void) dealloc
{
    [super dealloc];
    [pooArray release];
}

- (id) initWithLevel: (NSInteger) level
{
    if(self = [super init])
    {
        curLevel = level;
        
        [self loadTextures];
        
        [self startLevel: level];
        
        [self setParametersFromLevel: level];
        
        
        dog = [[[Dog alloc] init] autorelease];
        
        dog.position = ccp(240, 160);
        
        [self addChild: dog z: zDog];
        
        [dog walk];
        
        [self schedule: @selector(addPoo) interval: 2];
    }
    
    return self;
}

- (void) addPoo
{
    Poo *poo = [[[Poo alloc] init] autorelease];
    poo.position = dog.position;
    
    [pooArray addObject: poo];
    
    [self addChild: poo z: zPoo];
}

#pragma mark -
#pragma mark Touches

- (void) registerWithTouchDispatcher
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate: self priority: 0 swallowsTouches: YES];
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInView: [touch view]];
    location = [[CCDirector sharedDirector] convertToGL: location];
    
    for(Poo *currentPoo in pooArray)
    {
        //CCLOG(@"curPoo.position = %f, %f", currentPoo.position.x, currentPoo.position.y);
        
        if([currentPoo isTapped: location])
        {
            currentPoo.tap = YES;
        }
    }
    
    return YES;
}

- (void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInView: [touch view]];
    location = [[CCDirector sharedDirector] convertToGL: location];
    
    for(Poo *currentPoo in pooArray)
    {
        if(currentPoo.tap == YES)
        {
            currentPoo.position = location;
        }
    }
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInView: [touch view]];
    location = [[CCDirector sharedDirector] convertToGL: location];
    
    float Ax = gardenBed.gardenBedSprite.contentSize.width / 2;
    float Ay = gardenBed.gardenBedSprite.contentSize.height / 2;
    
    float Bx = fabsf(location.x - gardenBed.position.x);
    float By = fabsf(location.y - gardenBed.position.y);
    
    BOOL isRemovePoo = Bx <= Ax && By <= Ay;
    
    NSMutableArray *pooForRemove = [[NSMutableArray alloc] init];
    
    if(isRemovePoo)
    {
        for(Poo *currentPoo in pooArray)
        {
            if(currentPoo.tap == YES)
            {
                [pooForRemove addObject: currentPoo];
                [self removeChild: currentPoo cleanup: YES]; // Дописать, чтобы нельзя было класть какаху на какаху
                [guiLayer updateScoreLabel: score += 100];
            }
        }
    }
    else
    {
        for(Poo *currentPoo in pooArray)
        {
            if(currentPoo.tap == YES)
            {
                currentPoo.tap = NO;
            }
        }
    }
    
    for(Poo *currentPooForRemove in pooForRemove)
    {
        [pooArray removeObject: currentPooForRemove];
    }
    
    [pooForRemove release];
    
}

#pragma mark -
#pragma mark Update

- (void) update: (ccTime) dt
{
    [self checkShitCollision];
}

- (void) checkShitCollision
{
    NSMutableArray *pooForRemove = [[NSMutableArray alloc] init];
    
    for(Poo *currentPoo in pooArray)
    {
        float Bx = mower.sprite.contentSize.width / 2 + currentPoo.pooSprite.contentSize.width / 2;
        float By = currentPoo.pooSprite.contentSize.height / 2;
        
        float Cx = fabsf(mower.position.x - currentPoo.position.x);
        float Cy = fabsf((mower.position.y + 30) - currentPoo.position.y);

        BOOL status = Cx <= Bx && Cy <= By;
        
        if(currentPoo.collised == NO)
        {
            if(status)
            {
                currentPoo.collised = YES;
                
                [pooForRemove addObject: currentPoo];
                [self removeChild: currentPoo cleanup: YES];
                
                score -= 100;
                
                if(score <= 0)
                {
                    score = 0;
                }
                
                [guiLayer updateScoreLabel: score];
            }
        }
       
    }
    
    for(Poo *currentPoo in pooForRemove)
    {
        [pooArray removeObject: currentPoo];
    }
    
    [pooForRemove release];
}

#pragma mark -
#pragma mark start/pause/restart

- (void) startLevel: (NSInteger) level
{
    score = 0;
    
    pooArray = [[NSMutableArray alloc] init];
    
    self.isTouchEnabled = YES;
    
    NSArray *coordinats = [self getCoordinatsForLevel: level];
    
    mower = [Mower create];
    
    [self addChild: mower z: zMower];
    
    mower.gameLayer = self;
    
    [mower moveWithPath: coordinats];
    
    
    
    [self scheduleUpdate];
}

- (void) pause
{
    
}

- (void) restart
{
    
}

#pragma mark -
#pragma mark setObjectsParameters

- (void) setParametersFromLevel: (NSInteger) level
{
    NSString *allObjects = [[NSBundle mainBundle] pathForResource: [NSString stringWithFormat: @"level%i", level] ofType: @"plist"];
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: allObjects];
    
    NSDictionary *onlyObjects = [NSDictionary dictionaryWithDictionary: [dict valueForKey: @"objects"]];
    
    NSArray *allKeysFromObjects = [onlyObjects allKeys];
    
    
    for(int i = 0; i < onlyObjects.count; i++)
    {
        NSString *key = [NSString stringWithFormat: @"%@", [allKeysFromObjects objectAtIndex: i]];
        
        NSDictionary *curObject = [onlyObjects valueForKey: key];
        
        NSInteger identificator = [[curObject valueForKey: @"id"] integerValue];
        
        NSString *position = [curObject valueForKey: @"position"];
        
        NSArray *coordinats = [position componentsSeparatedByString: @"/"];         // получаем массив с координатами
        
        NSInteger posX = [[coordinats objectAtIndex: 0] floatValue];
        NSInteger posY = [[coordinats objectAtIndex: 1] floatValue];
        
        CGPoint objectPosition = CGPointMake(posX, posY);
        
        [self createObjectWithID: identificator andPosition: objectPosition];
        
    }
}

- (void) createObjectWithID: (NSInteger) ID andPosition: (CGPoint) position // Вместо позиции передаем дикшинери
{
    if(ID == 0)
    {
        gardenBed = [GardenBed create];
        gardenBed.position = position;
        [self addChild: gardenBed z: zGardenBed];
    }
    else if(ID == 1)
    {
        Kennel *kennel = [Kennel create];
        kennel.position = position;
        [self addChild: kennel z: zKennel];
    }
    else if(ID == 2)
    {
        WaterPool *waterPool = [WaterPool create];
        waterPool.position = position;
        [self addChild: waterPool z: zWaterPool];
    }
    else if(ID == 3)
    {
        Rock *rock = [Rock create];
        rock.position = position;
        [self addChild: rock];
    }
}

#pragma mark -
#pragma mark other functions

- (void) addGrassToPoint: (CGPoint) position
{
    CCSprite *grass = [CCSprite spriteWithSpriteFrameName: @"grass0.png"];
    grass.position = position;
    grass.anchorPoint = ccp(0.5, 0);
    grass.scale = 1.3;
    [gameBatch addChild: grass z: zGrass];
}

- (NSArray *) getCoordinatsForLevel: (NSInteger) level // Парсим plist и получаем координаты точек
{
    NSString *currentLevel = [NSString stringWithFormat: @"%i", level];
    
    NSString *path = [[NSBundle mainBundle] pathForResource: [NSString stringWithFormat: @"level%@", currentLevel] ofType: @"plist"];
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];                       // делаем Dictionary из файла plist
    
    NSString *pointsString = [NSString stringWithString: [dict valueForKey: @"path"]];            // берём строку с координатами
    
    NSArray *coordinats = [pointsString componentsSeparatedByString: @"/"];                       // получаем массив с координатами
    
    return coordinats;
}

- (void) loadTextures
{
    gameBatch = [CCSpriteBatchNode batchNodeWithFile: @"game_atlas.png"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"game_atlas.plist"];
    
    batchNode = [CCSpriteBatchNode batchNodeWithFile: @"bg_atlas.png"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"bg_atlas.plist"];
    
    [self addChild: batchNode];
    [self addChild: gameBatch];
    
    CCSprite *backgroundSprite = [CCSprite spriteWithSpriteFrameName: @"BG.png"];
    backgroundSprite.position = ccp(240, 160);
    [batchNode addChild: backgroundSprite];
    
    scoreBoardSprite = [CCSprite spriteWithSpriteFrameName: @"scoreboard.png"];
    scoreBoardSprite.position = ccp(75, 300);
    [gameBatch addChild: scoreBoardSprite];
}


@end
