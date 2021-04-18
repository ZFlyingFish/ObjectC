//
//  XZMessage.m
//  OC底层原理
//
//  Created by 毛 on 2021/3/9.
//

#import "XZMessage.h"
#import <objc/runtime.h>

@implementation XZMessage

void c_other(id self, SEL _cmd)
{
    NSLog(@"c_other - %@ - %@", self, NSStringFromSelector(_cmd));
}

/// 类方法test1 没有实现被调用时 动态方法解析过程 会调用这个方法 动态的给XZMessage的元类对象添加c_other方法
+ (BOOL)resolveClassMethod:(SEL)sel
{
    if (sel == @selector(test1)) {
        // 第一个参数是object_getClass(self)
        class_addMethod(object_getClass(self), sel, (IMP)c_other, "v16@0:8");
        return YES;
    }
    return [super resolveClassMethod:sel];
}

/// 对象方法test 没有实现被调用时 动态方法解析过程 会调用这个方法 动态的给XZMessage的类对象添加c_other方法
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if (sel == @selector(test)) {
        // 动态添加test方法的实现
        class_addMethod(self, sel, (IMP)c_other, "v16@0:8");

        // 返回YES代表有动态添加方法
        return YES;
    }
    return [super resolveClassMethod:sel];
}

@end
