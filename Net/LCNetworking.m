//
//  LCNetworking.m
//  lizhSDK
//
//  Created by lizh on 2022/11/11.
//


#import "LCNetworking.h"

NSString *const ResponseErrorKey = @"com.alamofire.serialization.response.error.response";
NSInteger const Interval = 3;

@interface LCNetworking ()

@end

@implementation LCNetworking

+ (void)getWithURL:(NSString *)url Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure{
   // 拼接url及参数
   NSMutableString * str = [NSMutableString string];
   [str appendString:url];
   //当有参数时将参数拼接上去（小编在此做的是url没有拼接参数情况下，如果url已经拼接了参数，这里还传入了一些参数，那么此处的判断需要更改，具体的大家可以来实现）
   if (params.count > 0) {
       if (![str hasSuffix:@"?"]) {
           [str appendString:@"?"];
       }
       //拼接参数
       for (NSString * key in params) {
           
           [str appendFormat:@"%@=%@&", key, params[key]];
       }
       //注意最后一个"&"符号需要去掉
       [str deleteCharactersInRange:NSMakeRange(str.length - 1, 1)];
   }
   str = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"#%^{}\"[]|\\<> "].invertedSet];
   
   // 设置URL
   NSURL * URL = [NSURL URLWithString:str];
   
   // 实例化网络会话.
   NSURLSession * session = [NSURLSession sharedSession];
   
   NSURLSessionDataTask * task = [session dataTaskWithURL:URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       if (data) {
           //利用iOS自带原生JSON解析data数据 保存为Dictionary
           NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
           success(dict);
           
       }else{
           NSHTTPURLResponse *httpResponse = error.userInfo[ResponseErrorKey];
           
           if (httpResponse.statusCode != 0) {
               
               NSString *ResponseStr = [self showErrorInfoWithStatusCode:httpResponse.statusCode];
               failure(ResponseStr);
               
           } else {
               NSString *ErrorCode = [self showErrorInfoWithStatusCode:error.code];
               failure(ErrorCode);
           }
       }
   }];
   [task resume];
}


//原生POST请求
+ (void)postWithURL:(NSString *)url Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure{
   
   NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
   [request setHTTPMethod:@"POST"];
   
   //把字典中的参数进行拼接
   NSString *body = [self dealWithParam:params];
   NSData *bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
   
   //设置请求体
   [request setHTTPBody:bodyData];
   //设置本次请求的数据请求格式
   [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
   // 设置本次请求请求体的长度(因为服务器会根据你这个设定的长度去解析你的请求体中的参数内容)
   [request setValue:[NSString stringWithFormat:@"%ld", bodyData.length] forHTTPHeaderField:@"Content-Length"];
   //设置请求最长时间
   request.timeoutInterval = Interval;
   
   NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       
       if (data) {
           //利用iOS自带原生JSON解析data数据 保存为Dictionary
           NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
           success(dict);
           
       }else{
           NSHTTPURLResponse *httpResponse = error.userInfo[ResponseErrorKey];
           
           if (httpResponse.statusCode != 0) {
               
               NSString *ResponseStr = [self showErrorInfoWithStatusCode:httpResponse.statusCode];
               failure(ResponseStr);
               
           } else {
               NSString *ErrorCode = [self showErrorInfoWithStatusCode:error.code];
               failure(ErrorCode);
           }
       }
   }];
   [task resume];
}

#pragma mark -- 拼接参数
+ (NSString *)dealWithParam:(NSDictionary *)param
{
   NSArray *allkeys = [param allKeys];
   NSMutableString *result = [NSMutableString string];
   
   for (NSString *key in allkeys) {
       NSString *string = [NSString stringWithFormat:@"%@=%@&", key, param[key]];
       [result appendString:string];
   }
   return result;
}


#pragma mark
+ (NSString *)showErrorInfoWithStatusCode:(NSInteger)statusCode{
   
   NSString *message = nil;
   switch (statusCode) {
       case 401: {
           
       }
           break;
           
       case 500: {
           message = @"服务器异常！";
       }
           break;
           
       case -1001: {
           message = @"网络请求超时，请稍后重试！";
       }
           break;
           
       case -1002: {
           message = @"不支持的URL！";
       }
           break;
           
       case -1003: {
           message = @"未能找到指定的服务器！";
       }
           break;
           
       case -1004: {
           message = @"服务器连接失败！";
       }
           break;
           
       case -1005: {
           message = @"连接丢失，请稍后重试！";
       }
           break;
           
       case -1009: {
           message = @"互联网连接似乎是离线！";
       }
           break;
           
       case -1012: {
           message = @"操作无法完成！";
       }
           break;
           
       default: {
           message = @"网络请求发生未知错误，请稍后再试！";
       }
           break;
   }
   return message;
   
}



@end
