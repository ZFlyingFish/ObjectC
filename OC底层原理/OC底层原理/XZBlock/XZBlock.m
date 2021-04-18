//
//  XZBlock.m
//  OC底层原理
//
//  Created by 毛 on 2021/3/2.
//

#import "XZBlock.h"

struct __main_block_desc_0 {
    size_t reserved;
    size_t Block_size;
    
    //block捕获对象类型的时候有这个函数 这两个函数是block拷贝到堆上时调用
    // copy函数内部会调用_Block_object_assign函数 这个函数对auto变量的修饰符（__strong、__weak、__unsafe_unretained）做出相应的操作，形成强引用（retain）或者弱引用
//    void (*copy)(struct __MJPerson__test_block_impl_0*, struct __MJPerson__test_block_impl_0*);
//    void (*dispose)(struct __MJPerson__test_block_impl_0*);
};

struct __block_impl {
    void *isa;
    int Flags;
    int Reserved;
    void *FuncPtr;
};

//
struct __main_block_impl_0 {
    struct __block_impl impl;
    struct __main_block_desc_0* Desc;
    
    // block捕获auto对象 是对象类型的时候 会根据对象的修饰词来决定内部是强引用还是弱引用
//    MJPerson *__strong person;
    int age;
    
    //__Block 修饰的对象 在block内部有把该对象包装了下
//    __Block_byref_age_0 *age;
    
    //__Block 修饰的对象类型时 __Block_byref_weakPerson_0结构体内部 看内部的注释
//    __Block_byref_weakPerson_0 *weakPerson;
};

//struct __Block_byref_age_0 {
//    void *__isa;
//    __Block_byref_age_0 *__forwarding;
//    int __flags;
//    int __size;
//    int age;
//};
//

// 包装对象内部 又有两个函数 用于内存管理 （当__block变量被copy到堆时）
//struct __Block_byref_weakPerson_0 {
//  void *__isa; // 8
//__Block_byref_weakPerson_0 *__forwarding; // 8
// int __flags; // 4
// int __size; // 4
// 这两个函数指针 就是copy  和 dispose 函数  用于内部变量的内存管理
// void (*__Block_byref_id_object_copy)(void*, void*); // 8
// void (*__Block_byref_id_object_dispose)(void*); // 8
// MJPerson *__weak weakPerson;
//};

@implementation XZBlock

- (instancetype)init
{
    self = [super init];
    if (self) {
        

        [self block1];
    }
    return self;
}

#pragma mark - block结构
- (void)block1 {

    int age = 20;
    
    void (^block)(int, int) =  ^(int a , int b){
        
        NSLog(@"this is a block! -- %d", age);
    };
    
    struct __main_block_impl_0 *blockStruct = (__bridge struct __main_block_impl_0 *)block;
    
    block(10, 10);
    
}

@end
