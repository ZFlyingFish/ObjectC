//
//  XZObjectDetail.m
//  OC底层原理
//
//  Created by 毛 on 2021/2/23.
//



#import "XZObjectDetail.h"
#import <objc/runtime.h>
#import <malloc/malloc.h>
#import "XZStudent.h"

@implementation XZObjectDetail

- (void)detail {

    // instance对象，实例对象
    NSObject *object1 = [[NSObject alloc] init];
    NSObject *object2 = [[NSObject alloc] init];

    // class对象，类对象
    // class方法返回的一直是class对象，类对象
    Class objectClass1 = [object1 class];
    Class objectClass2 = [object2 class];
    Class objectClass3 = object_getClass(object1);
    Class objectClass4 = object_getClass(object2);
    Class objectClass5 = [NSObject class];

    // meta-class对象，元类对象
    // 将类对象当做参数传入，获得元类对象
    Class objectMetaClass = object_getClass(objectClass5);

    NSLog(@"instance - %p %p",
          object1,
          object2);
    NSLog(@"class - %p %p %p %p %p %d",
          objectClass1,
          objectClass2,
          objectClass3,
          objectClass4,
          objectClass5,
          class_isMetaClass(objectClass3));
    
    
    

    NSLog(@"objectMetaClass - %p %d", objectMetaClass, class_isMetaClass(objectMetaClass));
    
    Class objectMetaClass1 = [objectClass5 class];

    NSLog(@"objectMetaClass1 - %p %d", objectMetaClass1, class_isMetaClass(objectMetaClass1));

    // 上面打印 实例对象 类对象 元类对象 的地址  泡在模拟器上  用View Memory 上看
    // 实例对象的isa指向类对象 类对象的isa 指向元类对象
    // 如果不跑在模拟器上 运行环境不一样 isa & 一个值才是类对象的地址



    // 获取实例对象的大小 结构体的大小遵循 8字节对齐
    NSLog(@"%zd", class_getInstanceSize([object1 class]));
    // 获取系统为对象分配的大小  遵循16字节对齐
    NSLog(@"%zd", malloc_size((__bridge const void *)object1));

    // 继承状态下
    XZStudent *stu = [[XZStudent alloc] init];
    NSLog(@"stu - %zd", class_getInstanceSize([XZStudent class]));
    NSLog(@"stu - %zd", malloc_size((__bridge const void *)stu));

    /**

        这是 isa和supper指针解释图 的文字解释

    instance的isa指向class

    class的isa指向meta-class

    meta-class的isa指向基类的meta-class

    class的superclass指向父类的class
    如果没有父类，superclass指针为nil

    meta-class的superclass指向父类的meta-class
    基类的meta-class的superclass指向基类的class

    instance调用对象方法的轨迹
    isa找到class，方法不存在，就通过superclass找父类

    class调用类方法的轨迹
    isa找meta-class，方法不存在，就通过superclass找父类
    */
}

@end
