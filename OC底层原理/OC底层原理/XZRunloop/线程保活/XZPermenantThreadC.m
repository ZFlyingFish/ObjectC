//
//  XZPermenantThreadC.m
//  OC底层原理
//
//  Created by 毛 on 2021/3/17.
//

#import "XZPermenantThreadC.h"

#pragma mark - 创建线程子类  观察线程销毁状态
@interface XZThread1 : NSThread

@end

@implementation XZThread1

- (void)dealloc{
    
    NSLog(@"%s", __func__);
}

@end


@interface XZPermenantThreadC ()

@property (strong, nonatomic) XZThread1 *innerThread;

@end

@implementation XZPermenantThreadC

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.innerThread = [[XZThread1 alloc] initWithBlock:^{
            
            // 创建上下文（要初始化一下结构体）
            CFRunLoopSourceContext context = {0};
            
            // 创建source
            CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
            
            // 往Runloop中添加source
            CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
            
            // 销毁source
            CFRelease(source);
            
            // 启动  本次启动循环 执行完source后 会休眠不会退出runloop  所以不用写个while循环当循环结束之后再开启动一个循环
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, false);
            
//            while (weakSelf && !weakSelf.isStopped) {
//                // 第3个参数：returnAfterSourceHandled，设置为true，代表执行完source后就会退出当前loop
//                CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, true);
//            }
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
    
    // 结束本次循环
    CFRunLoopStop(CFRunLoopGetCurrent());
    // 清空线程指针
    self.innerThread = nil;
}



/// 工具类销毁的时候结束想成
- (void)dealloc {
        
    [self stop];
}
@end
