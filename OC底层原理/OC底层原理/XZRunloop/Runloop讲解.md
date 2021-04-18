#  Runloop 详解

## 概念
- 保持程序持续运行
- 处理App中各种事件  比如触摸 定时器等
- 节省cpu资源 提高程序性能 无事件处理时休眠 来事件时唤醒

## 与线程之间的关系
- 每一条线程都有唯一的一个与之对应的Runloop对象
- RunLoop保存在一个全局的Dictionary里，线程作为key，RunLoop作为value
- 线程刚创建时并没有Runloop对象， Runloop在第一次获取他时创建
- RunLoop会在线程结束时销毁
- 主线程的RunLoop已经自动获取（创建），子线程默认没有开启RunLoop

## Runloop对象

- 里面包含了  一个定时器  一个当前运行model  一个model的集合set    每一个model里面包含了 Source0/Source1/Timer/Observer
- 如果需要切换Mode，只能退出当前Loop，再重新选择一个Mode进入
- 如果Runloop里面没有任何source0//Source1/Timer/Observer 则马上退出

- model 两类 NSDefaultRunLoopMode  UITrackingRunLoopMode  默认和页面跟踪
- Observer  状态  即将进入RunLoop  即将处理timer 即将处理source 即将进入休眠 刚从休眠唤醒  即将推出Runloop
- source0 触摸事件处理
- source1 系统事件捕捉  线程间通讯

##  Runloop运行逻辑

1. 通知Observer 进入loop
2. 通知Observer 即将处理timer
3. 通知Observer 即将处理source
4. 处理blocks  (比如GCD 回到主线程的block)
5. 处理source0 有可能在此处理blocks 
6. 如果存在source1 则跳到 8
7. 通知Observer 开始休眠  （等待唤醒）
8. 通知Observer 结束休眠
    1、处理timer 
    2、处理block
    3、处理source1
9. 处理blocks
10. 根据前面的执行结果决定如何操作 1、回到第二部 2、退出runLoop
11. 如果前面的执行结果是退出 runloop  则通知Observer 退出loop
