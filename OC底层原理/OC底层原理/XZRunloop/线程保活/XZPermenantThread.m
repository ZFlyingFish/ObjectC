//
//  XZPermenantThread.m
//  OC底层原理
//
//  Created by 毛 on 2021/3/17.
//

#import "XZPermenantThread.h"


#pragma mark - 创建线程子类  观察线程销毁状态
@interface XZThread : NSThread

@end

@implementation XZThread

- (void)dealloc{
    
    NSLog(@"%s", __func__);
}

@end


@interface XZPermenantThread ()

@property (strong, nonatomic) XZThread *innerThread;
@property (assign, nonatomic, getter=isStopped) BOOL stopped;

@end

@implementation XZPermenantThread

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.stopped = NO;
        
        __weak typeof(self) weakSelf = self;
        
        self.innerThread = [[XZThread alloc] initWithBlock:^{
            
            // 创建好线程之后调用

            [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
            
            
            while (weakSelf && !weakSelf.isStopped) {
                // 开启一个运行循环 运行循环 这个运行循环结束之前 外面的while循环不会调用
                // runMode: beforeDate: 这种方式开启的运行循坏在执行任务之后会退出循环 不是进行休眠 （我的理解）
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
            
            NSLog(@"Runloop 结束");
        }];
        
        [self.innerThread start];
        
    }
    return self;
}



/// 执行的任务
- (void)executeTask:(XZPermenantThreadTask)task {
    
    if (!self.innerThread || !task) return;
    
    // 在子线程里执行任务
    [self performSelector:@selector(__executeTask:) onThread:self.innerThread withObject:task waitUntilDone:NO];
}


/// 结束线程
- (void)stop {
    
    if (!self.innerThread) return;
    
    // 在子线程里执行销毁任务（停止Runloop,销毁线程）
    [self performSelector:@selector(__stop) onThread:self.innerThread withObject:nil waitUntilDone:YES];
}

#pragma mark - private methods
/// 真正的执行任务在这里
- (void)__executeTask:(XZPermenantThreadTask)task {
    
    task();
}

/// 真正的销毁任务在这里
- (void)__stop {
    // 标记停止
    self.stopped = YES;
    // 结束本次循环  这个停止 如果开启循环是oc的方式开启的 则不写也行
    // runMode: beforeDate: 这种方式开启的运行循坏在执行任务之后会退出循环 不是进行休眠 （我的理解）
    // 不写的话 循环一样停止
    CFRunLoopStop(CFRunLoopGetCurrent());
    // 清空线程指针
    self.innerThread = nil;
}



/// 工具类销毁的时候结束想成
- (void)dealloc {
        
    [self stop];
}

@end
