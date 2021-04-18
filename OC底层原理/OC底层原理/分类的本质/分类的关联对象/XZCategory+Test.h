//
//  XZCategory+Test.h
//  OC底层原理
//
//  Created by 毛 on 2021/2/25.
//

#import "XZCategory.h"

NS_ASSUME_NONNULL_BEGIN

@interface XZCategory (Test)

@property (nonatomic, assign) int age;
@property (nonatomic, copy) NSString *name;
- (void)text;

@end

NS_ASSUME_NONNULL_END
