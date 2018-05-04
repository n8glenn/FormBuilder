//
//  SignatureViewController.m
//  TeachMeMobile
//
//  Created by Nate Glenn on 6/15/12.
//  Copyright (c) 2012 Operant Systems. All rights reserved.
//

#import "SignatureViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SignatureViewController ()

@end

@implementation SignatureViewController

@synthesize titleLabel=_titleLabel;
@synthesize signatureView=_signatureView;
@synthesize saveButton=_saveButton;
@synthesize clearButton=_clearButton;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //_signatureView = [[SignatureView alloc] initWithFrame:CGRectMake(10, 54, self.view.frame.size.width - 20, 120)];
    //[self positionControls];
    //[self.view addSubview:_signatureView];
}

- (void)positionControls
{
    [_signatureView setFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 150)];
    [_signatureView setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    [[_signatureView imageView] setFrame:CGRectMake(0, 0, _signatureView.frame.size.width, _signatureView.frame.size.height)];
    [_clearButton setFrame:CGRectMake((self.view.frame.size.width / 2) - _clearButton.frame.size.width - 5, _signatureView.frame.origin.y + _signatureView.frame.size.height + 5, _clearButton.frame.size.width, _clearButton.frame.size.height)];
    [_saveButton setFrame:CGRectMake((self.view.frame.size.width / 2) + 5, _signatureView.frame.origin.y + _signatureView.frame.size.height + 5, _saveButton.frame.size.width, _saveButton.frame.size.height)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self positionControls];   
}

- (IBAction)saveButtonTapped:(id)sender
{
    if (delegate != nil)
    {
        if ([delegate respondsToSelector:@selector(UpdateSignature:)])
        {
            CGSize size = _signatureView.frame.size;
            UIGraphicsBeginImageContext(size);
            [_signatureView.imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *signatureImage = UIGraphicsGetImageFromCurrentImageContext();            
            [delegate UpdateSignature:signatureImage];
        }
    }
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)clearButtonTapped:(id)sender
{
    [[[self signatureView] imageView] setImage:nil];
}

@end
