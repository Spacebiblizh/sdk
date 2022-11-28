//
//  ImageCollectionCell.m
//  lizhSDK
//
//  Created by lizh on 2022/11/10.
//


#import "ImageCollectionCell.h"
#import "newSDK.h"

@interface ImageCollectionCell ()

@property (nonatomic, strong) UIControl *close;


@end


@implementation ImageCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    
 
    if (self = [super initWithFrame:frame]) {
    
        [self createView];
        
    }
    return self;
}

- (void)deleteClick{
    self.myBlock();
}

 
- (void)createView{
    
 
    self.backgroundColor = UIColor.whiteColor;
    
    self.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1].CGColor;
     self.layer.cornerRadius = 8.0f;
    self.layer.masksToBounds = NO;
    
//    NSString *file2 = [[NSBundle mainBundle] pathForResource:@"testBound.bundle/cut" ofType:@"png"];
//    UIImage *img2 = [self classFunc_imageBundleWithName:@"cut"];
    
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"png"];
    NSData *image = [NSData dataWithContentsOfFile:filePath];

 
    self.bgImageView = [[UIImageView alloc] init];
    self.bgImageView.frame = self.bounds;
     self.bgImageView.layer.masksToBounds = YES;
    self.bgImageView.layer.cornerRadius = 8.0f;
    self.bgImageView.layer.masksToBounds = YES;
    self.bgImageView.image =  [UIImage imageWithData:image];
    self.bgImageView.contentMode = UIViewContentModeScaleToFill;

    [self addSubview:self.bgImageView];
    
    
    UIControl *_description = [[UIControl alloc] init];
    _description.frame = CGRectMake(self.bounds.size.width - 40, 25, 25, 25 );
    _description.layer.cornerRadius = 12.5;
    _description.layer.masksToBounds = YES;
    _description.backgroundColor = UIColor.whiteColor;
    [_description addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    self.close = _description;
    
    UIImage *image2 = [UIImage imageNamed:@"newBound.bundle/newClose"];
 
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.frame = CGRectMake(2.5, 2.5,20,20);
    [bgImageView setImage:image2];
    

    
    [_description addSubview:bgImageView];
    [self addSubview:self.close];
    

}

@end
