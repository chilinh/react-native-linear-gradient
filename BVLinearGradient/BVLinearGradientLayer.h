#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface BVLinearGradientLayer : CALayer

@property (nullable, nonatomic, strong) NSArray<UIColor *> *colors;
@property (nullable, nonatomic, strong) NSArray<NSNumber *> *locations;
@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;
@property (nonatomic) BOOL useAngle;
@property (nonatomic) CGPoint angleCenter;
@property (nonatomic) CGFloat angle;


@end
