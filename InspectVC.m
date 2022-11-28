//
//  InspectVC.m
//
//
//  Created by lizh on 2022/11/10.
//

#import "InspectVC.h"
#import "ImageManage.h"


#define bgColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define screenW  [UIScreen mainScreen].bounds.size.width
#define screenH  [UIScreen mainScreen].bounds.size.height
#define nagivationHeight (screenH >= 812.0 ? 88 : 64)
#define navHeightStatus [[UIApplication sharedApplication] statusBarFrame].size.height

@interface InspectVC (){
    UIControl *inspect;

}


@end

@implementation InspectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = bgColor(239,237,244);

    // Do any additional setup after loading the view.
    [self createView];
}

- (void)createView{
    
    [self.view addSubview:[self headView:CGRectMake(0, 0, screenW, nagivationHeight)]];

    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(20,nagivationHeight , 300, 60);
    label.text = @"Metadata and info";
    label.textColor = UIColor.blackColor;
    label.font = [UIFont boldSystemFontOfSize:35];
    [self.view addSubview:label];
    
    
    UIControl *tickettype = [self _ticketMetadata:CGRectMake(20, CGRectGetMaxY(label.frame) + 10, screenW - 40, 60)];
    [self.view addSubview:tickettype];
    

    UIControl *description = [self _UserMetadata:CGRectMake(20, CGRectGetMaxY(tickettype.frame) + 20, screenW - 40, 60)];
    [self.view addSubview:description];
    
    inspect = [self _automaticallydata:CGRectMake(20, CGRectGetMaxY(description.frame) + 20, screenW - 40, 150)];
//    [inspect addTarget:self action:@selector(inspectClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:inspect];
    
    
}


- (UIView *)headView :(CGRect) frame{
    UIView *_view = [[UIView alloc] initWithFrame:frame];
    
    
    UIButton *back = [UIButton new];
    back.frame = CGRectMake(20, 20, 40, frame.size.height);
    [back setImage:[ImageManage imageWithName:@"newBack"] forState:UIControlStateNormal];
//    [back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [_view addSubview:back];
    
    
    UIButton *close = [UIButton new];
    close.frame = CGRectMake(screenW - 20 - 60, 20, 60, frame.size.height);
    [close setImage:[ImageManage imageWithName:@"newClose"] forState:UIControlStateNormal];
//    [close setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [_view addSubview:close];
    
    return  _view;

}

- (void)backClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIControl *)_ticketMetadata: (CGRect ) frame{
    
    UIControl *_type = [[UIControl alloc] init];
    _type.frame = frame;
    _type.layer.cornerRadius = 8;
    _type.layer.masksToBounds = YES;
    _type.backgroundColor = UIColor.whiteColor;
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(20, 10, 200, 20);
    label.text = @"Ticket metadata";
    label.textColor = bgColor(123,123,123);
    label.font = [UIFont systemFontOfSize:14];
    [_type addSubview:label];
    
    UILabel *labelValue = [[UILabel alloc]init];
    labelValue.frame = CGRectMake(20, 30, 200, 20);
    labelValue.text = @"/";
    labelValue.textColor = UIColor.blackColor;
    labelValue.font = [UIFont systemFontOfSize:14];
    [_type addSubview:labelValue];
    
    
    return _type;
}


- (UIControl *)_UserMetadata: (CGRect ) frame{
    
    UIControl *_type = [[UIControl alloc] init];
    _type.frame = frame;
    _type.layer.cornerRadius = 8;
    _type.layer.masksToBounds = YES;
    _type.backgroundColor = UIColor.whiteColor;
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(20, 10, 200, 20);
    label.text = @"User metadata";
    label.textColor = bgColor(123,123,123);
    label.font = [UIFont systemFontOfSize:14];
    [_type addSubview:label];
    
    UILabel *labelValue = [[UILabel alloc]init];
    labelValue.frame = CGRectMake(20, 30, 200, 20);
    labelValue.text = @"/";
    labelValue.textColor = UIColor.blackColor;
    labelValue.font = [UIFont systemFontOfSize:14];
    [_type addSubview:labelValue];
    
    
    return _type;
}

- (UIControl *)_automaticallydata: (CGRect ) frame{
    
    UIControl *_type = [[UIControl alloc] init];
    _type.frame = frame;
    _type.layer.cornerRadius = 8;
    _type.layer.masksToBounds = YES;
    _type.backgroundColor = UIColor.whiteColor;
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(20, 10, 200, 20);
    label.text = @"User metadata";
    label.textColor = bgColor(123,123,123);
    label.font = [UIFont systemFontOfSize:14];
    [_type addSubview:label];
    
    NSDictionary *dict = @{
//        @"{":@"",
        @"App version":@"1.0.0",
        @"Device":@"iPhone 7 Plus",
        @"Locale":@"en-TG",
        @"Network":@"WIFi",
        @"Locale":@"80%.2389 out of 2998 MB",
        @"OS":@"15.3.0",
//        @"}":@"",

    };
    
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString * string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
//    string = strin
 
    NSString *s = @"{\n";
    NSString *e = @"\n}";
    NSString *center = [self dealWithParam:dict];

    
    UILabel *labelValue = [[UILabel alloc]init];
    labelValue.frame = CGRectMake(20, 30, 300, 400);
    labelValue.text = center;
    labelValue.textColor = UIColor.blackColor;
    labelValue.font = [UIFont systemFontOfSize:14];
    labelValue.numberOfLines = 0;
//    labelValue.backgroundColor = UIColor.redColor;
    [labelValue sizeToFit];
    [_type addSubview:labelValue];
    
    
    return _type;
}


-(NSString *)dealWithParam:(NSDictionary *)param
{
   NSArray *allkeys = [param allKeys];
   NSMutableString *result = [NSMutableString string];
   [result appendString:@"{\n"];

   for (NSString *key in allkeys) {
       NSString *string = [NSString stringWithFormat:@"  \"%@\":\"%@\"\n", key, param[key]];
       [result appendString:string];
   }
    
   [result appendString:@"}"];

   return result;
}

@end
