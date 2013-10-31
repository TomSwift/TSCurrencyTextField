//
//  TSCurrencyTextField.h
//
//  Created by Nicholas Hodapp on 10/30/13.
//  Copyright (c) 2013 Nicholas Hodapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSCurrencyTextField : UITextField

@property (nonatomic) NSCharacterSet* invalidInputCharacterSet;
@property (nonatomic) NSNumberFormatter* currencyNumberFormatter;

@property (nonatomic) NSNumber* amount;

@end
