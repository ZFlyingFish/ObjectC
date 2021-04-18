//
//  XZPermenantThreadC.h
//  OC底层原理
//
//  Created by 毛 on 2021/3/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^XZPermenantThreadTask)(void);

@interface XZPermenantThreadC : NSObject

/**
 在当前子线程执行一个任务
 */
- (void)executeTask:(XZPermenantThreadTask)task;

/**
 结束线程
 */
- (void)stop;

@end
NS_ASSUME_NONNULL_END
