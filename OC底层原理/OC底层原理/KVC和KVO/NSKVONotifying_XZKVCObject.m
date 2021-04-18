//
//  NSKVONotifying_XZKVCObject.m
//  OC底层原理
//
//  Created by 毛 on 2021/2/23.
//

#import "NSKVONotifying_XZKVCObject.h"

@implementation NSKVONotifying_XZKVCObject

- (void)setAge:(int)age
{
    _NSSetIntValueAndNotify();
}

// 伪代码
void _NSSetIntValueAndNotify()
{
    [self willChangeValueForKey:@"name"];
    [super setAge:age];
    [self didChangeValueForKey:@"name"];
}

- (void)didChangeValueForKey:(NSString *)key
{
    // 通知监听器，某某属性值发生了改变
    [oberser observeValueForKeyPath:key ofObject:self change:nil context:nil];
}


// 屏幕内部实现，隐藏了NSKVONotifying_XZKVCObject类的存在
- (Class)class
{
    return [XZKVCObject class];
}

- (void)dealloc
{
    // 收尾工作
}

- (BOOL)_isKVOA
{
    return YES;
}


@end
