//
//  XZOSUnfairLockDemo.m
//  OC底层原理
//
//  Created by 毛 on 2021/3/19.
//

#import "XZOSUnfairLockDemo.h"
#import <os/lock.h>

@interface XZOSUnfairLockDemo ()

@property(nonatomic, assign) os_unfair_lock moneyLock;
@property(nonatomic, assign) os_unfair_lock ticketLock;

@end

@implementation XZOSUnfairLockDemo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.moneyLock = OS_UNFAIR_LOCK_INIT;
        self.ticketLock = OS_UNFAIR_LOCK_INIT;

    }
    return self;
}

- (void)__saleTicket
{
    os_unfair_lock_lock(&_ticketLock);
    
    [super __saleTicket];
    
    os_unfair_lock_unlock(&_ticketLock);
}

- (void)__saveMoney
{
    os_unfair_lock_lock(&_moneyLock);
    
    [super __saveMoney];
    
    os_unfair_lock_unlock(&_moneyLock);
}

- (void)__drawMoney
{
    os_unfair_lock_lock(&_moneyLock);
    
    [super __drawMoney];
    
    os_unfair_lock_unlock(&_moneyLock);
}


@end
