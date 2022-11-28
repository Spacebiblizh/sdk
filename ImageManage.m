//
//  ImageManage.m
//  newSDK
//
//  Created by lizh on 2022/11/13.
//

#import "ImageManage.h"



@implementation ImageManage

// MARK:- loazing '.boudle' Image for sdk
+ (UIImage *)imageWithName:(NSString *)name {
    NSBundle *bundle = [self resourcesBundleWithName:@"newBound.bundle"];
    return [self imageInBundle:bundle withName:name];
}
+ (UIImage *)imageInBundle:(NSBundle *)bundle withName:(NSString *)name {

    if (bundle && name) {
        if ([UIImage respondsToSelector:@selector(imageNamed:inBundle:compatibleWithTraitCollection:)]) {
                      
            return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
        } else {
            NSString *imagePath = [[bundle resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", name]];
            return [UIImage imageWithContentsOfFile:imagePath];
        }
    }
    return nil;
}
+ (NSBundle *)resourcesBundleWithName:(NSString *)bundleName {
    NSBundle *bundle = [NSBundle bundleWithPath: [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:bundleName]];
  
    if (!bundle) {

        //动态framework的bundle资源是打包在framework里面的，所以无法通过mainBundle拿到资源，只能通过其他方法来获取bundle资源。
        NSBundle *frameworkBundle = [NSBundle bundleForClass:[self class]];

        NSDictionary *bundleData = [self parseBundleName:bundleName];
 
        if (bundleData) {
            bundle = [NSBundle bundleWithPath:[frameworkBundle pathForResource:[bundleData objectForKey:@"name"] ofType:[bundleData objectForKey:@"type"]]];
        }
    }
    return bundle;
}
+ (NSDictionary *)parseBundleName:(NSString *)bundleName {
    NSArray *bundleData = [bundleName componentsSeparatedByString:@"."];
    if (bundleData.count == 2) {
        return @{@"name":bundleData[0], @"type":bundleData[1]};
    }
    return nil;
}


@end
