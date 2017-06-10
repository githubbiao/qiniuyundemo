//
//  QNToken.m
//  QiniuDemo
//
//  Created by huangqibiao on 2017/6/10.
//  Copyright © 2017年 Aaron. All rights reserved.
//

#import "QNToken.h"

#import <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#import "QNUrlSafeBase64.h"
#import "QN_GTM_Base64.h"

#define AK @"-m3dVT5G-CKMH0nUrw3b_Oi4edJuOqMqcMbiWg-9"
#define SK @"CMH4497Cqt0OZdqQvxbvA2-V6pSHED798KywLkdl"

@implementation QNToken
    
+ (NSString*)dictionryToJSONString:(NSMutableDictionary *)dictionary
    {
        NSError *parseError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&parseError];
        
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
    
    //AccessKey  以及SecretKey
+ (NSString *)token{
    return [self makeToken:AK secretKey:SK];
}
    
    
+ (NSString *)makeToken:(NSString *)accessKey secretKey:(NSString *)secretKey
    {
        //名字
        NSString *baseName = [self marshal];
        baseName = [baseName stringByReplacingOccurrencesOfString:@" " withString:@""];
        baseName = [baseName stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        NSData   *baseNameData = [baseName dataUsingEncoding:NSUTF8StringEncoding];
        NSString *baseNameBase64 = [QNUrlSafeBase64 encodeData:baseNameData];
        NSString *secretKeyBase64 =  [self hmacSha1Key:secretKey textData:baseNameBase64];
        NSString *token = [NSString stringWithFormat:@"%@:%@:%@",  accessKey, secretKeyBase64, baseNameBase64];
        
        return token;
}
    
+ (NSString *)marshal
    {
        time_t deadline;
        time(&deadline);
        //"biaogetest" 是我们七牛账号下创建的储存空间名字“可以自定义”
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:@"biaogetest" forKey:@"scope"];
        //3464706673 是token有效期
        NSNumber *escapeNumber = [NSNumber numberWithLongLong:3464706673];
        [dic setObject:escapeNumber forKey:@"deadline"];
        NSString *json = [self dictionryToJSONString:dic];
        return json;
}
    
+ (NSString *) hmacSha1Key:(NSString*)key textData:(NSString*)text
    {
        const char *cData  = [text cStringUsingEncoding:NSUTF8StringEncoding];
        const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
        uint8_t cHMAC[CC_SHA1_DIGEST_LENGTH];
        CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
        NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:CC_SHA1_DIGEST_LENGTH];
        NSString *hash = [QNUrlSafeBase64 encodeData:HMAC];
        return hash;
}

@end
