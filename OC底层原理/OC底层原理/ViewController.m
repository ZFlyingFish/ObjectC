//
//  ViewController.m
//  OC底层原理
//
//  Created by 毛 on 2021/2/23.
//

#import "ViewController.h"
#import "XZObjectDetail.h"
#import "XZKVCObject.h"
#import "XZKVOObject.h"
//#import "XZBlock.h"

@interface ViewController ()

@property (nonatomic, strong) XZKVCObject *kvcObject;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
//    [self KVC];
//    [self block];
    
    [self objectEssence];
}

- (void)block {

//    XZBlock *block = [[XZBlock alloc] init];
}

#pragma mark - 类的本质 isa 类对象的结构
- (void)objectEssence {

    XZObjectDetail *objectDetail = [[XZObjectDetail alloc] init];
    [objectDetail detail];
}

#pragma mark - KVO 实现及原理介绍
- (void)KVO {

    // 使用KVO改变成员变量的值 KVC肯定会出发 （系统内部做的 我觉得是调用了didChangeValueForKey）

    XZKVCObject *KVCObject = [[XZKVCObject alloc] init];

    [KVCObject setValue:@"董小姐" forKey:@"name"];
    [KVCObject setValue:@"董小姐" forKeyPath:@"name"];

    [KVCObject valueForKey:@"name"];
    [KVCObject valueForKeyPath:@"name"];

    // 两个赋值 两个取值
    // 赋值的时候
    // 1、先按顺序查找 setName: _setName:  两个方法 有就调用赋值
    // 2、没有找到就accessInstanceVariablesDirectly看这个方法返回的是不是yes  不是直接报错
    // 3、返回yes 则按顺序查找 _name  _isName name isname 查找成员变量赋值 没找到报错


    // 取值的时候
    // 1、按循序查找 getName: name: isName: _name: 方法 找到取值 没找到看accessInstanceVariablesDirectly看这个方法返回的是不是yes  不是直接报错
    // 是yes 则按顺序查找 _name  _isName name isname 查找成员变量取值
    // 没找到报错

    //取值 赋值的报错都是 NSUnknownKeyException

}

#pragma mark - KVC 实现及原理介绍
- (void)KVC {

    /**
     XZKVCObject 添加KVC 监听之后系统会通过runTime 自动生成NSKVONotifying_XZKVCObject这个类
     NSKVONotifying_XZKVCObject 是 XZKVCObject 的子类
     self.kvcObject 实例对象的isa 指向系统生成的类

     NSKVONotifying_XZKVCObject类 里面有仿代码
     didChangeValueForKey: 方法里 通知监听器，某某属性值发生了改变
     */

    self.kvcObject = [[XZKVCObject alloc] init];

    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;

    [self.kvcObject addObserver:self forKeyPath:@"name" options:options context:@"每次改变self.kvcObject.name的值都会检测到"];

    self.kvcObject.name = @"董小姐";
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {

    NSLog(@"%@",change);
    NSLog(@"拓展字段:%@",context);
}

- (void)dealloc {

    [self.kvcObject removeObserver:self forKeyPath:@"name"];
}


@end
