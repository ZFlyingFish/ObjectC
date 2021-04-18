//
//  XZList.h
//  OC底层原理
//
//  Created by 毛 on 2021/3/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZList : NSObject
{
    @public
    int _aa2222;
    //对外开放的成员变量
}

//属性 本质是 调用  set get  修改_age _color 成员变量的值；
@property (nonatomic, assign) int age;
@property (nonatomic, assign) int color;

@end

NS_ASSUME_NONNULL_END
