//
//  SignatureView.m
//  animationTest
//
//  Created by Nathan Glenn on 8/16/11.
//  Copyright 2011 Operant Systems. All rights reserved.
//

#import "SignatureView.h"

@implementation SignatureView

@synthesize imageView=_imageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        [self setImageView:[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)]];
        //[self.imageView setImage:[UIImage imageNamed:@"20110626-IMG_3397.jpg"]];
        [self addSubview:self.imageView];
        //self.alpha = 0.4;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    mouseSwiped = NO;
    UITouch *touch = [touches anyObject];

    if ([touch tapCount] == 2) 
    {
        //self.imageView.image = nil;
        return;
    }
    
    lastPoint = [touch locationInView:self];
    //lastPoint.y -= 20;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
    mouseSwiped = YES;

    UITouch *touch = [touches anyObject];	
    CGPoint currentPoint = [touch locationInView:self];
    //currentPoint.y -= 20;

    UIGraphicsBeginImageContext(self.frame.size);
    [self.imageView.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 3.0);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    lastPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{    
    UITouch *touch = [touches anyObject];

    if ([touch tapCount] == 2) 
    {
        //self.imageView.image = nil;
        return;
    }
    
    if (!mouseSwiped) 
    {
        UIGraphicsBeginImageContext(self.frame.size);
        [self.imageView.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5.0);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
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
