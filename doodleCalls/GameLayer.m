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
#import "Flower.h"
#import "Boy.h"
#import "Ball.h"
#import "Cat.h"

@implementation GameLayer

@synthesize guiLayer;
@synthesize pooArray;
@synthesize objectsArray;

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
    [ballsArray release];
    [objectsArray release];
    [objectsWithDynamicZ release];
}

- (id) initWithLevel: (NSInteger) level
{
    if(self = [super init])
    {
        objectsArray = [[NSMutableArray alloc] init];
        objectsWithDynamicZ = [[NSMutableArray alloc] init];
        
        curLevel = level;
        
        [self loadTextures];
        
        [self setParametersFromLevel: level];
        
        [self startLevel: level];
        
    }
    
    return self;
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
    
    for(Ball *currentBall in ballsArray)
    {
        if([currentBall isTapped: location])
        {
            if(currentBall.status == onField)
            {
                currentBall.status = inAir;
                currentBall.tap = YES;
            }
        }
    }
    
    if( ((fabsf(location.x - flower.position.x)) <= (flower.contentSize.width / 2)) ||
        ((fabsf(location.y - flower.position.y)) <= (flower.contentSize.height / 2)))
    {
        [flower onTaped];
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
            currentPoo.onField = NO;
        }
    }
    
    for(Ball *currentBall in ballsArray)
    {
        if(currentBall.status == inAir && currentBall.tap == YES)
        {
            currentBall.position = location;
        }
    }
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInView: [touch view]];
    location = [[CCDirector sharedDirector] convertToGL: location];
    
    float Ax = gardenBed.contentSize.width / 2;
    float Ay = gardenBed.contentSize.height / 2;
    
    float Bx = fabsf(location.x - gardenBed.position.x);
    float By = fabsf(location.y - gardenBed.position.y);
    
    float Cx = waterPool.contentSize.width / 2;
    float Cy = waterPool.contentSize.height / 2;
    
    float Dx = fabsf(location.x - waterPool.position.x);
    float Dy = fabsf(location.y - waterPool.position.y);
    
    BOOL isRemovePoo = Bx <= Ax && By <= Ay;
    BOOL isRemoveBall = Dx <= Cx && Dy <= Cy;
    
    NSMutableArray *pooForRemove = [[NSMutableArray alloc] init];
    
    if(isRemoveBall)
    {
        for(Ball *currentBall in ballsArray)
        {
            currentBall.position = waterPool.position;
            currentBall.status = inPool;
            currentBall.tap = NO;
            currentBall.visible = NO;
            [boy playBallBoyAnimation];
        }
    }
    else
    {
        for(Ball *currentBall in ballsArray)
        {
            if(currentBall.status == inAir)
            {
                currentBall.status = onField;
                currentBall.tap = NO;
            }
        }
    }
    
    if(isRemovePoo)
    {
        for(Poo *currentPoo in pooArray)
        {
            if(currentPoo.tap == YES)
            {
                [pooForRemove addObject: currentPoo];
                [self removeChild: currentPoo cleanup: YES]; // Дописать, чтобы нельзя было класть какаху на какаху
                [guiLayer updateScoreLabel: score += 100];
                [flower updateFlower];
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
                currentPoo.onField = YES;
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
    [self checkBallCollision];
    [self checkCatAndDogDistance];
    [self setZtoObjects];
}

- (void) setZtoObjects
{
    for(CCNode *currentObject in objectsWithDynamicZ)
    {
        NSInteger z = (320 - currentObject.position.y) / 10;
        [currentObject setZOrder: z];
    }
}

- (void) checkCatAndDogDistance
{
    //CCLOG(@"DogX: %f DogY: %f", dog.position.x, dog.position.y);
    //CCLOG(@"CatX: %f CatY: %f", cat.position.x, cat.position.y);
    
    if( (fabsf(dog.position.x - cat.position.x) < 125) && (fabsf(dog.position.y - cat.position.y) < 125))
    {
        if(cat.isRun == NO && dog.isRun == NO)
        {
            CCLOG(@"CAT RUN!");
            cat.isRun = YES;
            dog.isRun = YES;
            
            [cat stopAllActions];
            [dog stopAllActions];
            
            [self getCoordinatsForCatEscape];
        }
    }
}

- (void) getCoordinatsForCatEscape
{
    [cat runToPoint: ccp(cat.position.x, -100) andDirection: 1];
    [dog runToPoint: ccp(cat.position.x, -100) andDirection: 1];
    
    /*NSInteger differenceX = cat.position.x - dog.position.x;  // пока кошка с собакой убегают только вниз
    NSInteger differenceY = cat.position.y - dog.position.y;
    
    if(differenceX <= 0)
    {
        if(differenceY <= 0)
        {
            [cat runToPoint: ccp(cat.position.x, -100) andDirection: 1];
            [dog runToPoint: ccp(cat.position.x, -100) andDirection: 1];
        }
        else
        {
            [cat runToPoint: ccp(cat.position.x, 420) andDirection: 0];
            [dog runToPoint: ccp(cat.position.x, 420) andDirection: 0];
        }
    }
    else
    {
        if(differenceY <= 0)
        {
            [cat runToPoint: ccp(cat.position.x, -100) andDirection: 1];
            [dog runToPoint: ccp(cat.position.x, -100) andDirection: 1];
        }
        else
        {
            [cat runToPoint: ccp(cat.position.x, 420) andDirection: 0];
            [dog runToPoint: ccp(cat.position.x, 420) andDirection: 0];
        }
    }*/
}

- (void) checkBallCollision
{
    for(Ball *currentBall in ballsArray)
    {
        float Bx = mower.contentSize.width / 2 + currentBall.contentSize.width / 2;
        float By = currentBall.contentSize.height / 2;
        
        float Cx = fabsf(mower.position.x - currentBall.position.x);
        float Cy = fabsf((mower.position.y + 15) - currentBall.position.y);
        
        BOOL status = Cx <= Bx && Cy <= By;
        
        if(currentBall.status == onField)
        {
            if(status)
            {
                currentBall.position = waterPool.position;
                currentBall.status = inPool;
                currentBall.visible = NO;
                
                [boy stopAllActions];
                [boy playBallBoyAnimation];
                
                score -= 100;
                
                if(score <= 0)
                {
                    score = 0;
                }
                
                [guiLayer updateScoreLabel: score];
                [self blink];
            }
        }
    }
}

- (void) checkShitCollision
{
    
    
    NSMutableArray *pooForRemove = [[NSMutableArray alloc] init];
    
    for(Poo *currentPoo in pooArray)
    {
        CCLOG(@"CurrentPooTap %i CurrentPooOnField %i", currentPoo.tap, currentPoo.onField);
        
        float Bx = mower.contentSize.width / 2 + currentPoo.contentSize.width / 2;
        float By = currentPoo.contentSize.height / 2;
        
        float Cx = fabsf(mower.position.x - currentPoo.position.x);
        float Cy = fabsf((mower.position.y + 15) - currentPoo.position.y);

        BOOL status = Cx <= Bx && Cy <= By;
        
        if(currentPoo.onField == YES)
        {
            if(status)
            {
                if(currentPoo.tap == NO)
                {
                    [pooForRemove addObject: currentPoo];
                    [self removeChild: currentPoo cleanup: YES];
                    
                    score -= 100;
                    
                    if(score <= 0)
                    {
                        score = 0;
                    }
                    
                    [guiLayer updateScoreLabel: score];
                    
                    [self blink];
                }
            }
        }
    }
    
    for(Poo *currentPoo in pooForRemove)
    {
        [pooArray removeObject: currentPoo];
    }
    
    [pooForRemove release];
}

- (BOOL) checkWaterPoolcollisionWithPoint: (CGPoint) point
{
    BOOL isCollision = NO;
    
    //CCLOG(@"WaterPoolWidth: %f Height: %f", waterPool.waterPoolSprite.contentSize.width/2, waterPool.waterPoolSprite.contentSize.height/2);
    
    if( (fabsf(point.x - waterPool.position.x) < (waterPool.contentSize.width / 2)) ||
        (fabsf(point.y - waterPool.position.y) < (waterPool.contentSize.height / 2)))
    {
        isCollision = YES;
    }
    
    return isCollision;
}

- (void) addScoreFromFlower
{
    score += 500;
    [guiLayer updateScoreLabel: score];
}

- (void) blink
{
    [blinkLayer runAction:
                        [CCSequence actions:
                                        [CCFadeTo actionWithDuration: 0.05 opacity: 150],
                                        [CCDelayTime actionWithDuration: 0.05],
                                        [CCFadeOut actionWithDuration: 0.05],
                                        [CCDelayTime actionWithDuration: 0.05],
                                        [CCFadeTo actionWithDuration: 0.05 opacity: 150],
                                        [CCDelayTime actionWithDuration: 0.05],
                                        [CCFadeOut actionWithDuration: 0.05],
                                        nil
                        ]
    ];
}

#pragma mark -
#pragma mark start/pause/restart

- (void) startLevel: (NSInteger) level
{
    score = 0;
    
    pooArray = [[NSMutableArray alloc] init];
    ballsArray = [[NSMutableArray alloc] init];
    
    self.isTouchEnabled = YES;
    
    NSArray *coordinats = [self getCoordinatsForLevel: level];
    
    mower = [Mower create];
    mower.gameLayer = self;
    
    [mower moveWithPath: coordinats];
    
    dog = [Dog create];
    dog.position = ccp(240, 160);
    dog.gameLayer = self;
    
    [dog walk];
    
    flower = [Flower create];
    flower.position = gardenBed.position;//ccp(240, 160); //gardenBed.position;
    flower.gameLayer = self;
    
    boy = [Boy create];
    boy.position = waterPool.position;
    
    ball = [Ball create];
    ball.position = boy.position;
    ball.gameLayer = self;
    
    [ballsArray addObject: ball];
    
    cat = [Cat create];
    cat.position = ccp(-100, -100);
    
    
    [self addChild: mower z: zMower];
    [self addChild: dog z: zDog];
    [self addChild: flower z: zFlower];
    [self addChild: boy z: zWaterPool + 1];
    [self addChild: ball z: zWaterPool + 2];
    [self addChild: cat z: zCat];
    
    blinkLayer = [CCLayerColor layerWithColor: ccc4(255, 50, 50, 200)];
    blinkLayer.position = ccp(0, 0);
    [blinkLayer runAction: [CCFadeOut actionWithDuration: 0]];
    [self addChild: blinkLayer z: zMower + 10];
    
    [objectsWithDynamicZ addObject: mower];
    [objectsWithDynamicZ addObject: dog];
    [objectsWithDynamicZ addObject: flower];
    [objectsWithDynamicZ addObject: boy];
    [objectsWithDynamicZ addObject: ball];
    [objectsWithDynamicZ addObject: cat];
    
    [objectsArray addObject: mower];
    [objectsArray addObject: dog];
    [objectsArray addObject: flower];
    [objectsArray addObject: boy];
    [objectsArray addObject: ball];
    [objectsArray addObject: cat];
    [objectsArray addObject: blinkLayer];
    
    //CGPoint catPoint = CGPointMake(240, -100);
    
    //[cat walkFromPoint: catPoint];
    
    [self schedule: @selector(getStartCoordinatsForCat) interval: 15];
    [self scheduleUpdate];
    
    //[self getCoordinatsForBall]; // сюда передаем позицию
    
}

- (void) gameOver
{
    [guiLayer showPauseMenu];
}

- (void) pause
{
    [blinkLayer stopAllActions];
    [blinkLayer runAction: [CCFadeOut actionWithDuration: 0]];
    
    CCArray *arr = [self children];
    for(CCNode *mynode in arr)
    {
        [mynode pauseSchedulerAndActions];
    }
    
    
    [self pauseSchedulerAndActions];

}

- (void) unPause
{
    CCArray *arr = [self children];
    for(CCNode *mynode in arr)
    {
        [mynode resumeSchedulerAndActions];
    }
    
    [self resumeSchedulerAndActions];
}

- (void) restart
{
    
    [self unschedule: @selector(getStartCoordinatsForCat)];
    [self unscheduleUpdate];
    
    for(CCNode *myNode in objectsArray)
    {
        [self removeChild: myNode cleanup: YES];
    }
    
    [objectsArray removeAllObjects];
    [objectsWithDynamicZ removeAllObjects];
    
    score = 0;
    
    [guiLayer updateScoreLabel: score];
    
    [self loadTextures];
    
    [self setParametersFromLevel: curLevel];
    
    [self startLevel: curLevel];
}

#pragma mark -
#pragma mark setObjectsParameters

- (void) getStartCoordinatsForCat
{
    NSArray *coordinatsArray = [self getCoordinatsForLevel: curLevel];
    
    NSInteger minX = [[coordinatsArray objectAtIndex: 0] integerValue];
    NSInteger maxX = [[coordinatsArray objectAtIndex: (coordinatsArray.count - 2)] integerValue];
    
    NSInteger minY = [[coordinatsArray objectAtIndex: (coordinatsArray.count - 1)] integerValue];
    NSInteger maxY = [[coordinatsArray objectAtIndex: 1] integerValue];
    
    NSInteger catDirection = arc4random() % 2;
    
    if(catDirection == 3) // кошка идет снизу вверх
    {
        NSInteger x = (arc4random() % (maxX - minX)) + minX;
        NSInteger y = -100;
        
        CGPoint catStartPoint = CGPointMake(x, y);
        
        if([self checkWaterPoolCollisionWithCatCoordinats: catStartPoint andDirection: catDirection])
        {
            [self getStartCoordinatsForCat];
        }
        else
        {
            [cat walkFromPoint: catStartPoint andDirection: catDirection];
        }
    }
    if(catDirection == 2) // кошка идет cверху вниз
    {
        NSInteger x = (arc4random() % (maxX - minX)) + minX;
        NSInteger y = 420;
        
        CGPoint catStartPoint = CGPointMake(x, y);
        
        if([self checkWaterPoolCollisionWithCatCoordinats: catStartPoint andDirection: catDirection])
        {
            [self getStartCoordinatsForCat];
        }
        else
        {
            [cat walkFromPoint: catStartPoint andDirection: catDirection];
        }
    }
    if(catDirection == 0) // кошка идет слева направо
    {
        NSInteger x = -100;
        NSInteger y = (arc4random() % (maxY - minY)) + minY;
        
        CGPoint catStartPoint = CGPointMake(x, y);
        
        if([self checkWaterPoolCollisionWithCatCoordinats: catStartPoint andDirection: catDirection])
        {
            [self getStartCoordinatsForCat];
        }
        else
        {
            [cat walkFromPoint: catStartPoint andDirection: catDirection];
        }
    }
    if(catDirection == 1) // кошка идет справа налево
    {
        NSInteger x = 580;
        NSInteger y = (arc4random() % (maxY - minY)) + minY;
        
        CGPoint catStartPoint = CGPointMake(x, y);
        
        if([self checkWaterPoolCollisionWithCatCoordinats: catStartPoint andDirection: catDirection])
        {
            [self getStartCoordinatsForCat];
        }
        else
        {
            [cat walkFromPoint: catStartPoint andDirection: catDirection];
        }
    }
}

- (BOOL) checkWaterPoolCollisionWithCatCoordinats: (CGPoint) catPoint andDirection: (NSInteger) direction
{
    BOOL isCollision = NO;

    if(direction == 0 || direction == 1) // кошка идет по вертикали
    {
        if( (catPoint.x <= (waterPool.position.x + waterPool.contentSize.width / 2)) &&
            (catPoint.x >= (waterPool.position.x - waterPool.contentSize.width / 2)) )
        {
            isCollision = YES;
        }
    }
    else
    {
        if( (catPoint.y <= (waterPool.position.y + waterPool.contentSize.height / 2)) &&
            (catPoint.y >= (waterPool.position.y - waterPool.contentSize.height / 2)) )
        {
            isCollision = YES;
        }
    }
    
    return isCollision;
}

- (void) getCoordinatsForBall
{
    NSArray *coordinatsArray = [self getCoordinatsForLevel: curLevel];
    
    NSInteger minX = [[coordinatsArray objectAtIndex: 0] integerValue];
    NSInteger maxX = [[coordinatsArray objectAtIndex: (coordinatsArray.count - 2)] integerValue];
    
    NSInteger minY = [[coordinatsArray objectAtIndex: (coordinatsArray.count - 1)] integerValue];
    NSInteger maxY = [[coordinatsArray objectAtIndex: 1] integerValue];
    
    NSInteger movementX;
    NSInteger movementY;
    
    movementX = (arc4random() % (maxX - minX)) + minX;
    NSInteger countOfPointsY = (maxY - minY) / 25;
    movementY = (25 * ((arc4random() % countOfPointsY) + 1)) + 12.5;
    
    CGPoint dogPoint = CGPointMake(movementX, movementY);
    
    if([self checkWaterPoolcollisionWithPoint: dogPoint]) 
    {
        [self getCoordinatsForBall];
    }
    else
    {
        [ball flyToPosition: dogPoint];
        [boy playThrowBallBoyAnimation];
    }
}

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
        
        [objectsArray addObject: gardenBed];
    }
    else if(ID == 1)
    {
        Kennel *kennel = [Kennel create];
        kennel.position = position;
        [self addChild: kennel z: zKennel];
        
        [objectsArray addObject: kennel];
        [objectsWithDynamicZ addObject: kennel];
    }
    else if(ID == 2)
    {
        waterPool = [WaterPool create];
        waterPool.position = position;
        [self addChild: waterPool z: zWaterPool];
        
        [objectsArray addObject: waterPool];
    }
    else if(ID == 3)
    {
        //Rock *rock = [Rock create];
        //rock.position = position;
        //[self addChild: rock];
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
    
    [objectsArray addObject: batchNode];
    [objectsArray addObject: gameBatch];
    
    CCSprite *backgroundSprite = [CCSprite spriteWithSpriteFrameName: @"BG.png"];
    backgroundSprite.position = ccp(240, 160);
    [batchNode addChild: backgroundSprite];
    
    scoreBoardSprite = [CCSprite spriteWithSpriteFrameName: @"scoreboard.png"];
    scoreBoardSprite.position = ccp(75, 300);
    [gameBatch addChild: scoreBoardSprite z: zScoreBoard];
}


@end
