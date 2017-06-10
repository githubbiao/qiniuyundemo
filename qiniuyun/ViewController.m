//
//  ViewController.m
//  qiniuyun
//
//  Created by huangqibiao on 2017/6/10.
//  Copyright © 2017年 huangqibiao. All rights reserved.
//

#import "ViewController.h"
#import "QiniuSDK.h"
#import "QNToken.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self uploadImageToQNFilePath:@"/Users/huangqibiao/Desktop/资料/IOS面试知识点梳理，掌握这些，轻松面试IOS开发_达内iOS培训.pdf"];

}


- (void)uploadImageToQNFilePath:(NSString *)filePath {
    NSString *token = [QNToken token];
    QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
        builder.zone = [QNZone zone1];
        NSLog(@"%@\n%@\%@\%@\n", [QNZone zone0], [QNZone zone1], [QNZone zone2], [QNZone zoneNa0]);
    }];
    QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
    QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
        NSLog(@"percent == %.2f", percent);
    }
                                                                 params:nil
                                                               checkCrc:NO
                                                     cancellationSignal:nil];
    [upManager putFile:filePath key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        NSLog(@"info ===== %@", info);
        NSLog(@"resp ===== %@", resp);
    }
                option:uploadOption];

}


@end
