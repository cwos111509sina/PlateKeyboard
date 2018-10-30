//
//  ViewController.m
//  PlateKeyBoard
//
//  Created by jsmnzn on 2018/10/29.
//  Copyright © 2018年 test. All rights reserved.
//

#import "ViewController.h"
#import "PlateInputView.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height


@interface ViewController ()<UITextFieldDelegate>


@property (nonatomic,strong)PlateInputView * plateInput;
@property (nonatomic,strong)UITextField * plateTextField;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _plateTextField = [[UITextField alloc]initWithFrame:CGRectMake(30, 100, WIDTH-60, 50)];
    _plateTextField.delegate = self;
    _plateTextField.layer.borderColor = [UIColor blackColor].CGColor;
    _plateTextField.layer.borderWidth = 1;
    _plateTextField.keyboardType = UIKeyboardTypeNumberPad;//设置数字键盘防止复制粘贴板自动加空格
    __block ViewController * weakSelf = self;
    _plateInput = [[PlateInputView alloc]init];
    _plateInput.sendTextBlock = ^(NSString *palteString) {
        weakSelf.plateTextField.text = palteString;
    };
    
    _plateTextField.inputView = _plateInput;
    [_plateTextField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_plateTextField];
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark 车牌号输入框监听及代理方法

-(void)textChange:(UITextField *)textField{
    NSString * str = textField.text;
    _plateInput.plateStr = str;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString * str = textField.text;
    
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingCharactersInRange:range withString:string];
    
    if (str.length>0) {
        NSArray * provinceArr = @[@"京",@"津",@"晋",@"冀",@"蒙",@"辽",@"黑",@"吉",@"沪",@"苏",@"浙",@"皖",@"闽",@"赣",@"鲁",@"豫",@"鄂",@"湘",@"粤",@"桂",@"琼",@"渝",@"川",@"贵",@"云",@"藏",@"陕",@"甘",@"青",@"宁",@"新",@"W"];
        
        if (str.length>8) {
            return NO;
        }else if (![provinceArr containsObject:[str substringToIndex:1]]) {
            return NO;
        }else{
            for (NSString * enumStr in provinceArr) {
                
                if ([enumStr isEqualToString:@"W"]) {
                
                }else if ([[str substringWithRange:NSMakeRange(1, str.length-1)] rangeOfString:enumStr].location != NSNotFound ) {
                    return NO;
                }
            }
        }
    }
    _plateInput.plateStr = str;
    
    return YES;
}

-(void)tapClick:(UITapGestureRecognizer *)tap{
    [tap.view endEditing:YES];
}



@end
