
#import <Foundation/Foundation.h>

@interface Settings: NSObject
{
    NSInteger money;
    NSInteger currentMower;
    NSInteger availableMowers;
    NSInteger soundLevel;
    NSInteger openedLevels;
}

+ (Settings *) sharedSettings;

- (void) load;
- (void) save;

@property (nonatomic, assign) NSInteger money;
@property (nonatomic, assign) NSInteger currentMower;
@property (nonatomic, assign) NSInteger availableMowers;
@property (nonatomic, assign) NSInteger soundLevel;
@property (nonatomic, assign) NSInteger openedLevels;

@end