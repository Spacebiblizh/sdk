//
//  NewTicke.h
//  lizhSDK
//
//  Created by lizh on 2022/11/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewTicke : UIViewController

@property (nonatomic,copy) void (^backBlock)(NSMutableArray *dataArray,NSString *desc, NSString *type);

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *desc;


@end

NS_ASSUME_NONNULL_END
