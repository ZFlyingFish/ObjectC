//
//  XZMutexLockDemo.m
//  OC底层原理  pthread_mutex_t  默认自旋锁与递归锁
//
//  Created by 毛 on 2021/3/19.
//

#import "XZMutexLockDemo.h"
#import <pthread.h>

@interface XZMutexLockDemo ()

@property (assign, nonatomic) pthread_mutex_t ticketMutex;
@property (assign, nonatomic) pthread_mutex_t moneyMutex;

@end


@implementation XZMutexLockDemo


- (void)__initMutex:(pthread_mutex_t *)mutex
{
    // 1、静态初始化  直接初始化一把锁
    // pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
    
    // 2、
    // 初始化属性
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    // PTHREAD_MUTEX_DEFAULT 默认锁（互斥锁） PTHREAD_MUTEX_RECURSIVE 递归锁允许同一条线程对同一把锁重复加锁
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_DEFAULT);
    // 初始化锁
    pthread_mutex_init(mutex, &attr);
    // 销毁属性
    pthread_mutexattr_destroy(&attr);
    
    //3、直接初始化一把默认锁
    // pthread_mutex_init(mutex, NULL);

}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self __initMutex:&_ticketMutex];
        [self __initMutex:&_moneyMutex];
    }
    return self;
}


- (void)__saleTicket
{
    pthread_mutex_lock(&_ticketMutex);
    
    [super __saleTicket];
    
    pthread_mutex_unlock(&_ticketMutex);
}

- (void)__saveMoney
{
    pthread_mutex_lock(&_moneyMutex);
    
    [super __saveMoney];
    
    pthread_mutex_unlock(&_moneyMutex);
}

- (void)__drawMoney
{
    pthread_mutex_lock(&_moneyMutex);
    
    [super __drawMoney];
    
    pthread_mutex_unlock(&_moneyMutex);
}

- (void)dealloc
{
    pthread_mutex_destroy(&_moneyMutex);
    pthread_mutex_destroy(&_ticketMutex);
}

@end
