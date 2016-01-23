//
//  NSObject+HttpTask.h
//  Mai
//
//  Created by freedom on 16/1/22.
//  Copyright © 2016年 freedom_luo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (HttpTask)

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
    success:(void(^)(BOOL isSuccess,id result,NSString *error))onSuccess
    failure:(void(^)(NSError *error))onFailure;

/**
 *  缓存接口数据
 *
 *  @param url      请求地址
 *  @param parameters 请求参数
 *
 *  @return url和parameters生成key
 */
-(NSString *)cacheWithUrl:(NSString *)url parameters:(NSDictionary *)parameters;

@end
