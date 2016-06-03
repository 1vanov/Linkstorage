//
//  LSAddPostViewController.h
//  Linkstorage
//
//  Created by Ilya on 08.02.16.
//  Copyright © 2016 Ilya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSAddPostViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *urlField;
@property (weak, nonatomic) IBOutlet UIView *urlSeparator;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UIView *titleSeparator;
@property (weak, nonatomic) IBOutlet UITextView *textField;
@property (weak, nonatomic) IBOutlet UIView *textSeparator;
@property (weak, nonatomic) IBOutlet UISwitch *privateSwitcher;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadIndicator;
@property (nonatomic) UILabel *textPlaceholder;

- (IBAction)pasteUrl:(id)sender;
- (IBAction)post:(id)sender;


@end
