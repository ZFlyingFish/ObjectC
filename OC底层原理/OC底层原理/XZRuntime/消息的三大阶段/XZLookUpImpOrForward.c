//
//  XZLookUpImpOrForward.c
//  OC底层原理
//
//  Created by 毛 on 2021/3/9.
//

/**
 
objc_msgSend(方法调用者, @selector(方法名))
这个源码是汇编语言  看不太懂 但是查找方法是c写的这里分析一下查找方法就可得出消息的三大阶段
 

 
IMP lookUpImpOrForward(Class cls, SEL sel, id inst,
                       bool initialize, bool cache, bool resolver)
{
    IMP imp = nil;
    bool triedResolver = NO;

    runtimeLock.assertUnlocked();

    //
    // Optimistic cache lookup
    if (cache) {
        imp = cache_getImp(cls, sel);
        if (imp) return imp;
    }

    runtimeLock.read();

 
    //这些是runtimeLock 读写锁的一些操作
    if (!cls->isRealized()) {
        // Drop the read-lock and acquire the write-lock.
        // realizeClass() checks isRealized() again to prevent
        // a race while the lock is down.
        runtimeLock.unlockRead();
        runtimeLock.write();

        realizeClass(cls);

        runtimeLock.unlockWrite();
        runtimeLock.read();
    }

    //看下类是否被发送过消息  initialize是否被调用过
    if (initialize  &&  !cls->isInitialized()) {
        runtimeLock.unlockRead();
        _class_initialize (_class_getNonMetaClass(cls, inst));
        runtimeLock.read();
        // If sel == initialize, _class_initialize will send +initialize and
        // then the messenger will send +initialize again after this
        // procedure finishes. Of course, if this is not being called
        // from the messenger then it won't happen. 2778172
    }

    
 retry:
    runtimeLock.assertReading();

    // Try this class's cache.
 
    //查找当前方法调用者的方法缓存 找到了返回调用
    imp = cache_getImp(cls, sel);
    if (imp) goto done;

    //查找当前方法调用者的方法列表  找到了返回调用
    // Try this class's method lists.
    {
        Method meth = getMethodNoSuper_nolock(cls, sel);
        if (meth) {
            log_and_fill_cache(cls, meth->imp, sel, inst, cls);
            imp = meth->imp;
            goto done;
        }
    }
    //查找当前方法调用者的父类 父父类  也是先找缓存在找方法列表
    // Try superclass caches and method lists.
    {
        unsigned attempts = unreasonableClassCount();
        for (Class curClass = cls->superclass;
             curClass != nil;
             curClass = curClass->superclass)
        {
            // Halt if there is a cycle in the superclass chain.
            if (--attempts == 0) {
                _objc_fatal("Memory corruption in class list.");
            }
            
            // Superclass cache.
            imp = cache_getImp(curClass, sel);
            if (imp) {
                if (imp != (IMP)_objc_msgForward_impcache) {
                    // Found the method in a superclass. Cache it in this class.
                    log_and_fill_cache(cls, imp, sel, inst, curClass);
                    goto done;
                }
                else {
                    // Found a forward:: entry in a superclass.
                    // Stop searching, but don't cache yet; call method
                    // resolver for this class first.
                    break;
                }
            }
            
            // Superclass method list.
            Method meth = getMethodNoSuper_nolock(curClass, sel);
            if (meth) {
                log_and_fill_cache(cls, meth->imp, sel, inst, curClass);
                imp = meth->imp;
                goto done;
            }
        }
    }

    // No implementation found. Try method resolver once.
    //这里是动态解析  +resolveInstanceMethod:  +resolveClassMethod: 会调用类的这两个方法给开发者为这个类添加方法的机会
    //调用完这方法后 从新回到查找方法的开头
 
    if (resolver  &&  !triedResolver) {
        runtimeLock.unlockRead();
        _class_resolveMethod(cls, sel, inst);
        runtimeLock.read();
        // Don't cache the result; we don't hold the lock so it may have
        // changed already. Re-do the search from scratch instead.
        triedResolver = YES;
        goto retry;
    }

    // No implementation found, and method resolver didn't help.
    // Use forwarding.
    //到这里就到了消息转发了 这里的以后就不开源了
    //后续操作会调用类的-(id)forwardingTargetForSelector:(SEL)aSelector 这个会让开发者返回一个新的消息接収对象  会对新对象发送消息
    //如果上个方法没调用+ (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector 这会给找不到的方法换个实现
    //void)forwardInvocation:(NSInvocation *)anInvocation  这个开始调用
    imp = (IMP)_objc_msgForward_impcache;
    cache_fill(cls, sel, imp, inst);

 done:
    runtimeLock.unlockRead();

    return imp;
}

动态解析  消息转发 可以看代码 有样例
 
 */
