//
//  LSAddPostViewController.m
//  Linkstorage
//
//  Created by Ilya on 08.02.16.
//  Copyright © 2016 Ilya. All rights reserved.
//

#import "LSAddPostViewController.h"
#import "SDK.h"

@interface LSAddPostViewController ()

@end

@implementation LSAddPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // empty back button
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.errorLabel.superview.layer.cornerRadius = 2.0f;

    [self setPlaceholder];
    [self pasteUrl:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    [self.urlField resignFirstResponder];
    [self.titleField resignFirstResponder];
    [self.textField resignFirstResponder];
}

- (void)setPlaceholder {
    self.textPlaceholder = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 1.0, self.textField.frame.size.width - 10.0, 34.0)];
    [self.textPlaceholder setText:@"Описание"];
    [self.textPlaceholder setBackgroundColor:[UIColor clearColor]];
    [self.textPlaceholder setTextColor:[self.textField textColor]];
    [self.textPlaceholder setFont:[self.textField font]];
    [self.textField addSubview:self.textPlaceholder];
    [self.textField setTextColor:[UIColor blackColor]];
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length)
        self.textPlaceholder.hidden = YES;
    else
        self.textPlaceholder.hidden = NO;
}

- (IBAction)pasteUrl:(id)sender {
    UIPasteboard *_clipboard = [UIPasteboard generalPasteboard];
    NSString *clipboard = _clipboard.string;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        NSDictionary *result = [[SDK sharedInstance] getLinkDesc:clipboard];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if ([result objectForKey:@"response"]) {
                self.urlField.text = clipboard;
                self.titleField.text = [[result objectForKey:@"response"] objectForKey:@"title"];
                self.textField.text = [[result objectForKey:@"response"] objectForKey:@"text"];
                if (self.textField.text.length) self.textPlaceholder.hidden = YES;
            }
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
    });
}

- (IBAction)post:(id)sender {
    
    NSString *url = [self.urlField text];
    NSString *title = [self.titleField text];
    NSString *text = [NSString stringWithFormat:@"%@", self.textField.text];
    NSInteger private = [self.privateSwitcher isOn]?0:1;
    
    [self.loadIndicator startAnimating];
    [sender setTitle:@" " forState:UIControlStateNormal];
    
    [self.urlField resignFirstResponder];
    [self.titleField resignFirstResponder];
    [self.textField resignFirstResponder];
    
    // Async to correctly indicator work
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            [[SDK sharedInstance] addPostWithUrl:url title:title text:text private:private onSuccess:^(NSDictionary *result) {
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            } onError:^(NSArray *result) {
                
                self.errorLabel.text = [result objectAtIndex:0];
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
                
            }];
            
            [self.loadIndicator stopAnimating];
            [sender setTitle:@"Готово" forState:UIControlStateNormal];
        });
    });
}

@end
