//
//  XZCategory+Test.m
//  OC底层原理
//
//  Created by 毛 on 2021/2/25.
//

#import "XZCategory+Test.h"
#import <objc/runtime.h>

@implementation XZCategory (Test)


- (void)setAge:(int)age {
    
    objc_setAssociatedObject(self, @selector(age), @(age), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (int)age {
    
    // age 方法的隐式参数
    // _cmd == @selector(name)
    return [objc_getAssociatedObject(self, _cmd) intValue];
}

- (void)setName:(NSString *)name {
    
    objc_setAssociatedObject(self, @selector(name), name, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)name {
    
    return objc_getAssociatedObject(self, _cmd);
}

- (void)text {
    
    NSLog(@"分类");
    
}

@end
