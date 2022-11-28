//
//  ImageCollectionCell.h
//  lizhSDK
//
//  Created by lizh on 2022/11/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageCollectionCell : UICollectionViewCell

@property (nonatomic, copy) void(^myBlock)(void);
@property (nonatomic, strong) UIImageView *bgImageView;

 

@end

NS_ASSUME_NONNULL_END
