#  block详解

- block 捕获 auto变量
1. auto变量是基础数据类型时会在block内部创建一个新的变量
2. auto变量是对象类型时会在block内部创建一个指针指向该对象

- block 捕获 全局变量  静态修饰的的变量 
1. 全局变量block 不捕获    静态修饰的的变量内部创建指针指向该对象
2. 一般使用block  不研究这两种

- block捕获对象的内存结构 我在代码里写的伪代码  可以看看

- block类型
1. __NSGlobalBlock__   没有访问auto变量   在数据段
2. __NSStackBlock__    访问了auto变量    在栈区
3. __NSMallocBlock__   __NSStackBlock__  调用了copy    堆区 


- block 的copy操作 ARC环境下 一下三种情况系统会自动将block拷贝到堆上去
1. block作为函数的返回值
2. block 赋值给强指针时 
3. GCD api 以及一些系统的api 

- block 从栈上拷贝到堆上
1. 会调用block内部的copy函数
2. copy函数内部会调用_Block_object_assign函数
3. _Block_object_assign函数会根据auto变量的修饰符（__strong、__weak、__unsafe_unretained）做出相应的操作，形成强引用（retain）或者弱引用



## block捕获__block修饰的对象

- __block修饰的对象 在被捕获时 会被系统自动包装一层  成为一个新的对象 被block内部的强指针指着 
- 当block从栈上copy到堆上时   
1. __block修饰的对象会调用内部的copy函数 也copy到堆上（多个block捕获 只copy到堆上一次 ）
2. __block修饰的对象会调用内部的copy函数 copy函数内部会调用_Block_object_assign函数 也会根据auto变量的修饰符（__strong、__weak、__unsafe_unretained）做出相应的操作  在被包装的对象里边对被包装的对象形成强引用（retain）或者弱引用  


- __block修饰的对象会 为什么在调用block时修改 之后外面的值也会跟着变
1. 包装对象里面有个__forwarding指针 在对象没有被copy到堆上时 指向站上的包装对象，也就是指向自己。当copy到堆上时则指向堆上的包装对象 通过 包装对象—> __forwarding -> 对象肯定能取出堆中的对象
2. 我个人理解  如果被包装变量是对象类型的话 对象本来就在堆上block内部有个指针指向包装对象 包装对象内部有指针指向堆上的对象，__forwarding 指向堆上的包装对象    也走1. 这套流程是为了确保调用流程一致


## 对block的理解

- 首先要知道block的结构
- block捕获变量 （auto变量 全局变量  静态变量）(捕获的auto变量在block内部有指针指向他)
- block 类型  数据段block  栈区block 堆区block    (栈区block 进行copy操作就成为了 堆区block )
1. block 的copy操作  这里调用了block内部的copy函数 该函数调用了 _Block_object_assign 根据捕获变量 修饰词进行强引用或者弱引用  
2. 如果block从堆上移除  会调用block内部的dispose 函数    dispose函数内部会调用_Block_object_dispose函数自动释放引用的auto变量

- __block修饰的变量  会被系统进行包装成一个新的对象。 
1. block的copy操作时  block内部的调用copy    dispose 两个函数时分别会在调用 _Block_object_assign _Block_object_dispose 两个方法对包装对象进行管理 
2. 包装对象内部调用copy    dispose 两个函数时分别会在调用 _Block_object_assign _Block_object_dispose 两个方法对被包装对象进行管理 
