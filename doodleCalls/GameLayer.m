//
//  GameLayer.m
//  doodleCalls
//
//  Created by Vlad on 04.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#import "GameConfig.h"
#import "Settings.h"

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
    
    GuiLayer *gui = [[[GuiLayer alloc] initWithLevel: numberOfLevel] autorelease];;

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
    [objectsArray release];
    [objectsWithDynamicZ release];
}

- (id) initWithLevel: (NSInteger) level
{
    if(self = [super init])
    {
        objectsArray = [[NSMutableArray alloc] init];           // Массив, содержащий все объекты уровня
        objectsWithDynamicZ = [[NSMutableArray alloc] init];    // Содержит объекты, которым нужно менять z-индекс
        
        curLevel = level;                                       // Номер текущего уровня
        
        [self loadTextures];                                    // Загружаем текстуры
        
        [self setParametersFromLevel: level];                   // Устанавливаем необходимые для текущего уровня параметры
        
        [self startLevel: level];                               // Начинаем уровень
        
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
    
    for(Poo *currentPoo in pooArray)                     // Пробегаемся по масиву какашек
    {
        if([currentPoo isTapped: location])              // Если тап произошел на какашке
        {
            currentPoo.tap = YES;                        // она помечается как "нажатая"
        }
    }
    
    
    if([ball isTapped: location])             // Если тап произошел на мячике
    {
        if(ball.status == onField)            // Если при этом он находится на поле
        {
            ball.status = inAir;              // Меняем статус на "в воздухе"
            ball.tap = YES;                   // Помечаем его "нажатым"
        }
    }
    
    
    if( ((fabsf(location.x - flower.position.x)) <= (flower.contentSize.width / 2)) ||
        ((fabsf(location.y - flower.position.y)) <= (flower.contentSize.height / 2)))     // Если тап был на цветочной грядке
    {
        [flower onTaped];                                                                 // Проверяем цветок на созревание 
    }
    
    return YES;
}

- (void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInView: [touch view]];
    location = [[CCDirector sharedDirector] convertToGL: location];
    
    for(Poo *currentPoo in pooArray)
    {
        if(currentPoo.tap == YES)                                       // если в массиве есть тапнутая какаха
        {
            currentPoo.position = location;                             // перемещаем её
            currentPoo.onField = NO;                                    // помечаем, что она не на земле (?)
        }
    }

    if(ball.status == inAir && ball.tap == YES)       // Если тапнутый мяч в воздухе
    {
        ball.position = location;                            // перемещаем его
    }
    
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInView: [touch view]];
    location = [[CCDirector sharedDirector] convertToGL: location];
    
    NSMutableArray *pooForRemove = [[NSMutableArray alloc] init];       // Массив содержит в себе какахи, которые надо удалить
    
    float Ax = gardenBed.contentSize.width / 2;                         // половина ширины грядки
    float Ay = gardenBed.contentSize.height / 2;                        // половина высоты грядки
    
    float Bx = fabsf(location.x - gardenBed.position.x);                // расстояние от точки конца тапа до центра грядки по оси Х
    float By = fabsf(location.y - gardenBed.position.y);                // расстояние от точки конца тапа до центра грядки по оси Y
    
    BOOL isRemovePoo = Bx <= Ax && By <= Ay;                            // YES, если координаты пересекаются. NO, если не пересекаются
    
    if(isRemovePoo)                                                     // если какаха над грядкой
    {
        for(Poo *currentPoo in pooArray)
        {
            if(currentPoo.tap == YES)                                   // если это была какаха, которую тапал игрок
            {
                [pooForRemove addObject: currentPoo];                   // какаха отправляется в массив для удаления
                [self removeChild: currentPoo cleanup: YES];            // удаляем какаху из селфа
                [guiLayer updateScoreLabel: score += kScore];           // даем игроку 5 очков
                [flower updateFlower];                                  // апдейтим левел у цветка
            }
        }
    }
    else                                                                // если какаха не над грядкой
    {
        for(Poo *currentPoo in pooArray)
        {
            if(currentPoo.tap == YES)                                   // если какаха была тапнута игроком
            {
                currentPoo.tap = NO;                                    // пометить её как не тапнутая
                currentPoo.onField = YES;                               // поместить её на поле
            }
        }
    }
    
    for(Poo *currentPooForRemove in pooForRemove)                       // 
    {
        [pooArray removeObject: currentPooForRemove];                   // Удаляем из массива какашек ту какаху, которая была над грядкой
    }
    
    [pooForRemove release];                                             // Удаляем наш временный
    
    /////////////////////////////////// далее проверяем мячики ////////////////////////////////////
    if(ball.tap == YES)
    {
        [waterPool checkCollisionWithPoint: ball];
    }
}


- (void) returnBall: (Ball *) curBall ToPool: (WaterPool *) pool
{
    curBall.position = pool.position;            // переносим мячик точно в центр басика
    curBall.status = inPool;                                 // меняем статус мячика на "в бассейне"
    curBall.tap = NO;                                        // помечаем его нетронутым
    curBall.visible = NO;                                    // делаем его невидимым
    [boy stopAllActions];
    [boy playBallBoyAnimation];                                  // Мальчик проигрывает анимацию игры с мячом
    curBall.ballTime = 0;
    score += kScore;
    [guiLayer updateScoreLabel: score];
    [self schedule: @selector(throwBall) interval: 2];
}

- (void) returnBallToField: (Ball *) curBall
{
    curBall.status = onField;                            // меняем статус на "на поле"
    curBall.tap = NO;
}

#pragma mark -
#pragma mark Collisions

- (void) checkBallCollision
{
    float Bx;
    float By;
    
    float Cx;
    float Cy;
    
    if(mower.direction == right)
    {
        Bx = mower.contentSize.width / 2 - 15 + ball.contentSize.width / 2;
        By = ball.contentSize.height / 2;
        
        Cx = fabsf(mower.position.x + 15 - ball.position.x);
        Cy = fabsf((mower.position.y + 15) - ball.position.y);
    }
    if(mower.direction == left)
    {
        Bx = mower.contentSize.width / 2 - 15 + ball.contentSize.width / 2;
        By = ball.contentSize.height / 2;
        
        Cx = fabsf(mower.position.x - 15 - ball.position.x);
        Cy = fabsf((mower.position.y + 15) - ball.position.y);
    }
    if(mower.direction == up)
    {
        Bx = mower.contentSize.width / 2 - 10 + ball.contentSize.width / 2;
        By = ball.contentSize.height / 2;
        
        Cx = fabsf(mower.position.x - ball.position.x);
        Cy = fabsf((mower.position.y + mower.contentSize.height) - ball.position.y);
    }
    if(mower.direction == down)
    {
        Bx = mower.contentSize.width / 2 - 10 + ball.contentSize.width / 2;
        By = ball.contentSize.height / 2;
        
        Cx = fabsf(mower.position.x - ball.position.x);
        Cy = fabsf((mower.position.y) - ball.position.y);
    }
    
    BOOL status = Cx <= Bx && Cy <= By;
    
    if(ball.status == onField)
    {
        if(status)
        {
            if(ball.tag == waterPool.tag)
            {
                ball.position = waterPool.position;
                ball.status = inPool;
                ball.ballTime = 0;
                ball.visible = NO;
                
                [boy stopAllActions];
                [boy playBallBoyAnimation];
                
                score -= kScore * 2;
                
                if(score <= 0)
                {
                    score = 0;
                }
                
                [self schedule: @selector(throwBall) interval: 2];
                
                [guiLayer removeHeart];
                
                
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
        float Bx;
        float By;
        
        float Cx;
        float Cy;
        
        if(mower.direction == right)
        {
            Bx = mower.contentSize.width / 2 - 15 + currentPoo.contentSize.width / 2;
            By = currentPoo.contentSize.height / 2;
            
            Cx = fabsf(mower.position.x + 15 - currentPoo.position.x);
            Cy = fabsf((mower.position.y + 15) - currentPoo.position.y);
        }
        if(mower.direction == left)
        {
            Bx = mower.contentSize.width / 2 - 15 + currentPoo.contentSize.width / 2;
            By = currentPoo.contentSize.height / 2;
            
            Cx = fabsf(mower.position.x - 15 - currentPoo.position.x);
            Cy = fabsf((mower.position.y + 15) - currentPoo.position.y);
        }
        if(mower.direction == up)
        {
            Bx = mower.contentSize.width / 2 - 10 + currentPoo.contentSize.width / 2;
            By = currentPoo.contentSize.height / 2;
            
            Cx = fabsf(mower.position.x - currentPoo.position.x);
            Cy = fabsf((mower.position.y + mower.contentSize.height) - currentPoo.position.y);
        }
        if(mower.direction == down)
        {
            Bx = mower.contentSize.width / 2 - 10 + currentPoo.contentSize.width / 2;
            By = currentPoo.contentSize.height / 2;
            
            Cx = fabsf(mower.position.x - currentPoo.position.x);
            Cy = fabsf((mower.position.y) - currentPoo.position.y);
        }
        
        BOOL status = Cx <= Bx && Cy <= By;
        
        if(currentPoo.onField == YES)
        {
            if(status)
            {
                if(currentPoo.tap == NO)
                {
                    [pooForRemove addObject: currentPoo];
                    [self removeChild: currentPoo cleanup: YES];
                    
                    score -= kScore * 2;
                    
                    if(score <= 0)
                    {
                        score = 0;
                    }
                    
                    [guiLayer removeHeart];
                    
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
    
    if( (fabsf(point.x - waterPool.position.x) < (waterPool.contentSize.width / 2)) &&
       (fabsf(point.y - waterPool.position.y) < (waterPool.contentSize.height / 2)))
    {
        isCollision = YES;
    }
    
    return isCollision;
}

- (BOOL) checkWaterPoolCollisionWithCatCoordinats: (CGPoint) catPoint
{
    BOOL isCollision = NO;
    
    NSInteger restrictMax = (waterPool.position.y + waterPool.contentSize.height / 2);
    NSInteger restrictMin = (waterPool.position.y - waterPool.contentSize.height / 2);
    
    if( ((catPoint.y <= restrictMax) && (catPoint.y > restrictMin)) )
    {
        isCollision = YES;
    }
    
    return isCollision;
}

#pragma mark -
#pragma mark Update

- (void) update: (ccTime) dt
{
    [self checkShitCollision];
    [self checkBallCollision];
    [self checkCatAndDogDistance];
    [self setZtoObjects];
    [self runTimerForBall: dt];
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
    if( (fabsf(dog.position.x - cat.position.x) < 100) && (fabsf(dog.position.y - cat.position.y) < 100))
    {
        if(cat.isRun == NO && dog.isRun == NO)
        {
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
    CGPoint returnPointForDog = CGPointMake(dog.position.x, dog.position.y);
    
    if( cat.position.x <= dog.position.x )
    {
        [cat runToPoint: ccp(-100, cat.position.y) andDirection: 0];
        [dog runToPoint: ccp(-100, cat.position.y) andDirection: 0 AndReturnPoint: returnPointForDog];
    }
    if( cat.position.x > dog.position.x )
    {
        [cat runToPoint: ccp(580, cat.position.y) andDirection: 2];
        [dog runToPoint: ccp(580, cat.position.y) andDirection: 2 AndReturnPoint: returnPointForDog];
    }
}

- (void) runTimerForBall: (float) dt
{
    if(ball.status == onField)
    {
        ball.ballTime += dt;
        
        if(ball.ballTime >= 3)
        {
            if(ball.tag == waterPool.tag)
            {
                ball.position = waterPool.position;
                ball.status = inPool;
                ball.visible = NO;
                
                [boy stopAllActions];
                [boy playBallBoyAnimation];
                
                score -= kScore * 2;
                ball.ballTime = 0;
                
                [self schedule: @selector(throwBall) interval: 2];
                
                if(score <= 0)
                {
                    score = 0;
                }
                
                [guiLayer removeHeart];
                
                //[self schedule: @selector(getNumberForBall) interval: 1];
                [guiLayer updateScoreLabel: score];
                [self blink];
                CCLOG(@"OOPS!");
            }
            
        }
    }
}

- (void) addScoreFromFlower
{
    score += kScore;
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
    [self unschedule: @selector(runCat)];
    [self unschedule: @selector(throwBall)];
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
    
    [self setParametersFromLevel: level];
    
    score = 0;
    
    pooArray = [[NSMutableArray alloc] init];
    
    
    self.isTouchEnabled = YES;
    
    NSArray *coordinats = [self getCoordinatsForLevel: level];
    
    NSString *currentLevel = [NSString stringWithFormat: @"%i", level];
    
    NSString *path = [[NSBundle mainBundle] pathForResource: [NSString stringWithFormat: @"level%@", currentLevel] ofType: @"plist"];
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];                       // делаем Dictionary из файла plist
    
    NSString *pointsString = [NSString stringWithString: [dict valueForKey: @"dogPosition"]];            // берём строку с координатами
    
    NSArray *coordinatsForDog = [pointsString componentsSeparatedByString: @"/"];                       // получаем массив с координатами
    
    mower = [Mower create];
    mower.gameLayer = self;
    
    [mower moveWithPath: coordinats];
    
    dog = [Dog create];
    dog.position = ccp([[coordinatsForDog objectAtIndex: 0] floatValue], [[coordinatsForDog objectAtIndex: 1] floatValue]);
    dog.gameLayer = self;
    
    [dog walk];
    
    flower = [Flower create];
    flower.position = gardenBed.position;//ccp(240, 160); //gardenBed.position;
    flower.gameLayer = self;
    
    cat = [Cat create];
    cat.position = ccp(-100, -100);
    
    
    [self addChild: mower z: zMower];
    [self addChild: dog z: zDog];
    [self addChild: flower z: zFlower];
    [self addChild: cat z: zCat];
    
    blinkLayer = [CCLayerColor layerWithColor: ccc4(255, 50, 50, 200)];
    blinkLayer.position = ccp(0, 0);
    [blinkLayer runAction: [CCFadeOut actionWithDuration: 0]];
    [self addChild: blinkLayer z: zMower + 10];
    
    [objectsWithDynamicZ addObject: mower];
    [objectsWithDynamicZ addObject: dog];
    [objectsWithDynamicZ addObject: flower];
    [objectsWithDynamicZ addObject: cat];
    
    [objectsArray addObject: mower];
    [objectsArray addObject: dog];
    [objectsArray addObject: flower];
    [objectsArray addObject: cat];
    
    [objectsArray addObject: blinkLayer];
    
    [self schedule: @selector(runCat) interval: 15];
    [self schedule: @selector(throwBall) interval: 2];
    [self scheduleUpdate];
}

- (void) pause
{
    CCArray *arr = [self children];
    CCArray *mowerArr = [mower children];
    CCArray *dogArr = [dog children];
    CCArray *catArr = [cat children];
    CCArray *boyArr = [boy children];
    
    for(CCNode *mynode in arr)
    {
        [mynode pauseSchedulerAndActions];
    }
    for(CCNode *mynode in mowerArr)
    {
        [mynode pauseSchedulerAndActions];
    }
    
    for(CCNode *mynode in dogArr)
    {
        [mynode pauseSchedulerAndActions];
    }
    for(CCNode *mynode in catArr)
    {
        [mynode pauseSchedulerAndActions];
    }
    for(CCNode *mynode in boyArr)
    {
        [mynode pauseSchedulerAndActions];
    }
    
    [blinkLayer pauseSchedulerAndActions];
    
    [self pauseSchedulerAndActions];
}

- (void) unPause
{
    CCArray *arr = [self children];
    CCArray *mowerArr = [mower children];
    CCArray *dogArr = [dog children];
    CCArray *catArr = [cat children];
    CCArray *boyArr = [boy children];
    
    for(CCNode *mynode in arr)
    {
        [mynode resumeSchedulerAndActions];
    }
    for(CCNode *mynode in mowerArr)
    {
        [mynode resumeSchedulerAndActions];
    }
    for(CCNode *mynode in dogArr)
    {
        [mynode resumeSchedulerAndActions];
    }
    for(CCNode *mynode in catArr)
    {
        [mynode resumeSchedulerAndActions];
    }
    for(CCNode *mynode in boyArr)
    {
        [mynode resumeSchedulerAndActions];
    }
    
    [blinkLayer resumeSchedulerAndActions];
    
    [self resumeSchedulerAndActions];
}

- (void) restart
{
    
    [self unschedule: @selector(runCat)];
    [self unschedule: @selector(throwBall)];
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

- (void) succeedGame
{
    [guiLayer showSucceedMenu];
    [Settings sharedSettings].money += score;
    [[Settings sharedSettings] save];
}

#pragma mark -
#pragma mark setObjectsParameters

- (void) throwBall
{
    if(ball.status == inPool)
    {
        NSInteger minX = 50;
        NSInteger maxX = 350;
        
        NSInteger minY = 25;
        NSInteger maxY = 225;
        
        NSInteger movementX;
        NSInteger movementY;
        
        NSInteger countOfPointsX = (maxX - minX) / 25;
        movementX = (25 * ((arc4random() % countOfPointsX) + 1) - 1) + 25;
        NSInteger countOfPointsY = (maxY - minY) / 25;
        movementY = (25 * ((arc4random() % countOfPointsY) + 1)) + 12.5;
        
        CGPoint dogPoint = CGPointMake(movementX, movementY);
        
        if(![self checkWaterPoolcollisionWithPoint: dogPoint])
        {
            ball.status = inAir;
            ball.visible = YES;
            
            [boy stopAllActions];
            [boy playThrowBallBoyAnimation];
            
            [ball runAction:
                            [CCSequence actions:
                                            [CCJumpTo actionWithDuration: 2
                                                                position: dogPoint
                                                                  height: 100
                                                                   jumps: 1],
                                            [CCCallBlock actionWithBlock:^(id sender) {
                                                                                            ball.status = onField;
                                                                                      }],
                                            nil
                            ]
             ];
            
            [self unschedule: @selector(throwBall)];
        }
    }
}

- (void) runCat
{
    NSInteger minY = 150;
    NSInteger maxY = 225;
    
    NSInteger catDirection = arc4random() % 2;
    
    if(catDirection == 0) // кошка идет слева направо
    {
        NSInteger x = -100;
        
        NSInteger countOfPointsY = ((maxY - minY) / 25) + 1;
        NSInteger movementY = (25 * ((arc4random() % countOfPointsY))) + minY;
        
        CGPoint catStartPoint = CGPointMake(x, movementY);
        
        if([self checkWaterPoolCollisionWithCatCoordinats: catStartPoint])
        {
            [self runCat];
        }
        else
        {
            [cat walkFromPoint: catStartPoint andDirection: catDirection];
            CCLOG(@"CatPosY: %f", catStartPoint.y);
        }
    }
    if(catDirection == 1) // кошка идет справа налево
    {
        NSInteger x = 580;
        NSInteger countOfPointsY = ((maxY - minY) / 25) + 1;
        NSInteger movementY = (25 * ((arc4random() % countOfPointsY))) + minY;
        
        CGPoint catStartPoint = CGPointMake(x, movementY);
        
        if([self checkWaterPoolCollisionWithCatCoordinats: catStartPoint])
        {
            [self runCat];
        }
        else
        {
            [cat walkFromPoint: catStartPoint andDirection: catDirection];
            CCLOG(@"CatPosY: %f", catStartPoint.y);
        }
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
        kennel = [Kennel create];
        kennel.position = position;
        [self addChild: kennel z: zKennel];
        
        [objectsArray addObject: kennel];
        [objectsWithDynamicZ addObject: kennel];
    }
    else if(ID == 2)
    {
        waterPool = [WaterPool create];
        waterPool.position = position;
        waterPool.gameLayer = self;
        
        boy = [Boy create];
        //boy.position = waterPool.position;
        
        ball = [Ball create];
        ball.position = waterPool.position;
        ball.gameLayer = self;
        
        [self addChild: waterPool z: zWaterPool tag: kWaterPoolTag];
        [waterPool addChild: boy z: zWaterPool + 1];
        [self addChild: ball z: zWaterPool + 2 tag: kWaterPoolTag];
        
        [objectsWithDynamicZ addObject: ball];
        
        [objectsArray addObject: waterPool];
        [objectsArray addObject: ball];
        [objectsArray addObject: boy];
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
