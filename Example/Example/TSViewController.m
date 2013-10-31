//
//  TSViewController.m
//  Example
//
//  Created by Nicholas Hodapp on 10/30/13.
//  Copyright (c) 2013 CoDeveloper, LLC. All rights reserved.
//

#import "TSViewController.h"
#import "TSCurrencyTextField.h"

@interface TSViewController () <UITextFieldDelegate>
@end

@implementation TSViewController
{
    IBOutlet TSCurrencyTextField*   _currencyTextField;
    
    IBOutlet UIButton*              _doneButton;
    
    IBOutlet UILabel*               _amountLabel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _currencyTextField.amount = @9.99;
    _currencyTextField.keyboardType = UIKeyboardTypeNumberPad;

    _doneButton.hidden = YES;
    _amountLabel.text = _currencyTextField.text;
}

- (IBAction) done: (id) sender
{
    [self.view endEditing: YES];
}

- (IBAction) amountChanged: (TSCurrencyTextField*) sender
{
    // This could just as easily be _amountLabel.text = sender.text.
    // But we want to demonstrate the amount property here.
    
    _amountLabel.text = [sender.currencyNumberFormatter stringFromNumber: sender.amount];
}

- (BOOL) textField: (UITextField *) textField shouldChangeCharactersInRange: (NSRange)range replacementString: (NSString *) string
{
    NSAssert( FALSE, @"This should never be called.  TSCurrencyTextField doesn't pass this one on!");
    
    return YES;
}

- (void) textFieldDidBeginEditing: (UITextField *) textField
{
    NSLog( @"%@", NSStringFromSelector( _cmd ) );
    
    _doneButton.hidden = NO;
}

- (void) textFieldDidEndEditing: (UITextField *) textField
{
    NSLog( @"%@", NSStringFromSelector( _cmd ) );
    
    _doneButton.hidden = YES;
}

@end
