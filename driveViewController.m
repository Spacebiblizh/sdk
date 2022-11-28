//
//  driveViewController.m
//  lizhSDK
//
//  Created by lizh on 2022/11/9.
//

#import "driveViewController.h"
#import "SHLiveCourseLivingDrawContextView.h"//画板
#import "SHLiveCourseLivingRightToolView.h"//右侧工具列表
#import "SHLiveCourseLivingDrawToolView.h"//画画工具视图
#import "SHLiveCourseLivingPenSetView.h"//笔-设置
#import "SHLiveCourseLivingEraserSetView.h"//橡皮擦设置
#import "YGPopUpTool.h"

#import "ImageManage.h"



#define bgColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define screenW  [UIScreen mainScreen].bounds.size.width
#define screenH  [UIScreen mainScreen].bounds.size.height
#define nagivationHeight (screenH >= 812.0 ? 88 : 64)
#define navHeightStatus [[UIApplication sharedApplication] statusBarFrame].size.height


@interface driveViewController ()

@property (nonatomic , strong) SHLiveCourseLivingDrawContextView                *drawContextView;//画板
@property (nonatomic , strong) SHLiveCourseLivingRightToolView                  *toolView;//工具栏
@property (nonatomic , strong) SHLiveCourseLivingDrawToolView                   *drawView;//画画工具视图
@property (nonatomic , strong) SHLiveCourseLivingPenSetView                     *penSetView;//笔-设置
@property (nonatomic , strong) SHLiveCourseLivingEraserSetView                  *eraserSetView;//橡皮擦-设置
@property (nonatomic , strong) UIImageView                  *bgImageView;//橡皮擦-设置

@property (nonatomic, strong) UIView *saveView;

@property (nonatomic, strong) UIButton *ereaseButton;
@property (nonatomic, strong) UIButton *penButton;




@end

@implementation driveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = bgColor(239,237,244);
    [self.view addSubview:[self headView:CGRectMake(0, 0, screenW, nagivationHeight)]];

    
    UIView *_saveView = [[UIView alloc] initWithFrame:CGRectMake(60, nagivationHeight + 30, screenW - 120, screenH - nagivationHeight -80 - 60)];
    _saveView.backgroundColor = bgColor(239,237,244);
    _saveView.layer.masksToBounds = YES;
    _saveView.layer.cornerRadius = 8.0f;
    [self.view addSubview:_saveView];
    self.saveView = _saveView;
    
    
    self.bgImageView = [[UIImageView alloc] init];
    self.bgImageView.frame = CGRectMake(0, 0, CGRectGetWidth(_saveView.frame), CGRectGetHeight(_saveView.frame ));
     self.bgImageView.layer.masksToBounds = YES;
    self.bgImageView.layer.cornerRadius = 8.0f;
    self.bgImageView.layer.masksToBounds = YES;
    self.bgImageView.image = self.imageView;
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [_saveView addSubview:self.bgImageView];
    [_saveView addSubview:self.drawContextView];
    
    [self.view addSubview:[self footView:CGRectMake(0, CGRectGetMaxY(self.saveView.frame) + 20, screenW, 60)]];
 
 }


- (UIView *)footView : (CGRect) frame {
    
    UIView *_view = [[UIView alloc] initWithFrame:frame];
    
    CGFloat w = (screenW - 120)/4;
    
    UIButton *one = [UIButton new];
    one.frame = CGRectMake(60, 0, w, frame.size.height);
    [one setImage:[ImageManage imageWithName:@"driveClean"] forState:UIControlStateNormal];

    [one addTarget:self action:@selector(cleanClick) forControlEvents:UIControlEventTouchUpInside];
    [_view addSubview:one];
    
    
    UIButton *two = [UIButton new];
    two.frame = CGRectMake(CGRectGetMaxX(one.frame), 0, w, frame.size.height);
    [two setImage:[ImageManage imageWithName:@"driveErease_n"] forState:UIControlStateNormal];
    [two setImage:[ImageManage imageWithName:@"driveErease_s"] forState:UIControlStateSelected];


    [two addTarget:self action:@selector(ereaseClick:) forControlEvents:UIControlEventTouchUpInside];
    self.ereaseButton = two;
    [_view addSubview:two];
    
    UIButton *three = [UIButton new];
    three.frame = CGRectMake( CGRectGetMaxX(two.frame), 0,w, frame.size.height);
    [three setImage:[ImageManage imageWithName:@"drivePen_n"] forState:UIControlStateNormal];
    [three setImage:[ImageManage imageWithName:@"drivePen_s"] forState:UIControlStateSelected];
    three.selected = YES;

    [three addTarget:self action:@selector(penClick:) forControlEvents:UIControlEventTouchUpInside];
    self.penButton = three;
    [_view addSubview:three];
    
    UIButton *four = [UIButton new];
    four.frame = CGRectMake(CGRectGetMaxX(three.frame),0,  w, frame.size.height);
    [four setImage:[ImageManage imageWithName:@"driveColor"] forState:UIControlStateNormal];

    [four addTarget:self action:@selector(colorClick) forControlEvents:UIControlEventTouchUpInside];

    [_view addSubview:four];

    return _view;
    
}

- (void)cleanClick{
    
    [self.drawContextView deleteOfSelected];
    
}

- (void)ereaseClick:(UIButton *)sender{
    
    if(sender.selected == YES){
        
        self.ereaseButton.selected = YES;
        self.penButton.selected = NO;
        
    }else{
        self.ereaseButton.selected = YES;
        self.penButton.selected = NO;
    }
    
    
    self.drawContextView.type  = 3;
    self.drawContextView.selectSize = @"12";
}

- (void)penClick:(UIButton *)sender{
    if(sender.selected == YES){
        
        self.ereaseButton.selected = NO;
        self.penButton.selected = YES;
        
    }else{
        self.ereaseButton.selected = NO;
        self.penButton.selected = YES;
    }
    
    
    self.drawContextView.selectSize = @"4";
    self.drawContextView.type = 2;
    self.drawContextView.selectColor = UIColor.redColor;
    self.drawContextView.selectTypeIndex = 2;


}

- (UIView *)colorView : (CGRect) frame{
    
    UIView *_view = [[UIView alloc] initWithFrame:frame];
    _view.backgroundColor = bgColor(239,237,244);

    CGFloat w = (screenW - 40)/7;
    
    CGFloat l = (w - 20) / 2;
    
    UIButton *one = [UIButton new];
    one.tag = 1;
    one.frame = CGRectMake(20 , 20, w - 20,  w - 20);
    one.layer.cornerRadius = l;
    one.layer.masksToBounds = YES;
     one.backgroundColor = UIColor.redColor;
    [one addTarget:self action:@selector(cleanchooseClick:) forControlEvents:UIControlEventTouchUpInside];
    [_view addSubview:one];
    
    
    UIButton *two = [UIButton new];
    two.tag = 2;
    two.frame = CGRectMake(20 + (1 * w ), 20, w - 20,  w - 20);
    two.layer.cornerRadius = l;
    two.layer.masksToBounds = YES;
    [two addTarget:self action:@selector(cleanchooseClick:) forControlEvents:UIControlEventTouchUpInside];
    two.backgroundColor = UIColor.yellowColor;

    [_view addSubview:two];
    
    UIButton *three = [UIButton new];
    three.tag = 3;
    three.layer.cornerRadius = l;
    three.layer.masksToBounds = YES;
    three.frame = CGRectMake( 20 + (2 * w ), 20, w - 20,  w - 20);
    [three addTarget:self action:@selector(cleanchooseClick:) forControlEvents:UIControlEventTouchUpInside];
    three.backgroundColor = UIColor.greenColor;

    [_view addSubview:three];
    
    UIButton *four = [UIButton new];
    four.tag = 4;
    four.layer.cornerRadius = l ;
    four.layer.masksToBounds = YES;
    four.frame = CGRectMake(20 + (3 * w ),20, w - 20,  w - 20);
    [four addTarget:self action:@selector(cleanchooseClick:) forControlEvents:UIControlEventTouchUpInside];
    four.backgroundColor = UIColor.blueColor;

    [_view addSubview:four];
    
    UIButton *five = [UIButton new];
    five.tag = 5;
    five.layer.cornerRadius = l;
    five.layer.masksToBounds = YES;
    five.frame = CGRectMake(20 + (4 * w ),20, w - 20,  w - 20);
    [five addTarget:self action:@selector(cleanchooseClick:) forControlEvents:UIControlEventTouchUpInside];
    five.backgroundColor = UIColor.purpleColor;

    [_view addSubview:five];
    
    UIButton *six = [UIButton new];
    six.tag = 6;
    six.layer.cornerRadius = l;
    six.layer.masksToBounds = YES;
    six.frame = CGRectMake(20 + (5 * w ),20, w - 20,  w - 20);
    [six addTarget:self action:@selector(cleanchooseClick:) forControlEvents:UIControlEventTouchUpInside];
    six.backgroundColor = UIColor.darkGrayColor;
    [_view addSubview:six];
    
    UIButton *seven = [UIButton new];
    seven.tag = 7;
    seven.frame = CGRectMake(20 + (6 * w ),20, w - 20,  w - 20);
    [seven setImage:[ImageManage imageWithName:@"newClose"] forState:UIControlStateNormal];
    [seven addTarget:self action:@selector(cleanchooseClick:) forControlEvents:UIControlEventTouchUpInside];
    [_view addSubview:seven];
    

    return _view;
}


- (void)cleanchooseClick:(UIButton *)sender{
    
    [[YGPopUpTool  sharedYGPopUpTool] cloaseWithBlock:nil];

    
    if(sender.tag == 1){
        
        self.drawContextView.type = 2;
        self.drawContextView.selectColor = UIColor.redColor;
        self.drawContextView.selectTypeIndex = 2;
        self.drawContextView.selectSize = @"4";

        
    }else if(sender.tag == 2){

        self.drawContextView.type = 2;
        self.drawContextView.selectColor = UIColor.yellowColor;
        self.drawContextView.selectTypeIndex = 2;
        self.drawContextView.selectSize = @"4";

    }else if(sender.tag == 3){
        self.drawContextView.type = 2;
        self.drawContextView.selectColor = UIColor.greenColor;
        self.drawContextView.selectTypeIndex = 2;
        self.drawContextView.selectSize = @"4";

    }else if(sender.tag == 4){
        self.drawContextView.type = 2;
        self.drawContextView.selectColor = UIColor.blueColor;
        self.drawContextView.selectTypeIndex = 2;
        self.drawContextView.selectSize = @"4";

    }else if(sender.tag == 5){
        self.drawContextView.type = 2;
        self.drawContextView.selectColor = UIColor.purpleColor;
        self.drawContextView.selectTypeIndex = 2;
        self.drawContextView.selectSize = @"4";

    }else if(sender.tag == 6){
        self.drawContextView.type = 2;
        self.drawContextView.selectColor = UIColor.darkGrayColor;
        self.drawContextView.selectTypeIndex = 2;
        self.drawContextView.selectSize = @"4";

    }else if(sender.tag == 7){

        [[YGPopUpTool  sharedYGPopUpTool] cloaseWithBlock:nil];

    }
    
    
}
- (void)colorClick{
    

    [[YGPopUpTool sharedYGPopUpTool] popUpWithPresentView:[self colorView:CGRectMake(0, 0, screenW, 80)] bgColor:UIColor.redColor animated:YES]; ;
    
}

- (UIView *)headView :(CGRect) frame{
    UIView *_view = [[UIView alloc] initWithFrame:frame];
    
    
    UIButton *back = [UIButton new];
    back.frame = CGRectMake(20, 20, 40, frame.size.height);
//    [back setTitle:@"back" forState:UIControlStateNormal];
    [back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [back setImage:[ImageManage imageWithName:@"newClose"] forState:UIControlStateNormal];

    [back addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [_view addSubview:back];
    
    
    UIButton *close = [UIButton new];
    close.frame = CGRectMake(screenW - 20 - 60, 20, 60, frame.size.height);
//    [close setTitle:@"close" forState:UIControlStateNormal];
//    [close setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    [close setImage:[ImageManage imageWithName:@"newSure"] forState:UIControlStateNormal];

    [_view addSubview:close];
    
    return  _view;
    
    
}

- (void)sureClick{
    
    self.finishBlock([self saveImage]);
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    
}

- (void)backClick{
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (UIImage *)saveImage {
    //第一个参数表示区域大小 第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    CGSize size = CGSizeMake(self.saveView.layer.bounds.size.width, self.saveView.layer.bounds.size.height);
//    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    [self.saveView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;

}

- (SHLiveCourseLivingDrawContextView *)drawContextView//画板
{
    if (!_drawContextView) {
        _drawContextView = [[SHLiveCourseLivingDrawContextView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.saveView.frame), CGRectGetHeight(self.saveView.frame ))];
        _drawContextView.layer.masksToBounds = YES;
        _drawContextView.layer.cornerRadius = 8.0f;
        _drawContextView.selectColor = UIColor.redColor;
        _drawContextView.selectTypeIndex = 2;
        _drawContextView.selectSize = @"4";
        _drawContextView.type = 2;
    }
    return _drawContextView;
}


@end
