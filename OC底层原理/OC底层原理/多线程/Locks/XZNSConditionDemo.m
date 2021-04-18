//
//  XZNSConditionDemo.m
//  OC底层原理  对mutex 条件锁的封装
//
//  Created by 毛 on 2021/3/19.
//

#import "XZNSConditionDemo.h"

@interface XZNSConditionDemo ()

@property (strong, nonatomic) NSCondition *condition;
@property (strong, nonatomic) NSMutableArray *data;

@end


@implementation XZNSConditionDemo


- (instancetype)init
{
    if (self = [super init]) {
        self.condition = [[NSCondition alloc] init];
        self.data = [NSMutableArray array];
    }
    return self;
}

- (void)otherTest
{
    [[[NSThread alloc] initWithTarget:self selector:@selector(__remove) object:nil] start];
    
    [[[NSThread alloc] initWithTarget:self selector:@selector(__add) object:nil] start];
}

// 生产者-消费者模式

// 线程1
// 删除数组中的元素
- (void)__remove
{
    [self.condition lock];
    NSLog(@"__remove - begin");
    
    if (self.data.count == 0) {
        // 等待
        [self.condition wait];
    }
    
    [self.data removeLastObject];
    NSLog(@"删除了元素");
    
    [self.condition unlock];
}

// 线程2
// 往数组中添加元素
- (void)__add
{
    [self.condition lock];
    
    sleep(1);
    
    [self.data addObject:@"Test"];
    NSLog(@"添加了元素");
    
    // 信号
    [self.condition signal];
    
    sleep(2);
    
    [self.condition unlock];
}

@end
