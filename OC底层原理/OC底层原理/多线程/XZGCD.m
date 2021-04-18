//
//  XZGCD.m
//  OC底层原理
//
//  Created by 毛 on 2021/3/19.
//

#import "XZGCD.h"

@implementation XZGCD

- (instancetype)init
{
    self = [super init];
    if (self) {
        

    }
    return self;
}

#pragma mark - 同步异步调用
- (void)test0 {
    
    // 创建并发队列
    dispatch_queue_t queue = dispatch_queue_create("my_queue", DISPATCH_QUEUE_CONCURRENT);
    
    // 创建串行队列
    dispatch_queue_t queue1 = dispatch_queue_create("my_queue1", DISPATCH_QUEUE_SERIAL);

    
    // 异步调用并发队列（开启新的线程并发执行任务）
    dispatch_async(queue, ^{
        
    });
    
    // 同步步调用并发队列 （当前线程 串行执行任务）
    dispatch_sync(queue, ^{
        
    });
}


#pragma mark - 线程组使用 dispatch_group_notify 多个任务结束之后统一返回1
- (void)test1 {
    
    // 创建队列组  dispatch_group_create 内部  创建了一个信号为max的信号量
    dispatch_group_t group = dispatch_group_create();
    // 创建并发队列
    dispatch_queue_t queue = dispatch_queue_create("my_queue", DISPATCH_QUEUE_CONCURRENT);
    // 任务添加到异步队列里  队列添加到队列组里  异步执行并发执行任务
    dispatch_group_async(group, queue, ^{
       
        NSLog(@"任务1");
    });
    
    dispatch_group_async(group, queue, ^{
       
        NSLog(@"任务2");
    });
    
    dispatch_group_notify(group, queue, ^{
            
        NSLog(@"任务1和任务2结束之后调用");
        
    });
}

#pragma mark - 线程组使用 dispatch_group_notify 多个任务结束之后统一返回2
- (void)test2 {
    
    // 这个可以用来用时进行多个网络请求 当每个请求都结束之后统一在做一些事情
    // 创建队列组
    dispatch_group_t group = dispatch_group_create();
    // 给队列添加一个输入信号
    dispatch_group_enter(group);
    // 给队列添加一个输出信号
    dispatch_group_leave(group);
    // 当信号 为0 时在主线程调用回调
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{

    });
}

#pragma mark - 信号量
- (void)test3 {
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(5);
    
    for (int i = 0; i < 10; i++) {
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

        NSLog(@"执行任务");

        dispatch_semaphore_signal(semaphore);
    }

    // 信号量控制着同时使用的资源数量 每次执行dispatch_semaphore_wait   semaphore--  当semaphore = 0 时等待资源
    
}


@end
