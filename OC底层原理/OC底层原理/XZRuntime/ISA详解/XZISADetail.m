//
//  XZISADetail.m
//  OC底层原理
//
//  Created by 毛 on 2021/3/8.
//

#import "XZISADetail.h"
#import "XZISAPerson.h"

@implementation XZISADetail

/**

 isa 优化过之后使用了 共用体（union）这个结构
 使用位域来储存更多的信息
 
 union isa_t {

     Class cls;
     uintptr_t bits;
 
     这个结构体起到注释作用  不写也可以
     struct {
         uintptr_t nonpointer        : 1;     nonpointer 0没有使用过优化过得isa  1使用优化过得isa
         uintptr_t has_assoc         : 1;    是否有设置过关联对象，如果没有，释放时会更快
         uintptr_t has_cxx_dtor      : 1;  是否有C++的析构函数（.cxx_destruct），如果没有，释放时会更快
         uintptr_t shiftcls          : 33; // MACH_VM_MAX_ADDRESS 0x1000000000  存储着Class、Meta-Class对象的内存地址信息
         uintptr_t magic             : 6;       用于在调试时分辨对象是否未完成初始化
         uintptr_t weakly_referenced : 1; 是否有被弱引用指向过，如果没有，释放时会更快
         uintptr_t deallocating      : 1;      对象时是否正在释放
         uintptr_t has_sidetable_rc  : 1;   引用计数器是否过大无法存储在isa中
         uintptr_t extra_rc          : 19;       里面存储的值是引用计数器减1     如果为1，那么引用计数会存储在一个叫SideTable的类的属性中
     };
 };
 */
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // 下面是使用共用体 位域技术 可进入详情看代码
        XZISAPerson *person = [[XZISAPerson alloc] init];
        person.thin = YES;
        person.rich = YES;
        person.handsome = NO;
        
        NSLog(@"thin:%d rich:%d hansome:%d", person.isThin, person.isRich, person.isHandsome);

    }
    return self;
}


@end
