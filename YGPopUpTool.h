//
//  YGPopUpTool.h
//  lizhSDK
//
//  Created by lizh on 2022/11/10.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface YGPopUpTool : NSObject
/**
 点击蒙版是否退出视图
 */
@property (nonatomic, assign) BOOL isClickBackgroudDismiss;

+(YGPopUpTool *)sharedYGPopUpTool;

- (void)popUpWithPresentView:(UIView *)presentView bgColor:(UIColor *)color animated:(BOOL)animated;

-(void)cloaseWithBlock:(void(^)())complete;

@end
