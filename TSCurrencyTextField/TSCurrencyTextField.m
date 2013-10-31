//
//  TSCurrencyTextField.m
//
//  Created by Nicholas Hodapp on 10/30/13.
//  Copyright (c) 2013 Nicholas Hodapp. All rights reserved.
//

#import "TSCurrencyTextField.h"
#import <objc/runtime.h>

@interface TSCurrencyTextFieldDelegate : NSObject <UITextFieldDelegate>
@property (weak, nonatomic) id<UITextFieldDelegate> delegate;
@end

@implementation TSCurrencyTextField
{
    TSCurrencyTextFieldDelegate* _currencyTextFieldDelegate;

    NSNumberFormatter*           _currencyNumberFormatter;

    NSCharacterSet*              _invalidInputCharacterSet;
}

- (id) initWithCoder: (NSCoder *) aDecoder
{
    self = [super initWithCoder: aDecoder];
    if ( self )
    {
        [self TSCurrencyTextField_commonInit];
    }
    return self;
}

- (id) initWithFrame: (CGRect) frame
{
    self = [super initWithFrame: frame];
    if ( self )
    {
        [self TSCurrencyTextField_commonInit];
    }
    return self;
}

- (void) TSCurrencyTextField_commonInit
{
    _invalidInputCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];

    _currencyNumberFormatter = [[NSNumberFormatter alloc] init];
    _currencyNumberFormatter.locale = [NSLocale currentLocale];
    _currencyNumberFormatter.numberStyle = kCFNumberFormatterCurrencyStyle;
    _currencyNumberFormatter.usesGroupingSeparator = YES;
    
    _currencyTextFieldDelegate = [TSCurrencyTextFieldDelegate new];
    [super setDelegate: _currencyTextFieldDelegate];
    
    [self setText: @"0"];
}

- (void) setCaratPosition: (NSInteger) pos
{
    [self setSelectionRange: NSMakeRange( pos, 0) ];
}

- (void) setSelectionRange: (NSRange) range
{
    UITextPosition *start = [self positionFromPosition: [self beginningOfDocument]
                                                offset: range.location];
    
    UITextPosition *end = [self positionFromPosition: start
                                              offset: range.length];
    
    [self setSelectedTextRange: [self textRangeFromPosition:start toPosition:end]];
}

- (void) setAmount: (NSNumber *) amount
{
    NSString* amountString = [NSString stringWithFormat: @"%.*lf", _currencyNumberFormatter.maximumFractionDigits, amount.doubleValue];
    [self setText: amountString];
}

- (NSNumber*) amountFromString: (NSString*) string
{
    NSString* digitString = [[string componentsSeparatedByCharactersInSet: _invalidInputCharacterSet] componentsJoinedByString: @""];
    
    NSParameterAssert( _currencyNumberFormatter.maximumFractionDigits == _currencyNumberFormatter.minimumFractionDigits );
    NSInteger fd = _currencyNumberFormatter.minimumFractionDigits;
    NSNumber* n = [NSNumber numberWithDouble: [digitString doubleValue] / pow(10.0, fd) ];
    
    return n;
}

- (NSNumber*) amount
{
    return [self amountFromString: self.text];
}

- (void) setDelegate:(id<UITextFieldDelegate>)delegate
{
    _currencyTextFieldDelegate.delegate = delegate;
}

- (id<UITextFieldDelegate>) delegate
{
    return _currencyTextFieldDelegate.delegate;
}

- (void) setText: (NSString *) text
{
    NSString* formatted = [_currencyNumberFormatter stringFromNumber: [self amountFromString: text]];
    
    [super setText: formatted];
}

@end

@implementation TSCurrencyTextFieldDelegate

- (BOOL) respondsToSelector: (SEL) aSelector
{
    // we'll forward any implemented UITextFieldDelegate method, other than the one we implement ourself.
    
    BOOL selfResponds = [super respondsToSelector: aSelector];
    if ( selfResponds )
        return YES;
    
    struct objc_method_description md = protocol_getMethodDescription( @protocol(UITextFieldDelegate), aSelector, NO, YES);
    
    if ( md.name != NULL && md.types != NULL )
        return [self.delegate respondsToSelector: aSelector];
    
    return selfResponds;
}

- (id) forwardingTargetForSelector: (SEL) aSelector
{
    // we'll forward any implemented UITextFieldDelegate method, other than the one we implement ourself.

    struct objc_method_description md = protocol_getMethodDescription( @protocol(UITextFieldDelegate), aSelector, NO, YES);
    
    if ( md.name != NULL && md.types != NULL && [self.delegate respondsToSelector: aSelector] )
        return self.delegate;
    
    return nil;
}

- (BOOL) textField: (TSCurrencyTextField *) textField shouldChangeCharactersInRange: (NSRange) range replacementString: (NSString *) string
{
    // "deleting" a formatting character just back-spaces over that character:
    if ( string.length == 0 && range.length == 1 && [[textField invalidInputCharacterSet] characterIsMember: [textField.text characterAtIndex: range.location]] )
    {
        [textField setCaratPosition: range.location];
        return NO;
    }
    
    int distanceFromEnd = textField.text.length - (range.location + range.length);
    
    NSString* changed = [textField.text stringByReplacingCharactersInRange: range withString: string];
    [textField setText: changed];
    
    int pos = textField.text.length - distanceFromEnd;
    if ( pos >= 0 && pos <= textField.text.length )
    {
        [textField setCaratPosition: pos];
    }
    
    [textField sendActionsForControlEvents: UIControlEventEditingChanged];
    
    return NO;
}

@end