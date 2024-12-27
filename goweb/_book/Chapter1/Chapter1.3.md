# 基础语法

## 错误处理

- error：一般用于表达可以被处理的错误
- error只是一个内置的接口
- panic：一般用于表达非常严重不可恢复的错误

## errors包

- New 创建一个新的error
- Is判断是不是特定的某个error
- As类型转换为特定的error
- Unwrap 解除包装，返回被包装的error。

## error和panic选用哪个

遇事不决选error

当怀疑可以用error时，就说明不需要panic

只有快速失败的过程，才会考虑panic

## 从panic中恢复

某些时候，你可能需要从panic中恢复过来：

​	比如某个库，发生panic的场景是你不希望发生的场景，这时候就需要recover

## defer

- 用于在方法返回之前执行某些操作
- 像栈一样，先进后出

## 闭包

- 函数闭包： 匿名函数+定义它的上下文
- 它可以访问定义之外的变量
- Go很强大的特性，很常用

## 闭包延时绑定

- 闭包里面使用的闭包外的参数，其值是在最终调用的时候确定下来的。

## 总结

- error其实就是一个内置的普通的接口。error相关的操作在errors包里面
- panic强调的是无可挽回了。但是也可以用recover恢复过来
- 闭包是很强大的特性，但是要小心延时绑定

## AOP:用闭包来实现责任链

- 为server支持一些AOP逻辑
- AOP：横向关注点，一般用于解决Log, tracing, metric, 熔断， 限流, 跨域CORS
- filter：我们希望请求在真正被处理之前能够经过一大堆的filter

## 为什么这么定义

- 考虑我们 metric filter
- 在请求前记录时间戳
- 在请求后记录时间戳
- 两者相减就是执行时间
- 同时保证线程安全
- 是两个filter 一前一后，那么就要考虑线程安全问题
- 要考虑开始时间怎么传递给后一个filter
- 如果是一个filter，不采用这种方式，那么怎么把filter串起来

## 总结

- 责任链是很常见的用于解决AOP的一种方式
- 类似的也叫做middleware， interceptor...本质上是一样的
- Go函数是一等公民，所以可以考虑用闭包来实现责任链
- filter 很常见，比如说鉴权，日志， trcing， 以及跨域等都可以用filter来实现。

## sync.Map

- key 和 value类型都是interface{}， 意味着你要搞各种类型断言

## 类型断言

- 形式： t, ok := x.(T) 或者 t:= X.(T)
- T 可以是结构体或者指针
- 如何理解
  - 即x是不是T
  - 类似Java instance of + 强制类型转换合体
- 如果x是nil，那么永远是false
- 编译器不会帮你检查

## 类型转换

- 形式： y := T(x)
- 如何理解？记住数字类型转换，string 和 []byte互相转
  - 类似Java强制类型转换
- 编译器会进行类型检查，不能转换的会编译错误

## sync.Mutex和sync.RWMutex

- sync 包提供了基本的并发工具
  - sync.Map：并发安全map
  - sync.Mutex：锁
  - sync.RWMutex: 读写锁
  - sync.Once: 只执行一次
  - sync.WaitGroup: goroutine 之间同步

## mutex家族注意事项

- 尽量用 RWMutext
- 尽量用defer 来释放锁，防止panic没有释放锁
- 不可重入： lock 之后， 即便是同一个线程（goroutine）， 也无法再次加锁（写递归函数要小心）
- 不可升级：加了读锁之后，如果试图加写锁，锁不升级

## 总结

- 尽量用sync.RWMutex
- sync.Once 可以保证代码只会执行一次，一般用来解决一些初始化的需求
- sync.WaitGroup 能用来在多个goroutine 之间进行同步