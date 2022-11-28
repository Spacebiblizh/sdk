//
//  driveViewController.h
//  lizhSDK
//
//  Created by lizh on 2022/11/9.
//

#import <UIKit/UIKit.h>



NS_ASSUME_NONNULL_BEGIN

@interface driveViewController : UIViewController

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic,copy) void (^finishBlock)(UIImage *image);



@end

NS_ASSUME_NONNULL_END
