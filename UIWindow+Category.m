//
//  UIWindow+Category.m
//  newSDK
//
//  Created by lizh on 2022/11/17.
//

#import "UIWindow+Category.h"
#import "MNFloatBtn.h"

@implementation UIWindow (Category)

- (BOOL)canBecomeFirstResponder {//默认是NO，所以得重写此方法，设成YES

return NO;

}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event

{

}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event

{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *defStr = [defaults objectForKey:@"flag"];//根据键值取出name
    if([defStr isEqualToString:@"NO"]){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"push" object:nil userInfo:@{@"msg":@"changeColor"}];

    }

}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event

{

}


@end
