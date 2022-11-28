//
//  NewTicke.m
//  lizhSDK
//
//  Created by lizh on 2022/11/8.
//

#import "NewTicke.h"
#import "driveViewController.h"
#import "InspectVC.h"
#import "YGPopUpTool.h"
#import "ImageCollectionCell.h"

#import "LCNetworking.h"
#import "AFNetworking.h"

#import "ImageManage.h"
#import "AFHTTPSessionManager.h"


#define bgColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define screenW  [UIScreen mainScreen].bounds.size.width
#define screenH  [UIScreen mainScreen].bounds.size.height
#define nagivationHeight (screenH >= 812.0 ? 88 : 64)
#define navHeightStatus [[UIApplication sharedApplication] statusBarFrame].size.height


@interface NewTicke ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITextViewDelegate>{
    
    UIScrollView *_scrollView;
    UIControl *inspect;

}
@property (nonatomic, strong) UICollectionView *myCollectionView;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) UILabel *labelVale;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *submit;




@property (nonatomic, strong) NSString *descri;
@end

@implementation NewTicke

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = bgColor(239,237,244);
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

    
    UIControl *c = [[UIControl alloc] initWithFrame:self.view.bounds];
    [c addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:c];
    
    [self setupUI];
    // Do any additional setup after loading the view.
}
- (void)test{
    [self.view endEditing:YES];

}
- (void)leaveEditMode {
  [self.textView resignFirstResponder];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    NSLog(@"----");

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [[self nextResponder] touchesBegan:touches withEvent:event];
//    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
 [self.view endEditing:YES];
}
 
- (void)setupUI{
    
    [self.view addSubview:[self headView:CGRectMake(0, 0, screenW, nagivationHeight)]];
   
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.delegate = self;
    scrollView.frame = CGRectMake(0, nagivationHeight,screenW, screenH - nagivationHeight - 80 - navHeightStatus);
    scrollView.backgroundColor = bgColor(239,237,244);
    [self.view addSubview:scrollView];
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(20, 0, 200, 60);
    label.text = @"New ticket";
    label.textColor = UIColor.blackColor;
    label.font = [UIFont boldSystemFontOfSize:35];
    [scrollView addSubview:label];
    
    UIControl *tickettype = [self _ticketType:CGRectMake(20, CGRectGetMaxY(label.frame) + 10, screenW - 40, 60)];
    [tickettype addTarget:self action:@selector(typeClick) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:tickettype];
    

    UIControl *description = [self _description:CGRectMake(20, CGRectGetMaxY(tickettype.frame) + 20, screenW - 40, 150)];
    [scrollView addSubview:description];
    
    inspect = [self _inspect:CGRectMake(20, CGRectGetMaxY(description.frame) + 20, screenW - 40, 50)];
    [inspect addTarget:self action:@selector(inspectClick) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:inspect];

    [scrollView addSubview:self.myCollectionView];

    scrollView.contentSize = CGSizeMake(screenW, CGRectGetMaxY(self.myCollectionView.frame) + 20);

    
    UIButton *submit = [UIButton new];
    [submit setBackgroundColor:bgColor(209, 196, 233)];
    submit.frame = CGRectMake(20, screenH - 20 - 60, screenW - 40, 50);
    submit.layer.cornerRadius = 8;
    submit.layer.masksToBounds = YES;
    [submit setTitle:@"Submit" forState:UIControlStateNormal];
    [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submit addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    self.submit = submit;
    [self.view addSubview:submit];
    
}



- (UICollectionView *)myCollectionView{
    if (!_myCollectionView) {
        
        // layout 布局
       UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
       layout.minimumLineSpacing = 10.0;
       layout.minimumInteritemSpacing = 10.0;
       layout.sectionInset = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
       layout.itemSize = CGSizeMake(110, 180);
       layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
       layout.footerReferenceSize = CGSizeMake(120, 180);

        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(inspect.frame) + 20,screenW - 40,  200) collectionViewLayout:layout];
        _myCollectionView.backgroundColor = [UIColor clearColor];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        _myCollectionView.showsVerticalScrollIndicator = NO;
        _myCollectionView.showsHorizontalScrollIndicator = NO;
        // 注册cell
        [_myCollectionView registerClass:[ImageCollectionCell class] forCellWithReuseIdentifier:@"cellID"];
        [_myCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
        
    }
    
    return _myCollectionView;
}

- (UIView *)footView{
    if(!_footView){
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 180)];
        _footView.backgroundColor = UIColor.whiteColor;
    }
    return _footView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ImageCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    cell.myBlock = ^{
        NSLog(@"0000---%zd",indexPath.row);
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.myCollectionView reloadData];
        [self changeButton];

        
    };
  
    
    if(self.dataArray.count > 0){
        cell.bgImageView.image = self.dataArray[indexPath.row];
    }
    
    
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reu = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footer" forIndexPath:indexPath];
    UIView * contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 200)];
    UIButton *close = [UIButton new];
    close.frame = CGRectMake(0, 0, 120, 120);
    [close addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:close];
    [reu addSubview:contentView];
    
    
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.frame = CGRectMake(0, 0, 40, 40);
    bgImageView.center = close.center;
    bgImageView.backgroundColor = UIColor.whiteColor;
    bgImageView.layer.cornerRadius = 20;
    bgImageView.layer.masksToBounds = YES;
    bgImageView.image = [ImageManage imageWithName:@"newAdd"];
        
    [contentView addSubview:bgImageView];
    
    
    return reu;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    driveViewController *vc = [driveViewController new];
    vc.imageView = self.dataArray[indexPath.row];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    vc.finishBlock = ^(UIImage * _Nonnull image) {
        [self.dataArray replaceObjectAtIndex:indexPath.row withObject:image];
        [self.myCollectionView reloadData];
        [self changeButton];
    };
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (UIView *)headView :(CGRect) frame{
    UIView *_view = [[UIView alloc] initWithFrame:frame];
    
    
    UIButton *back = [UIButton new];
    back.frame = CGRectMake(20, 20, 40, frame.size.height);
    [back setImage:[ImageManage imageWithName:@"newBack"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [_view addSubview:back];
    
    
//    UIButton *close = [UIButton new];
//    close.frame = CGRectMake(screenW - 20 - 60, 20, 60, frame.size.height);
//    [close setImage:[ImageManage imageWithName:@"newClose"] forState:UIControlStateNormal];
//    [close addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
//    [_view addSubview:close];
//
    return  _view;
    
    
}

- (UIControl *) _inspect: (CGRect) frame{
    UIControl *_inspect = [[UIControl alloc] init];
    _inspect.frame = frame;
    _inspect.layer.cornerRadius = 8;
    _inspect.layer.masksToBounds = YES;
    _inspect.backgroundColor = UIColor.whiteColor;
    
    UILabel *labelValue = [[UILabel alloc]init];
    labelValue.frame = CGRectMake(20, 15, 200, 20);
    labelValue.text = @"Inspect";
    labelValue.textColor = UIColor.blackColor;
    labelValue.font = [UIFont systemFontOfSize:14];
    [_inspect addSubview:labelValue];
    
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.frame = CGRectMake(frame.size.width - 40, 15,20,20);
    bgImageView.image = [ImageManage imageWithName:@"newRight"];
    [_inspect addSubview:bgImageView];
    
    return _inspect;
    
}

- (UIControl *) _description: (CGRect) frame{
    UIControl *_description = [[UIControl alloc] init];
    _description.frame = frame;
    _description.layer.cornerRadius = 8;
    _description.layer.masksToBounds = YES;
    _description.backgroundColor = UIColor.whiteColor;
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(20, 10, 200, 20);
    label.text = @"Description";
    label.textColor = bgColor(123,123,123);
    label.font = [UIFont systemFontOfSize:14];
    [_description addSubview:label];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(label.frame) + 5, frame.size.width - 40, 100)];
    self.textView.text = self.desc;
    self.textView.delegate = self;
    
    [_description addSubview:self.textView];

    return _description;
    
}
-(void)textViewDidChangeSelection:(UITextView *)textView{
    NSLog(@"%@",textView.text);
    
    [self changeButton];
    
}

- (void)addClick{

//    [[YGPopUpTool sharedYGPopUpTool] popUpWithPresentView:[self addAttachView] animated:YES]
    [[YGPopUpTool sharedYGPopUpTool] popUpWithPresentView:[self addAttachView] bgColor:UIColor.yellowColor animated:YES];
    
}
    

- (void)inspectClick{
    
    InspectVC *vc = [InspectVC new];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (void)typeClick{
    
    [[YGPopUpTool sharedYGPopUpTool] popUpWithPresentView:[self ticketView] bgColor:UIColor.yellowColor animated:YES];

    
}

- (void)_ticketTypeClick:(UIButton *)sender{
    [[YGPopUpTool  sharedYGPopUpTool] cloaseWithBlock:nil];
    NSLog(@"%zd",sender.tag);

    if (sender.tag == 1) {
        self.labelVale.text = @"Bug report";
    
        
    }else if(sender.tag == 2){
        self.labelVale.text = @"Improvement suggestion";

    }else if(sender.tag == 3){
        self.labelVale.text = @"Question";

    }
    self.type = self.labelVale.text;
}

- (void)_addAttachViewClick:(UIButton *)sender{
    [[YGPopUpTool  sharedYGPopUpTool] cloaseWithBlock:nil];
    NSLog(@"%zd",sender.tag);

    if (sender.tag == 1) {
        
        self.type = self.labelVale.text;
        self.desc = self.textView.text;
        self.backBlock(self.dataArray, self.desc, self.type);

        
    }else if(sender.tag == 2){

        [self openImage];
    }
}

- (UIView *)ticketView{
    
    UIView *_popView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW, 20 + 60 + 60 + 120 + 40)];
    _popView.backgroundColor = [UIColor whiteColor];

    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(20, 20, screenW - 40, 60);
    label.text = @"Ticket type";
    label.textColor = UIColor.blackColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:28];
    [_popView addSubview:label];
    
    UIControl *_typeBug = [[UIControl alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(label.frame) + 20, screenW - 40, 40)];
    _typeBug.tag = 1;
    [_typeBug addTarget:self action:@selector(_ticketTypeClick:) forControlEvents:UIControlEventTouchUpInside];
    [_popView addSubview:_typeBug];
    
    UILabel *_typeBuglabel = [[UILabel alloc]init];
    _typeBuglabel.frame = CGRectMake(20, 0, screenW - 40, 60);
    _typeBuglabel.text = @"Bug report";
    _typeBuglabel.textColor = UIColor.blackColor;
    _typeBuglabel.textAlignment = NSTextAlignmentLeft;
    _typeBuglabel.font = [UIFont systemFontOfSize:18];
    [_typeBug addSubview:_typeBuglabel];
    
    UIControl *_typesuggestion = [[UIControl alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_typeBug.frame) + 20, screenW - 40, 40)];
    _typesuggestion.tag = 2;
    [_typesuggestion addTarget:self action:@selector(_ticketTypeClick:) forControlEvents:UIControlEventTouchUpInside];

    [_popView addSubview:_typesuggestion];
    
    UILabel *_typesuggestionlabel = [[UILabel alloc]init];
    _typesuggestionlabel.frame = CGRectMake(20, 0, screenW - 40, 60);
    _typesuggestionlabel.text = @"Improvement suggestion";
    _typesuggestionlabel.textColor = UIColor.blackColor;
    _typesuggestionlabel.textAlignment = NSTextAlignmentLeft;
    _typesuggestionlabel.font = [UIFont systemFontOfSize:18];
    [_typesuggestion addSubview:_typesuggestionlabel];

    UIControl *_typequestion = [[UIControl alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_typesuggestion.frame) + 20, screenW - 40, 40)];
    _typequestion.tag = 3;
    [_typequestion addTarget:self action:@selector(_ticketTypeClick:) forControlEvents:UIControlEventTouchUpInside];
    [_popView addSubview:_typequestion];
    
    UILabel *_typequestionlabel = [[UILabel alloc]init];
    _typequestionlabel.frame = CGRectMake(20, 0, screenW - 40, 60);
    _typequestionlabel.text = @"Question";
    _typequestionlabel.textColor = UIColor.blackColor;
    _typequestionlabel.textAlignment = NSTextAlignmentLeft;
    _typequestionlabel.font = [UIFont systemFontOfSize:18];
    [_typequestion addSubview:_typequestionlabel];
    
    return  _popView;
    
}

- (UIView *)addAttachView{
    
    UIView *_popView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW, 20 + 60 + 40 + 80 + 40)];
    _popView.backgroundColor = [UIColor whiteColor];

    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(20, 20, screenW - 40, 60);
    label.text = @"Add attachment";
    label.textColor = UIColor.blackColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:28];
    [_popView addSubview:label];
    
    UIControl *_typeBug = [[UIControl alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(label.frame) + 20, screenW - 40, 40)];
    _typeBug.tag = 1;
    [_typeBug addTarget:self action:@selector(_addAttachViewClick:) forControlEvents:UIControlEventTouchUpInside];
    [_popView addSubview:_typeBug];
    
    UILabel *_typeBuglabel = [[UILabel alloc]init];
    _typeBuglabel.frame = CGRectMake(20, 0, screenW - 40, 60);
    _typeBuglabel.text = @"Grab screenshot";
    _typeBuglabel.textColor = UIColor.blackColor;
    _typeBuglabel.textAlignment = NSTextAlignmentLeft;
    _typeBuglabel.font = [UIFont systemFontOfSize:18];
    [_typeBug addSubview:_typeBuglabel];
    
    UIControl *_typesuggestion = [[UIControl alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_typeBug.frame) + 20, screenW - 40, 40)];
    _typesuggestion.tag = 2;
    [_typesuggestion addTarget:self action:@selector(_addAttachViewClick:) forControlEvents:UIControlEventTouchUpInside];

    [_popView addSubview:_typesuggestion];
    
    UILabel *_typesuggestionlabel = [[UILabel alloc]init];
    _typesuggestionlabel.frame = CGRectMake(20, 0, screenW - 40, 60);
    _typesuggestionlabel.text = @"Pick from gallery";
    _typesuggestionlabel.textColor = UIColor.blackColor;
    _typesuggestionlabel.textAlignment = NSTextAlignmentLeft;
    _typesuggestionlabel.font = [UIFont systemFontOfSize:18];
    [_typesuggestion addSubview:_typesuggestionlabel];
    
    return  _popView;
    
}

- (UIControl *)_ticketType: (CGRect ) frame{
    
    UIControl *_type = [[UIControl alloc] init];
    _type.frame = frame;
    _type.layer.cornerRadius = 8;
    _type.layer.masksToBounds = YES;
    _type.backgroundColor = UIColor.whiteColor;
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(20, 10, 200, 20);
    label.text = @"Ticket type";
    label.textColor = bgColor(123,123,123);
    label.font = [UIFont systemFontOfSize:14];
    [_type addSubview:label];
    
    UILabel *labelValue = [[UILabel alloc]init];
    labelValue.frame = CGRectMake(20, 30, 200, 20);
    labelValue.text = self.type;
    labelValue.textColor = UIColor.blackColor;
    labelValue.font = [UIFont systemFontOfSize:14];
    self.labelVale = labelValue;
    
    [_type addSubview:labelValue];
    
    
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.frame = CGRectMake(frame.size.width - 40, 22,20,20);
    bgImageView.image = [ImageManage imageWithName:@"newDown"];
    [_type addSubview:bgImageView];
    
    return _type;
}


- (void) openImage{
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imgPicker.delegate = self;
    [self presentViewController:imgPicker animated:YES completion:nil];

}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 获取用户选择的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.dataArray addObject:image];
    [self.myCollectionView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self changeButton];
}


    

- (void)backClick{
    
    self.type = @"Improvement suggestion";
    self.desc = @"";
    [self.dataArray removeAllObjects];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject: @"NO" forKey:@"flag"];
    [defaults synchronize];
        
    self.backBlock(self.dataArray, self.desc, self.type);
}

- (void)closeClick{
    
//    [self setClientID];;
}

- (void)submitClick{
    
    [self.view endEditing:YES];
    
    if (CGColorEqualToColor(self.submit.layer.backgroundColor, bgColor(124, 77, 255).CGColor)){
        
        [self submitNet];
            //
    }else{
            
            //
    }
//    if(self.submit.backgroundColor  bgColor(101, 31, 255) )
    
}

- (void)getList{
    
    [LCNetworking getWithURL:@"https://dev.shakeforward.com/api/v1/shake-report-types" Params:nil success:^(id responseObject) {
        
        NSLog(@"-- success--- %@",responseObject);
            
    } failure:^(NSString *error) {
        
        NSLog(@"-- fail");
        
    }];
    
}


- (void)changeButton{
    if(self.textView.text.length > 0 && self.dataArray.count > 0){
        [self.submit setBackgroundColor:bgColor(124, 77, 255)];

        
    }else{
        [self.submit setBackgroundColor:bgColor(209, 196, 233)];

    }
    
}

- (void)submitNet{
    
   AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
//  manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
   [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
   [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"accept"];


   NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if ([self.type isEqualToString: @"Bug report"]) {
        [params setObject:@"bug" forKey:@"type"];

    }else if([self.type isEqualToString :@"Improvement suggestion"]){
        [params setObject:@"upgrade" forKey:@"type"];

    }else if([self.type isEqualToString :@"Question" ]){
        [params setObject:@"question" forKey:@"type"];

    }
    
   [params setObject:self.textView.text forKey:@"description"];
   [params setObject:@{@"report":@"/",@"user":@"/",@"auto":@"/",} forKey:@"meta"];
    
    NSLog(@"%@",params);
    NSLog(@"%@",self.type);


//    [params setObject:@[@""] forKey:@"description"];

  NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
  NSString *defStr = [defaults objectForKey:@"name"];//根据键值取出name
  NSString *token = [NSString stringWithFormat:@"Bearer %@",defStr];
  
  NSLog(@"token----- %@",token);
//    [urlRequest setValue:token forHTTPHeaderField:@"Authorization"];
  [manager.requestSerializer setValue:@"Bearer 21|DybkjlIfmuEIt95wcxaPOdwrVRw1qf5jGGTy6P7c" forHTTPHeaderField:@"Authorization"];
//
//    NSString *url = @"http://192.168.0.109:8005/api/v1/shake-reports";

   NSString *url = @"https://dev.shakeforward.com/api/v1/shake-reports";
  [manager POST:url parameters:params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [self.dataArray enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {

            NSData *imageData = UIImagePNGRepresentation(image);

            if (imageData.length >= 1024 * 1024) {
                //因为我们服务器有限制1M以内   所以我超过1M的进行压缩了
                imageData = UIImageJPEGRepresentation(image, 0.1);
                [formData appendPartWithFileData:imageData name:@"images[0]" fileName:@"kinta.jpg" mimeType:@"image/jpg"];
            }else{

                [formData appendPartWithFileData:imageData name:@"images[1]" fileName:@"kinta.png" mimeType:@"image/png"];
            }

        }];


    } progress:^(NSProgress * _Nonnull uploadProgress) {

        NSLog(@"%@",uploadProgress);

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSLog(@"%@",responseObject);
        [self backClick];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);

    }];
    
  


}

@end
