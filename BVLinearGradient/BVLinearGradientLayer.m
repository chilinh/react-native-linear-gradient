#import "BVLinearGradientLayer.h"

@implementation BVLinearGradientLayer
{
    BOOL _needsNewGradient;
    CGGradientRef _lastGradient;
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.needsDisplayOnBoundsChange = YES;
        _needsNewGradient = YES;
        _angleCenter = CGPointMake(0.5, 0.5);
        _angle = 45.0;
    }
    
    return self;
}

- (void)setNeedsNewGradient
{
    _needsNewGradient = YES;
    [self setNeedsDisplay];
}

- (void)setColors:(NSArray<UIColor *> *)colors
{
    _colors = colors;
    [self setNeedsNewGradient];
}

- (void)setLocations:(NSArray<NSNumber *> *)locations
{
    _locations = locations;
    [self setNeedsNewGradient];
}

- (void)setStartPoint:(CGPoint)startPoint
{
    _startPoint = startPoint;
    [self setNeedsNewGradient];
}

- (void)setEndPoint:(CGPoint)endPoint
{
    _endPoint = endPoint;
    [self setNeedsNewGradient];
}
    
- (void)setUseAngle:(BOOL)useAngle
{
    _useAngle = useAngle;
    [self setNeedsDisplay];
}

- (void)setAngleCenter:(CGPoint)angleCenter
{
    _angleCenter = angleCenter;
    [self setNeedsDisplay];
}

- (void)setAngle:(CGFloat)angle
{
    _angle = angle;
    [self setNeedsDisplay];
}

- (CGSize)calculateGradientLocationWithAngle:(CGFloat)angle
{
    CGFloat angleRad = +angle - 90 * (M_PI / 180);
    CGFloat length = sqrt(2);
    
    return CGSizeMake(cos(angleRad) * length, sin(angleRad) * length);
}
    
- (void)drawInContext:(CGContextRef)ctx
{
    if (!_colors)
        return;
    
    if (!_lastGradient || _needsNewGradient)
    {
        CGFloat *locations = nil;
        
        locations = malloc(sizeof(CGFloat) * _colors.count);
        
        for (NSInteger i = 0; i < _colors.count; i++)
        {
            if (_locations.count > i)
            {
                locations[i] = _locations[i].floatValue;
            }
            else
            {
                locations[i] = (1 / (_colors.count - 1)) * i;
            }
        }
        
        _lastGradient = CGGradientCreateWithColors(nil, (CFArrayRef)_colors, nil);
        _needsNewGradient = NO;
        
        free(locations);
    }
    
    CGSize size = self.bounds.size;
    
    if (size.width == 0.0 || size.height == 0.0)
        return;
    
    CGPoint start = self.startPoint, end = self.endPoint;
    
    if (_useAngle)
    {
        CGSize size = [self calculateGradientLocationWithAngle:_angle];
        start.x = _angleCenter.x - size.width / 2;
        start.y = _angleCenter.y - size.height / 2;
        end.x = _angleCenter.x + size.width / 2;
        end.y = _angleCenter.y + size.height / 2;
    }
    
    CGContextDrawLinearGradient(ctx, _lastGradient,
                                CGPointMake(start.x * size.width, start.y * size.height),
                                CGPointMake(end.x * size.width, end.y * size.height),
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
}

@end
