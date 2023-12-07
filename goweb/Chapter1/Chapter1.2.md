# type定义和server抽象

## Request Body

- Body: 只能读取一次，意味着你读了别人就不能读了；别人读了你就不能读了

- GetBody: 原则上是可以多次读取，但是在原生的http.Request里面，这个是nil
- 在读取到body后，我们可以用于反序列化，比如将json格式的字符串转化为一个对象等。

- 除了Body，我们还能传递参数的地方是Query
- 所有的值都被解释为字符串，所以需要自己解析为数字等。

## Request URL

- URL 里面 Host不一定有值
- r.Host 一般都有值， 是Host这个header的值。
- RawPath 也是不一定有
- Path肯定有

## Request Header

- header大体上是两类，一类是http预定义的；一类是自己定义的
- Go 会自动的将header名字转为标准名字-大小写调整
- 一般用X开头来表明是自己定义的，比如X-mycompany-your=header 

## Form

- Form和ParseForm
- 要先调用 ParseForm
- 建议加上 Content-Type：application/x-www-form-urlencoded

## tyoe定义

- type定义
  - type 名字 interface {}
  - type 名字 struct {}
  - type 名字 别的类型
  - type 别名 = 别的类型
- 结构体初始化
- 指针与方法接收器
- 结构体如何实现接口

## interface 定义

- 基本语法 type 名字 interface{}

- 里面只能有方法，方法也不需要func关键字
- 啥是接口（interface） : 接口是一组行为的抽象
- 尽量用接口，以实现面向接口编程

## struct 定义

- 基本语法

```go
type Name struct {
    fieldName FieldType
}
```

- 结构体和结构体的字段都遵循大小写控制访问性的原则

## type A B

- 基本语法： type TypeA TypeB
- 我一般，在我是用第三方库有没有办法修改源码的情况下，又想在拓展这个库的结构体的方法，就会用这个

## type A = B

- 基本语法： type TypeA = TypeB
- 别名除了换了一个名字，没有任何区别

## Struct 初始化

- Go没有构造函数
- 初始化语法：Struct{}
- 获取指针： &Struct{}
- 获取指针2：new(Struct)
- new 可以理解为Go会为你的变量分配内存，并且把内存都置为0

##  指针

- 和C， C++ 一样， *表示指针，&取地址
- 如果声明了一个指针，但是没有赋值，那么他是nil

## 结构体自引用

- 结构体内部引用自己，只能使用指针
- 准确来说，在整个引用链上，如果构成循环，那就只能用指针。

## 方法接收器

- 结构体接收器内部永远不要修改字段

## 方法接收器用哪个

- 设计不可变对象，用结构体接收器
- 其他用指针

## 注释规范

```go
// Fun1 测试
func Fun1(a string, b int) (int, string) {
	return 0, "您好"
}
```

## type总结

- type定义熟记。其中type A = B这种别名，一般只用于兼容性处理，所以不需要过多关注。
  - 先有抽象再有实现，所以要先定义接口
- 鸭子类型：一个结构体有某个接口的所有方法，它就实现了这个接口
- 指针：方法接收器，遇事不决用指针；

## Server 和 Context

- Http Server 实现
- Context抽象与实现
  - 读取数据
  - 写入响应
- 创建Context

## map

- 基本形式map[KeyType]valueType
- 创建make命令， 或者直接初始化
- 取值： val, ok := m[key]
- 设值： m[key]= val
- key类型： ”可比较“类型