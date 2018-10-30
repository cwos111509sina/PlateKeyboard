//
//  PlateInputView.m
//  PlateKeyBoard
//
//  Created by jsmnzn on 2018/10/29.
//  Copyright © 2018年 test. All rights reserved.
//

#import "PlateInputView.h"


#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define INPUTHEIGHT 180 * (HEIGHT/568)


#pragma mark 获取当前应用第一响应链对象
static __weak id firstResponder;
@implementation UIResponder(FirstResponder)


+ (id)firstResponder{
    firstResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];//当target为空时、系统会默认遍历响应链执行
    return firstResponder;
}
#pragma clang diagnostic pop

- (void)findFirstResponder:(id)sender{//第一响应者响应方法、设置firstResponder
    firstResponder = self;
}

@end




@interface PlateInputView ()

@property (nonatomic, strong) NSArray *provinceArr;//省份简称
@property (nonatomic, strong) NSArray *letterArr;//尾数（数字+字母）
@property (nonatomic, strong) UIView *provinceView;//省份选择视图
@property (nonatomic, strong) UIView *letterView;//尾数视图
@end


@implementation PlateInputView


-(instancetype)init{
    if (self = [super init]) {
        [self createInputV];
    }
    return self;
}

-(void)createInputV{
    
    self.frame = CGRectMake(0, HEIGHT-INPUTHEIGHT, WIDTH, INPUTHEIGHT);
    self.backgroundColor = [UIColor lightGrayColor];
    
    _provinceArr = @[@"京",@"津",@"晋",@"冀",@"蒙",@"辽",@"黑",@"吉",@"沪",
                         @"苏",@"浙",@"皖",@"闽",@"赣",@"鲁",@"豫",@"鄂",@"湘",
                         @"粤",@"桂",@"琼",@"渝",@"川",@"贵",@"云",@"藏",@"陕",
                         @"甘",@"青",@"宁",@"新",@"W"];
    
    _letterArr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",
                       @"Q",@"W",@"E",@"R",@"T",@"Y",@"U",@"O",@"P",@"A",
                       @"S",@"D",@"F",@"G",@"H",@"J",@"K",@"L",@"学",@"Z",
                       @"X",@"C",@"V",@"B",@"N",@"M"];
    
    _provinceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, INPUTHEIGHT)];
    [self addSubview:_provinceView];
    
    
    CGFloat provinceWidth = (WIDTH) / 9;//单行数量为9时所占宽度
    CGFloat provinceHeight = INPUTHEIGHT / 4;//单列数量为4时所占高度
    CGFloat provinceFrameX = 0.0;//
    
    for (int i = 0; i < _provinceArr.count+2; i++) {//数量+2为后面添加删除确定键预留
        UIButton *provinceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if (i < _provinceArr.count) {
            
            provinceBtn.frame = CGRectMake(1.5 + provinceWidth * (i%9), 1.5+ provinceHeight*(i/9), provinceWidth - 3, provinceHeight - 3);
            provinceBtn.backgroundColor = [UIColor whiteColor];
            
            [provinceBtn setTitle:_provinceArr[i] forState:0];
            [provinceBtn setTitleColor:[UIColor blackColor] forState:0];
            provinceFrameX = CGRectGetMaxX(provinceBtn.frame)+3;
            
        }else if(i == _provinceArr.count){
            
            provinceBtn.frame = CGRectMake(provinceFrameX, 1.5+ provinceHeight*(i/10), provinceWidth*1.5 - 3, provinceHeight - 3);
            provinceBtn.backgroundColor = [UIColor whiteColor];
            [provinceBtn setImage:[UIImage imageNamed:@"plateDelete"] forState:UIControlStateNormal];
            provinceFrameX = CGRectGetMaxX(provinceBtn.frame)+3;
            
        }else if(i == _provinceArr.count+1){
            provinceBtn.frame = CGRectMake(provinceFrameX, 1.5 + provinceHeight * 3, WIDTH-provinceFrameX- 1.5, provinceHeight - 3);
            provinceBtn.userInteractionEnabled = NO;
            provinceBtn.backgroundColor = [UIColor grayColor];
            [provinceBtn setTitle:@"确认" forState:0];
            [provinceBtn setTitleColor:[UIColor whiteColor] forState:0];
        }
        
        provinceBtn.layer.cornerRadius = 3;
        provinceBtn.tag = 1000 + i;
        [provinceBtn addTarget:self action:@selector(provinceClick:) forControlEvents:UIControlEventTouchUpInside];
        [_provinceView addSubview:provinceBtn];
    }
    
    
    
    UIView *letterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, INPUTHEIGHT)];
    letterView.hidden = YES;
    self.letterView = letterView;
    [self addSubview:letterView];
    
    CGFloat letterWidth = (WIDTH) / 10;
    CGFloat letterHeight = INPUTHEIGHT / 4;
    CGFloat letterFrameX = 0.0;
    for (int i = 0; i < _letterArr.count+2; i++) {
        UIButton *letterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i < _letterArr.count) {
            
            letterBtn.frame = CGRectMake(1.5 + letterWidth * (i%10), 1.5+ letterHeight*(i/10), letterWidth - 3, letterHeight - 3);
            letterBtn.backgroundColor = [UIColor whiteColor];
            
            [letterBtn setTitle:_letterArr[i] forState:0];
            [letterBtn setTitleColor:[UIColor blackColor] forState:0];
            letterFrameX = CGRectGetMaxX(letterBtn.frame)+3;
            
        }else if(i == _letterArr.count){
            
            letterBtn.frame = CGRectMake(letterFrameX, 1.5+ letterHeight*(i/10), letterWidth*1.5 - 3, letterHeight - 3);
            letterBtn.backgroundColor = [UIColor whiteColor];
            [letterBtn setImage:[UIImage imageNamed:@"plateDelete"] forState:UIControlStateNormal];
            letterFrameX = CGRectGetMaxX(letterBtn.frame)+3;
            
        }else if(i == _letterArr.count+1){
            letterBtn.frame = CGRectMake(letterFrameX, 1.5 + letterHeight * 3, WIDTH-letterFrameX- 1.5, letterHeight - 3);
            letterBtn.userInteractionEnabled = NO;
            letterBtn.backgroundColor = [UIColor grayColor];
            [letterBtn setTitle:@"确认" forState:0];
            [letterBtn setTitleColor:[UIColor whiteColor] forState:0];
        }
        
        letterBtn.layer.cornerRadius = 3;
        letterBtn.tag = 1000 + i;
        [letterBtn addTarget:self action:@selector(letterClick:) forControlEvents:UIControlEventTouchUpInside];
        [letterView addSubview:letterBtn];
    }
    
}

#pragma mark  省份点击事件
- (void)provinceClick:(UIButton *)button{
    
    NSInteger index = button.tag-1000;
    if (index == 33){//确认
        [self putAway];
    }else if (index == 32){//   删除
        [self deleteText];
    }else{
        
        if (_plateStr.length<8) {
            
            if (_plateStr.length>0) {
                NSArray * provinceArr = @[@"京",@"津",@"晋",@"冀",@"蒙",@"辽",@"黑",@"吉",@"沪",@"苏",@"浙",@"皖",@"闽",@"赣",@"鲁",@"豫",@"鄂",@"湘",@"粤",@"桂",@"琼",@"渝",@"川",@"贵",@"云",@"藏",@"陕",@"甘",@"青",@"宁",@"新",@"W"];
                
                if (![provinceArr containsObject:[_plateStr substringToIndex:1]]) {
                    _plateStr = [NSString stringWithFormat:@"%@%@",button.titleLabel.text,_plateStr?:@""];
                    self.sendTextBlock(_plateStr);
                }
            }else{
                _plateStr = button.titleLabel.text;
                self.sendTextBlock(_plateStr);
            }
        }
        
        self.provinceView.hidden = YES;
        self.letterView.hidden = NO;
        
    }
}
#pragma mark 尾数点击事件
- (void)letterClick:(UIButton *)button{
    
    NSInteger index = button.tag-1000;
    
    if (index == 37){//确认
        [self putAway];
    }else if (index == 36){//   删除
        [self deleteText];
        
    }else{
        
        if (_plateStr.length<8) {
            id <UIKeyInput>keyInput = self.keyInput;
            [keyInput insertText:button.titleLabel.text];
        }
    }
}


#pragma mark 隐藏键盘
- (void)putAway{
    UIResponder *firstResponder = self.keyInput;
    if (firstResponder) {
        [firstResponder resignFirstResponder];
    }
    
    [self resignFirstResponder];
}

#pragma mark 删除数据
- (void)deleteText{
    
    id <UIKeyInput> keyInput = self.keyInput;
    [keyInput deleteBackward];
    
}

#pragma mark 外部设置输入框文字时inputView处理

-(void)setPlateStr:(NSString *)plateStr{
    _plateStr = plateStr;
    
    if (plateStr.length>0) {
        
        NSArray * provinceArr = @[@"京",@"津",@"晋",@"冀",@"蒙",@"辽",@"黑",@"吉",@"沪",@"苏",@"浙",@"皖",@"闽",@"赣",@"鲁",@"豫",@"鄂",@"湘",@"粤",@"桂",@"琼",@"渝",@"川",@"贵",@"云",@"藏",@"陕",@"甘",@"青",@"宁",@"新",@"W"];
        
        if (![provinceArr containsObject:[plateStr substringToIndex:1]]) {
            self.provinceView.hidden = NO;
            self.letterView.hidden = YES;
        }else{
            self.provinceView.hidden = YES;
            self.letterView.hidden = NO;
        }
    }else{
        self.provinceView.hidden = NO;
        self.letterView.hidden = YES;
    }
    
    if (plateStr.length>6) {
        
        UIButton * button = (UIButton *)[self.provinceView viewWithTag:1033];
        button.userInteractionEnabled = YES;
        button.backgroundColor = [UIColor blueColor];
        
        UIButton * button2 = (UIButton *)[self.letterView viewWithTag:1037];
        button2.userInteractionEnabled = YES;
        button2.backgroundColor = [UIColor blueColor];
        
        
    }else{
        UIButton * button = (UIButton *)[self.provinceView viewWithTag:1033];
        button.userInteractionEnabled = NO;
        button.backgroundColor = [UIColor grayColor];
        
        UIButton * button2 = (UIButton *)[self.letterView viewWithTag:1037];
        button2.userInteractionEnabled = NO;
        button2.backgroundColor = [UIColor grayColor];
        
    }
    
}


- (id<UIKeyInput>)keyInput{
    
    id <UIKeyInput> keyInput = _keyInput;
    if (keyInput) {
        return keyInput;
    }
    keyInput = [UIResponder firstResponder];
    
    if (![keyInput conformsToProtocol:@protocol(UITextInput)]) {
        return nil;
    }
    _keyInput = keyInput;
    return keyInput;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
