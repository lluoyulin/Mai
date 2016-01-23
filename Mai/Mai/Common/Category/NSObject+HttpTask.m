//
//  NSObject+HttpTask.m
//  Mai
//
//  Created by freedom on 16/1/22.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import "NSObject+HttpTask.h"

#import "NSString+Utils.h"
#import "NSObject+DataConvert.h"

#import "AFHTTPSessionManager.h"

@implementation NSObject (HttpTask)

/**
 *  post请求
 *
 *  @param url        请求地址
 *  @param parameters 请求参数
 *  @param cache      是否缓存数据，如果是，那么会使用url和parameters生成key将接口返回的"reuslt"节点值保存到NSUserDefaults
 *  @param success    请求成功，如果接口返回的"isSuccess"节点值是1，则接口返回"result",反之，接口返回"error"
 *  @param failure    请求失败，返回NSError
 */
-(void)post:(NSString *)url
 parameters:(id)parameters
      cache:(BOOL)cache
    success:(void (^)(BOOL, id, NSString *))onSuccess
    failure:(void (^)(NSError *))onFailure{
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic=(NSDictionary *)responseObject;
        int isSuccess=[[dic objectForKey:@"isSuccess"] intValue];
        
        if (isSuccess==1) {//成功
            //缓存数据
            if (cache) {
                NSString *key=[self cacheKeyWithUrl:url parameters:parameters];
                
                [[NSUserDefaults standardUserDefaults] setObject:[self toJSonWithNSArrayOrNSDictionary:[dic objectForKey:@"result"]] forKey:key];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            onSuccess(YES,[dic objectForKey:@"result"],@"");
        }
        else{//失败
            onSuccess(NO,@"",[dic objectForKey:@"error"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        onFailure(error);
        
    }];
    
}

/**
 *  获取缓存数据
 *
 *  @param url        请求地址
 *  @param parameters 请求参数
 *
 *  @return url和parameters生成key的NSUserDefaults中数据
 */
-(NSString *)cacheWithUrl:(NSString *)url parameters:(NSDictionary *)parameters{
    NSString *key=[self cacheKeyWithUrl:url parameters:parameters];
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

/**
 *  生成缓存key
 *
 *  @param url        请求地址
 *  @param parameters 请求参数
 *
 *  @return url和parameters生成key
 */
-(NSString *)cacheKeyWithUrl:(NSString *)url parameters:(NSDictionary *)parameters{
    NSData *data = [NSJSONSerialization dataWithJSONObject:parameters options:kNilOptions error:nil];
    NSMutableString *key = [[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [key appendString:url];
    return [key md5];
}

@end
