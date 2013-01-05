
#import <Foundation/Foundation.h>

@interface Settings: NSObject
{
    NSInteger money;
    NSInteger currentMower;
    NSInteger availableMowers;
}

+ (Settings *) sharedSettings;

- (void) load;
- (void) save;

@property (nonatomic, assign) NSInteger money;
@property (nonatomic, assign) NSInteger currentMower;
@property (nonatomic, assign) NSInteger availableMowers;

@end