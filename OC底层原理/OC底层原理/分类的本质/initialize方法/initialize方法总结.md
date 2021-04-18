#  initialize方法总结

- +initialize方法会在类第一次接收到消息时调用
- +initialize是通过objc_msgSend进行调用的

### 调用顺序
1、先调用父类的+initialize，再调用子类的+initialize
2、如果子类没有实现+initialize，会调用父类的+initialize（所以父类的+initialize可能会被调用多次）
3、如果分类实现了+initialize，就覆盖类本身的+initialize调用
