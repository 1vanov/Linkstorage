//
//  LSLoginViewController.m
//  Linkstorage
//
//  Created by Ilya on 28.01.16.
//  Copyright © 2016 Ilya. All rights reserved.
//

#import "LSLoginViewController.h"
#import "SDK.h"
#import "AppDelegate.h"
#import "LSLeftMenuNavigationController.h"

@interface LSLoginViewController ()

@property (nonatomic) UITextField *fieldFadeout;
@property (nonatomic) CGPoint originalCenter;
@property (nonatomic) UIStatusBarStyle statusBarStyle;

@end

@implementation LSLoginViewController


#pragma mark - View Lifecycle -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.statusBarStyle = UIStatusBarStyleDefault;
    
    self.loginButton.layer.cornerRadius = 2.0f;
    self.errorLabel.superview.layer.cornerRadius = 2.0f;
    
    UIColor *color = [UIColor colorWithWhite:255 alpha:0.85];
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:[self.emailField placeholder] attributes:@{ NSForegroundColorAttributeName: color}];
    self.emailField.attributedPlaceholder = str;
    str = [[NSAttributedString alloc] initWithString:[self.passwordField placeholder] attributes:@{ NSForegroundColorAttributeName: color}];
    self.passwordField.attributedPlaceholder = str;
    
    [[UITextField appearance] setTintColor:color];
    
    self.originalCenter = self.view.center;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self.emailField setText:@"test@linkstorage.ru"];
    [self.passwordField setText:@"123123"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return self.statusBarStyle;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.emailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    self.view.center = self.originalCenter;
    [UIView animateWithDuration:0.2 animations:^{
        if (toInterfaceOrientation==UIInterfaceOrientationPortrait) {
            self.logoImageView.alpha = 1;
        } else {
            self.logoImageView.alpha = 0.08;
        }
    }];
}
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    self.originalCenter = self.view.center;
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    [self.emailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate -

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.2 animations:^{
        if (textField == self.emailField) self.emailBorder.alpha = 0.75;
        if (textField == self.passwordField) self.passwordBorder.alpha = 0.75;
    }];

}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.emailBorder.alpha = 0.55;
    self.passwordBorder.alpha = 0.55;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.emailField)
        [self.passwordField becomeFirstResponder];
    else
        [textField resignFirstResponder];
    return YES;
}



#pragma mark - Keyboard -

- (void)keyboardWillShow:(NSNotification *)note {
    CGFloat offsetY = self.interfaceOrientation==UIInterfaceOrientationPortrait ? 165.0f : 30.0f;
    CGPoint newCenter = CGPointMake(self.originalCenter.x, self.originalCenter.y-offsetY);
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.visualEffectView setEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        self.statusBarStyle = UIStatusBarStyleLightContent;
        [self setNeedsStatusBarAppearanceUpdate];
        self.view.center = newCenter;
        [self.loginButton setBackgroundColor:[UIColor colorWithWhite:255 alpha:0.25]];
        self.logoImageView.alpha = 0.08;
    }];
}

- (void)keyboardWillHide:(NSNotification *)note {
    CGPoint newCenter = CGPointMake(self.originalCenter.x, self.originalCenter.y);
    [UIView animateWithDuration:0.2 animations:^{
        [self.visualEffectView setEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        self.statusBarStyle = UIStatusBarStyleDefault;
        [self setNeedsStatusBarAppearanceUpdate];
        self.view.center = newCenter;
        if ([self.emailField.text length] && [self.passwordField.text length])
            [self.loginButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
        else
            [self.loginButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.35]];
        
        if (self.interfaceOrientation==UIInterfaceOrientationPortrait)
            self.logoImageView.alpha = 1;
    }];
}



- (IBAction)loginPressed:(id)sender {
    [self.loginIndicator startAnimating];
    [self.loginButton setTitle:@" " forState:UIControlStateNormal];

    [self.emailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        [self.visualEffectView setEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    }];
    
    // Async to correctly indicator work
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        NSDictionary *result = [[SDK sharedInstance] loginWithEmail:[self.emailField text] password:[self.passwordField text]];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if ([result objectForKey:@"error"]) {
                self.errorLabel.text = [[result objectForKey:@"error"] objectAtIndex:0];
                [UIView animateWithDuration:0.2 animations:^{
                    self.errorLabel.superview.alpha = 1; 
                
                    int64_t delayInSeconds = 2.5;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [UIView animateWithDuration:0.2 animations:^{
                            self.errorLabel.superview.alpha = 0;
                        }];
                    });
                }];
            }
        
            if ([result objectForKey:@"response"]) {
                NSDictionary *response = [result objectForKey:@"response"];
                [(AppDelegate *)[[UIApplication sharedApplication] delegate] setUserId:[[response objectForKey:@"user_id"] integerValue]];
        
                [[NSUserDefaults standardUserDefaults] setObject:[response objectForKey:@"user_id"] forKey:@"user_id"];
                [[NSUserDefaults standardUserDefaults] setObject:[response objectForKey:@"access_token"] forKey:@"access_token"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            
                [(AppDelegate *)[[UIApplication sharedApplication] delegate] presentMFSController];
            }
        
            [self.loginIndicator stopAnimating];
            [self.loginButton setTitle:@"Войти" forState:UIControlStateNormal];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
    });
    
}


@end
