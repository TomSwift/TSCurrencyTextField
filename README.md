##TSCurrencyTextField

TSCurrencyTextField is a UITextField subclass that behaves like an ATM currency-amount entry field: the user can enter decimal digits only and the field formats that input into a currency amount, complete with currency symbol ($), decimal point (.), and group separators (,).

<p align="center" >
<img src="https://raw.github.com/TomSwift/TSCurrencyTextField/master/ExampleImages/image1.png" width="376" />
</p>

##Installing TSCurrencyTextField
<img src="https://cocoapod-badges.herokuapp.com/v/TSCurrencyTextField/badge.png"/><br/>
You can install TSCurrencyTextField in your project by using [CocoaPods](https://github.com/cocoapods/cocoapods):

```Ruby
pod 'TSCurrencyTextField', '~> 0.1.0'
```

##Usage

An example project is included in the Example directory. This should give you an idea how to use the class.

###textFieldPublicDelegate
Property was added to be able to call delegate method `- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;` if delegate exists to eventually decide if change should be made. Method is called with `string` parameter pointing to exactly the same string that will be put in text field right after method is called.
It allows to block text field editing e.g. if maximum length is reached:

```
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    const int maxPriceStringLength = 10; // '$' + 7 digits + 2 commas, e.g. $1,123,456
    return (string && string.length < maxPriceStringLength);
}
```

##Donate

Please consider a small donation if you use TSCurrencyTextField in your projects.  It'll make me feel good.

<a href="https://www.wepay.com/donate/1701987056"  target="_blank" ><img src="https://www.wepay.com/img/widgets/donate_with_wepay.png" alt="Donate with WePay" height="40" width="200" /></a>

##License
`TSCurrencyTextField` is available under the MIT license. See the LICENSE file for more info.
