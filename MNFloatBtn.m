//
//  MNFloatBtn.m
//  lizhSDK
//
//  Created by lizh on 2022/11/8.
//

#import "MNFloatBtn.h"
#import "NewTicke.h"
#import "LCNetworking.h"

#define kSystemKeyboardWindowLevel 10000000


@interface MNFloatBtn()

//悬浮的按钮
@property (nonatomic, strong) MNFloatContentBtn *floatBtn;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSString *type_new;
@property (nonatomic, strong) NSString *desc;

@property (strong, nonatomic) UIWindow *window2;


@end

@implementation MNFloatBtn{
    
    MNAssistiveTouchType  _type;
    //拖动按钮的起始坐标点
    CGPoint _touchPoint;
    //起始按钮的x,y值
    CGFloat _touchBtnX;
    CGFloat _touchBtnY;

}

//static
static MNFloatBtn *_floatWindow;



#define screenW  [UIScreen mainScreen].bounds.size.width
#define screenH  [UIScreen mainScreen].bounds.size.height
static CGFloat floatBtnW = 60;
static CGFloat floatBtnH = 60;

- (MNFloatContentBtn *)floatBtn{
    if (!_floatBtn) {
        _floatBtn = [[MNFloatContentBtn alloc]init];
        
        [_floatWindow addSubview:_floatBtn];
        _floatBtn.frame = _floatWindow.bounds;
 
    }
    return _floatBtn;
}

- (NSString *)type_new{
    if (!_type_new) {
        _type_new = @"Improvement suggestion";
    }
    return _type_new;
}

- (NSString *)desc{
    if (!_desc) {
        _desc = @"";
    }
    return _desc;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return  _dataArray;
}


#pragma mark - public Method
+ (UIButton *)sharedBtn{
    return _floatWindow.floatBtn;
}


+ (void)startclient_secret:(NSString *)client_id client_secret:(NSString *)client_secret{
 
    [self showWithType:MNAssistiveTypeNearRight];
    
   

    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject: @"NO" forKey:@"flag"];
    [defaults synchronize];
    
    [MNFloatBtn sharedBtn].btnClick = ^(UIButton *sender) {
        NSLog(@" btn.btnClick ~");
    };
}




+ (void)hidden{
    [_floatWindow setHidden:YES];
}

+ (void)showDebugMode{
#ifdef DEBUG
//    [self show];
#else
#endif
}


+ (void)showDebugModeWithType:(MNAssistiveTouchType)type{
#ifdef DEBUG
    [self showWithType:type];
#else
#endif
}


+ (void)showWithType:(MNAssistiveTouchType)type{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        _floatWindow = [[MNFloatBtn alloc] initWithType:type frame:CGRectZero];
        UIViewController *vc = [[UIViewController alloc]init];
        vc.view.backgroundColor = UIColor.clearColor;
        _floatWindow.rootViewController = vc;
        [_floatWindow p_showFloatBtn];
    });
    
    [_floatWindow showWithType:type];
}

+ (void)setEnvironmentMap:(NSDictionary *)environmentMap
               currentEnv:(NSString *)currentEnv{
}

#pragma mark - private Method
- (void)showWithType:(MNAssistiveTouchType)type{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                  name:@"push" object:nil];
    
    UIWindow *currentKeyWindow = [UIApplication sharedApplication].keyWindow;
    
    if (_floatWindow.hidden) {
        _floatWindow.hidden = NO;
    }
    else if (!_floatWindow) {
        _floatWindow = [[MNFloatBtn alloc] initWithType:type frame:CGRectZero];
        _floatWindow.rootViewController = [UIViewController new];
    }
    
    _floatWindow.backgroundColor = [UIColor clearColor];
    [_floatWindow makeKeyAndVisible];
    _floatWindow.windowLevel = kSystemKeyboardWindowLevel;
    
    [currentKeyWindow makeKeyWindow];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSLog(@"%@",notification);
    [self pushNew];
    
}

- (instancetype)initWithType:(MNAssistiveTouchType)type
                       frame:(CGRect)frame{

    if (self = [super init]) {
        _type = type;
        CGFloat floatBtnX = screenW - floatBtnW;
        CGFloat floatBtnY = 60;
        
        frame = CGRectMake(floatBtnX, floatBtnY, floatBtnW, floatBtnH);
        self.layer.cornerRadius = 60 / 2;
        self.layer.masksToBounds = YES;
        self.frame = frame;
    }
    return self;
}

- (void)p_showFloatBtn{
    self.floatBtn.hidden = NO;
}

#pragma mark - button move
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan:touches withEvent:event];
    
    //按钮刚按下的时候，获取此时的起始坐标
    UITouch *touch = [touches anyObject];
    _touchPoint = [touch locationInView:self];
    
    _touchBtnX = self.frame.origin.x;
    _touchBtnY = self.frame.origin.y;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint currentPosition = [touch locationInView:self];
    
    //偏移量(当前坐标 - 起始坐标 = 偏移量)
    CGFloat offsetX = currentPosition.x - _touchPoint.x;
    CGFloat offsetY = currentPosition.y - _touchPoint.y;
    
    //移动后的按钮中心坐标
    CGFloat centerX = self.center.x + offsetX;
    CGFloat centerY = self.center.y + offsetY;
    self.center = CGPointMake(centerX, centerY);
    
    //父试图的宽高
  
    CGFloat superViewWidth = screenW;
    CGFloat superViewHeight = screenH;
    CGFloat btnX = self.frame.origin.x;
    CGFloat btnY = self.frame.origin.y;
    CGFloat btnW = self.frame.size.width;
    CGFloat btnH = self.frame.size.height;
     
    //x轴左右极限坐标
    if (btnX > superViewWidth-floatBtnW){
        //按钮右侧越界
        CGFloat centerX = superViewWidth - btnW/2;
        self.center = CGPointMake(centerX, centerY);
    }else if (btnX < 0){
        //按钮左侧越界
        CGFloat centerX = btnW * 0.5;
        self.center = CGPointMake(centerX, centerY);
    }
    
    //默认都是有导航条的，有导航条的，父试图高度就要被导航条占据，固高度不够
    CGFloat defaultNaviHeight = 64;
    CGFloat judgeSuperViewHeight = superViewHeight - defaultNaviHeight;
    
    //y轴上下极限坐标
    if (btnY <= 0){
        //按钮顶部越界
        centerY = btnH * 0.7;
        self.center = CGPointMake(centerX, centerY);
    }
    else if (btnY > judgeSuperViewHeight){
        //按钮底部越界
        CGFloat y = superViewHeight - btnH * 0.5;
        self.center = CGPointMake(btnX, y);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    CGFloat btnY = self.frame.origin.y;
    CGFloat btnX = self.frame.origin.x;
    CGFloat minDistance = 2;
    
    //结束move的时候，计算移动的距离是>最低要求，如果没有，就调用按钮点击事件
    BOOL isOverX = fabs(btnX - _touchBtnX) > minDistance;
    BOOL isOverY = fabs(btnY - _touchBtnY) > minDistance;
    
    if (isOverX || isOverY) {
        //超过移动范围就不响应点击 - 只做移动操作
        NSLog(@"move - btn");
        [self touchesCancelled:touches withEvent:event];
    }else{
        [super touchesEnded:touches withEvent:event];
        
        if (_floatBtn.btnClick) {

            [self pushNew];
        }else{
            [self changeEnv];
        }
    }
    
    //设置移动方法
    [self setMovingDirectionWithBtnX:btnX btnY:btnY];
}

- (void)pushNew{
    
    _floatWindow.hidden = YES;
    
    UIWindow *window=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    UIWindow *currentKeyWindow = [UIApplication sharedApplication].keyWindow;
    NewTicke *new = [NewTicke new];
    
    [self.dataArray addObject:[self getImage]];
    new.dataArray = self.dataArray;
    new.type = self.type_new;
    new.desc = self.desc;
    
    
    NSLog(@"%@-- %@",self.desc,self.type_new);
    new.backBlock = ^(NSMutableArray * _Nonnull dataArray, NSString * _Nonnull desc, NSString * _Nonnull type) {
        NSLog(@"%@-- %@",desc,type);

        _floatWindow.hidden = NO;
        self.dataArray = dataArray;
        self.type_new = type;
        self.desc = desc;
        
        self->_window2.hidden = YES;
        

    };
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject: @"YES" forKey:@"flag"];
    [defaults synchronize];
    
    
    window.rootViewController = new;
    window.windowLevel=UIWindowLevelAlert;
    _window2=window;
    [window makeKeyAndVisible];
    
    [currentKeyWindow makeKeyWindow];
}
    
- (UIImage *) getImage{
    UIGraphicsBeginImageContextWithOptions([UIApplication sharedApplication].keyWindow.frame.size, NO, 0.0);
        //2.获取上下文
        CGContextRef ctx=UIGraphicsGetCurrentContext();
        //3.渲染控制器view的图层到上下文，图层只能渲染不能用draw
        [[UIApplication sharedApplication].keyWindow.layer renderInContext:ctx];
        //4.获取截屏图片
        UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
        //5.关闭上下文
        UIGraphicsEndImageContext();
        //6.将截图保存到桌面
        NSData *data=UIImagePNGRepresentation(newImage);
        [data writeToFile:@"/Users/lizh/Desktop/cut.png" atomically:YES];
    
    return newImage ;

    
}

- (void)setMovingDirectionWithBtnX:(CGFloat)btnX btnY:(CGFloat)btnY{
    switch (_type) {
        case MNAssistiveTypeNone:{
            break;
        }
        case MNAssistiveTypeNearLeft:{
            break;
        }
        case MNAssistiveTypeNearRight:{
        }
    }
}

+ (void)setClientIDWith:(NSString *) client_id withClient_secret:(NSString *) client_secret{

        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:@"shakeforward" forKey:@"application_name"];
        [params setObject:@"iOS" forKey:@"application_platform"];
        [params setObject:@"1" forKey:@"application_version_code"];
        [params setObject:@"V1.0" forKey:@"application_version_name"];
        [params setObject:@"iphone7 plus" forKey:@"mobile_model"];
        [params setObject:@"14" forKey:@"mobile_version"];
        [params setObject:client_id forKey:@"client_id"];
        [params setObject:client_secret forKey:@"client_secret"];

        [LCNetworking postWithURL:@"https://dev.shakeforward.com/api/v1/applications" Params:params success:^(id responseObject) {
            
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            [defaults setObject: responseObject[@"token"] forKey:@"name"];
            [defaults synchronize];
            
            NSLog(@"---success--- %@",responseObject);

            
        } failure:^(NSString *error) {
            
            NSLog(@"---fail--- %@",error);

        }];
 
}
    
- (void)changeEnv{
    [self.floatBtn changeEnvironment];
}

- (void )buttonClikc:(UIButton *)sender{

    NSLog(@"button click");
}
    

    
    
@end

