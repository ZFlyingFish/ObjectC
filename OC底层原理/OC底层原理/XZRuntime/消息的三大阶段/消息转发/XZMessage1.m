//
//  XZMessage1.m
//  OC底层原理
//
//  Created by 毛 on 2021/3/9.
//

#import "XZMessage1.h"
#import "XZMessage2.h"

@implementation XZMessage1

// test 没找到方法 没有动态解析添加方法 则会走到消息转发第一步 在这方法里返回 新的消息接收对象
//+ (id)forwardingTargetForSelector:(SEL)aSelector
//{
//    if (aSelector == @selector(test)) return [[XZMessage2 alloc] init];
//
//    return [super forwardingTargetForSelector:aSelector];
//}

// 第二部
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    // 本来能调用的方法
    if ([self respondsToSelector:aSelector]) {
        return [super methodSignatureForSelector:aSelector];
    }
    

    //直接获取另一个类的此类找不到方法的编码
    //return [[[XZMessage2 alloc] init] methodSignatureForSelector:aSelector];
    
    // 找不到的方法返回一个新的方法编码  i返回值类型@第一个参数self :第二个参数_cmd i 第三个参数int类型
    return [NSMethodSignature signatureWithObjCTypes:"i@:i"];
}

// 找不到的方法，都会来到这里
- (void)forwardInvocation:(NSInvocation *)anInvocation
{

//    参数顺序：receiver、selector、other arguments
//    int age;
//    [anInvocation getArgument:&age atIndex:2];
//    NSLog(@"%d", age + 10);
    
    
    // 这里
    NSLog(@"找不到%@方法", NSStringFromSelector(anInvocation.selector));
    
    // anInvocation.target == [[XZMessage2 alloc] init]
    // anInvocation.selector == test:
    // anInvocation的参数：15
    // [[[MJCat alloc] init] test:15]
    [anInvocation invokeWithTarget:[[XZMessage2 alloc] init]];
    int ret;
    [anInvocation getReturnValue:&ret];
}

@end
