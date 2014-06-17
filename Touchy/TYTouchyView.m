//
//  TYTouchyView.m
//  Touchy
//
//  Created by Алексей Протасов on 18.06.14.
//  Copyright (c) 2014 Alexey Protasov. All rights reserved.
//

#import "TYTouchyView.h"

@interface TYTouchyView() {
    NSArray *touchPoints;
}

- (void)updateTouches:(NSSet*)set;

@end

@implementation TYTouchyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self updateTouches:event.allTouches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self updateTouches:event.allTouches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self updateTouches:event.allTouches];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self updateTouches:event.allTouches];
}

- (void)updateTouches:(NSSet*)set {
    NSMutableArray *array = [NSMutableArray array];
    
    for (UITouch *touch in set) {
        switch (touch.phase) {
            case UITouchPhaseBegan:
            case UITouchPhaseMoved:
            case UITouchPhaseStationary:
                [array addObject:[NSValue valueWithCGPoint:[touch locationInView:self]]];
                break;
            default:
                break;
        }
    }
    
    touchPoints = array;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor blackColor] set];
    
    CGContextFillRect(context, rect);
    
    UIBezierPath *path = nil;
    
    if (touchPoints.count > 1) {
        path = [UIBezierPath bezierPath];
        
        NSValue *firstLocation = nil;
        
        for (NSValue *location in touchPoints) {
            if (firstLocation == nil) {
                firstLocation = location;
                
                [path moveToPoint:location.CGPointValue];
            } else {
                [path addLineToPoint:location.CGPointValue];
            }
        }
        
        if (touchPoints.count > 2) {
            [path addLineToPoint:firstLocation.CGPointValue];
        }
        
        [[UIColor lightGrayColor] set];
        
        path.lineWidth = 6;
        path.lineCapStyle = kCGLineCapRound;
        path.lineJoinStyle = kCGLineJoinRound;
        
        [path stroke];
    }
    
    unsigned int touchNumber = 1;
    
    NSDictionary *fontAttrs = @{
                                NSFontAttributeName: [UIFont boldSystemFontOfSize:180],
                                NSForegroundColorAttributeName: [UIColor yellowColor]
                                };
    for (NSValue *location in touchPoints) {
        NSString *text = [NSString stringWithFormat:@"%u", touchNumber++];
        
        CGSize size = [text sizeWithAttributes:fontAttrs];
        CGPoint touchPoint = location.CGPointValue;
        CGPoint textCorner = CGPointMake(touchPoint.x - size.width / 2, touchPoint.y - size.height / 2);
        
        [text drawAtPoint:textCorner withAttributes:fontAttrs];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
