
#import "Settings.h"
#import "GameConfig.h"

@implementation Settings

Settings *sharedSettings    = nil;

@synthesize money;
@synthesize currentMower;
@synthesize availableMowers;
@synthesize soundLevel;
@synthesize openedLevels;

+ (Settings *) sharedSettings
{
    if(!sharedSettings)
    {
        sharedSettings = [[Settings alloc] init];
    }
    
    return sharedSettings;
}

- (id) init
{
    if((self = [super init]))
    {
        //
    }
    
    return self;
}

- (void) dealloc
{
    [self save];
    [super dealloc];
}

#pragma mark -
#pragma mark load/save

- (void) load
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSNumber *moneyData = [defaults objectForKey: kMoneyKey];
    if(moneyData)
    {
        self.money = [moneyData integerValue];
    }
    else
    {
        self.money = 0;
    }
    
    NSNumber *mowerData = [defaults objectForKey: kMowerKey];
    if(mowerData)
    {
        self.currentMower = [mowerData integerValue];
    }
    else
    {
        self.currentMower = 0;
    }
    
    NSNumber *availableMowersData = [defaults objectForKey: kAvailableMowerKey];
    if(availableMowersData)
    {
        self.availableMowers = [availableMowersData integerValue];
    }
    else
    {
        self.availableMowers = 1000;
    }
    
    NSNumber *soundData = [defaults objectForKey: kSoundKey];
    if(soundData)
    {
        self.soundLevel = [soundData integerValue];
    }
    else
    {
        self.soundLevel = 1;
    }
    
    NSNumber *levelsData = [defaults objectForKey: kOpenedLevelsKey];
    if(levelsData)
    {
        self.openedLevels = [levelsData integerValue];
    }
    else
    {
        self.openedLevels = 1;
    }
    
}

- (void) save
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject: [NSNumber numberWithInteger: self.money] forKey: kMoneyKey];
    
    [defaults setObject: [NSNumber numberWithInteger: self.currentMower] forKey: kMowerKey];
    
    [defaults setObject: [NSNumber numberWithInteger: self.availableMowers] forKey: kAvailableMowerKey];
    
    [defaults setObject: [NSNumber numberWithInteger: self.soundLevel] forKey: kSoundKey];
    
    [defaults setObject: [NSNumber numberWithInteger: self.openedLevels] forKey: kOpenedLevelsKey];
    
    [defaults synchronize];
}


@end
