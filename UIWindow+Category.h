//
//  UIWindow+Category.h
//  newSDK
//
//  Created by lizh on 2022/11/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
#define UIEventSubtypeMotionShakeNotification @"UIEventSubtypeMotionShakeNotification"



@interface UIWindow (Category)

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event;
- (BOOL)canBecomeFirstResponder;




@end

NS_ASSUME_NONNULL_END
