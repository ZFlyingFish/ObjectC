
# OC对象的本质

1. 类对象的结构
2. isa和supper

# 分类的本质

1. 分类的结构
2. 分类的关联对象
3. Load方法与 initialize方法的总结 

# Block详解

1. block类型 
2. block捕获变量
3. block的Copy操作
4. __block修饰的对象

# RunTime

1. Supper 调用的本质
2. 消息的三大阶段   消息发送 动态方法解析 消息转发
3. 类的方法缓存列表的实现方式 （散列表）
4. isa详解 

# RunLoop

1. RunLoop的概念和与线程之间的关系 RunLoop对象和RunLoop运行逻辑
2. 线程保活

# 多线程与锁

1. GCD讲解 同步、异步。串行、并行。 信号量、栏栅函数。
2. 锁。自旋锁与互斥锁的工作逻辑
3. os_unfair_lock
4. pthread_mutex  普通锁 / 递归锁 /条件锁
5. NSLock   pthread_mutex  普通锁 的封装
6. NSRecursiveLock 是 pthread_mutex  递归 的封装
7. NSCondition  是pthread_mutex  条件 的封装
8. NSConditionLock  是NSCondition 的进一步封装能定义条件
9. @synchronized   @synchronized是对mutex递归锁的封装
10. atomic nonatomic  atomic 相当于对set get 方法进行了加锁  所以不能保证使用属性的时候是安全的 能保证获取 设置属性是安全的  （如果属实arr 多线程赋值arr 取出arr 是安全的  添加删除arr里面的元素事不安全的）
11. pthread_rwlock 读写锁  
