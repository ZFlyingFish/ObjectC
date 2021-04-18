//
//  XZList.m
//  OC底层原理
//
//  Created by 毛 on 2021/3/9.
//

#import "XZList.h"
#import <objc/runtime.h>

@implementation XZList

- (void)text {
    
    
    unsigned int count;

    NSMutableString *methodNames = [NSMutableString string];

    Method *methodList = class_copyMethodList([XZList class], &count);

        // 遍历所有的方法
    for(int i = 0; i < count; i++) {

        // 获得方法
        Method method = methodList[i];

        // 获得方法名
        NSString *methodName = NSStringFromSelector(method_getName(method));
        // 拼接方法名
        [methodNames appendString:methodName];

        [methodNames appendString:@", "];

    }
    
    NSLog(@"方法列表 - %@",methodNames);

    unsigned int count1;
    objc_property_t *propertyList = class_copyPropertyList(self, &count1);

    NSMutableString *properNames = [NSMutableString string];

    for (unsigned int i = 0; i< count1; i++) {
        
        NSString *name = [NSString stringWithUTF8String:property_getName(propertyList[i])];

        // 拼接属性名
        [properNames appendString:name];

        [properNames appendString:@", "];
       
    }
    
    NSLog(@"属性列表 - %@",properNames);
    
    
    
    unsigned int icount;
    Ivar *ivars = class_copyIvarList([[XZList alloc] init], &icount);

    NSMutableString *ivarNames = [NSMutableString string];

    for (int i = 0; i < icount; i++) {
        
        NSString *memberName = [NSString stringWithUTF8String:ivar_getName(ivars[i])];
        // 拼接成员变量名
        [ivarNames appendString:memberName];

        [ivarNames appendString:@", "];
    }
    
    NSLog(@"成员变量列表 - %@",ivarNames);
    
}

@end
