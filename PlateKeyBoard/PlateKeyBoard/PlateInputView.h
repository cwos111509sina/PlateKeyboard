//
//  PlateInputView.h
//  PlateKeyBoard
//
//  Created by jsmnzn on 2018/10/29.
//  Copyright © 2018年 test. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlateInputView : UIInputView



@property (nonatomic,weak)id<UIKeyInput> keyInput;
@property (nonatomic,strong)NSString *plateStr;

@property (nonatomic,copy)void (^sendTextBlock)(NSString *plateString);

-(instancetype)init;



@end

NS_ASSUME_NONNULL_END
