//
//  SignatureView.h
//  animationTest
//
//  Created by Nathan Glenn on 8/16/11.
//  Copyright 2011 Operant Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignatureView : UIView
{
    UIImageView *_imageView;
    CGPoint lastPoint;
    BOOL mouseSwiped;
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView;

@end
