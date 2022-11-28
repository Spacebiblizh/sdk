//
//  LCNetworking.h
//  lizhSDK
//
//  Created by lizh on 2022/11/11.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
 
typedef void (^SuccessBlock)(id responseObject);
typedef void (^FailureBlock)(NSString *error);
 
 
@interface LCNetworking : NSObject
 
+ (void)getWithURL:(NSString *)url Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;
 
+ (void)postWithURL:(NSString *)url Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)uploadDataWithURL:(NSString *)url postData:(NSDictionary*)postData image:(UIImage *)image;
 

+(void)upload:(NSString *)name filename:(NSString *)filename mimeType:(NSString *)mimeType data:(NSData *)data upUrl:(NSString *)upurl parmas:(NSDictionary *)params complete:(void(^)(NSDictionary *dict))complete;
@end
