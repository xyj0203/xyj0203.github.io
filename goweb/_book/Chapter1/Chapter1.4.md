# 并发编程、文件操作与泛型

## 优雅退出

- 监听系统信号
- channel 和 select
- Hook (钩子函数) 设计
- 同步等待与超时机制
- context 包与线程安全

## 怎么知道关闭

- 摘掉流量

- 拒绝新的请求
- 等待当前的所有请求处理完毕
- 释放资源
- 关闭服务器
- 超时强制关闭

## gotoutine

- 一段异步执行的代码
- 用关键字 go 启动

##  channel

- 使用 make 创建 channel
- 带缓冲和不带缓冲的channel
- 用 <- 来表达收发

## select

等待多个channel，select比较常见和for循环一起使用。

## context 包

context。Context 是Go提供的线程安全工具，称为上下文

- WithTimeout: 一般用户控制超时
- WithCancel: 用于取消整条链上的任务
- WithDeadline： 控制时间
- WithValue: 往里面塞入一个空的context.Context
- ToDo： 返回一个空的context.Context， 但是这个标记着你也不知道传什么。 

## context 与 thread-local

- Go 官方没有支持 thread-local
- 因为缺乏thread-local, 如果需要实现；类似的功能，都只能依赖于 context 在方法直接传递，一般建议方法签名都把context.Context都作为第一个参数。

## atomic

- AddXXX: 操作一个数字类型， 加上一个数字
- LoadXXX: 读取一个值
- CompareAndSwapXXX： 大名鼎鼎的 CAS 操作
- StoreXXX: 写入一个值
- SwapXXX: 写入一个值，并且返回旧的值。它和 CompareAndSwap 的区别在于它不关心旧的值是什么
- unsafepointer 相关方法，不建议使用。难写也难读。