//
//  SignatureViewController.h
//  TeachMeMobile
//
//  Created by Nate Glenn on 6/15/12.
//  Copyright (c) 2012 Operant Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignatureView.h"

UILabel *_titleLabel;
SignatureView *_signatureView;
UIButton *_saveButton;
UIButton *_clearButton;

@protocol EditSignatureDelegate <NSObject>

-(void)UpdateSignature:(UIImage *)newSignature;

@end

@interface SignatureViewController : UIViewController

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet SignatureView *signatureView;
@property (nonatomic, retain) IBOutlet UIButton *saveButton;
@property (nonatomic, retain) IBOutlet UIButton *clearButton;
@property (nonatomic, assign) id <EditSignatureDelegate> delegate;

- (void)positionControls;
- (IBAction)saveButtonTapped:(id)sender;
- (IBAction)clearButtonTapped:(id)sender;

@end
