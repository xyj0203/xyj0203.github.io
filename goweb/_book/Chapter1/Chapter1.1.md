# 基础语法

## 安装配置

安装和下载的过程暂且省略，这里主要介绍下环境变量。

GOROOT：安装路径，一般不需要配置。

GOPATH：关键，设置为自己的golang的项目放置路径

GOPROXY: 推荐使用“http://goproxy.cn”，墙的存在，所以使用镜像。

GOPRIVATE: 指向自己的私有库，比如自己公司的私有库。

## 目录结构

src目录

***放置项目和库的源文件***，用于以包（package）的形式组织并存放 Go 源文件，这里的包与 src 下的每个子目录是一一对应。

Go语言会把通过go get 命令获取到的**库源文件**下载到 src 目录下对应的文件夹当中。

pkg目录

***放置编译后生成的包/库的归档文件***，用于存放通过 go install 命令安装某个包后的归档文件。归档文件是指那些名称以“.a”结尾的文件。 该目录与 GOROOT 目录（也就是Go语言的安装目录）下的 pkg 目录功能类似，区别在于这里的 pkg 目录专门用来存放项目代码的归档文件。 编译和安装项目代码的过程一般会以代码包为单位进行，比如 log 包被编译安装后，将生成一个名为 log.a 的归档文件，并存放在当前项目的 pkg 目录下。

bin目录

***放置编译后生成的可执行文件***，与 pkg 目录类似，在通过go install 命令完成安装后，保存由 Go **命令源文件**生成的可执行文件。在类 Unix 操作系统下，这个可执行文件的名称与**命令源文件**的文件名相同。而在 Windows 操作系统下，这个可执行文件的名称则是**命令源文件**的文件名加 .exe 后缀。

## 第一行代码

```go
package go_web

func main() {
	println("Hello,Go!")
}
```

但是这一行代码无法执行，爆出了如下的错误

![](../images/QQ截图20231207125843.png)

不能在非main包下执行，所以我们就修改对应的包名为main，就会正常执行。

- main函数是没有参数和返回值的
- main方法必须要在main包里面
- `go run main.go`就可以执行
- 如果文件不叫main.go那么需要进行构建为可执行文件后，进行直接运行。`go build`

## 包声明

- 语法形式：package xxxxx
- 字母和下划线的组合
- 可以和文件夹不同名字
- 同一个文件夹下的声明一致

- 引入包语法形式： import [alias] xxxx
- 如果一个包引入了但是没有使用，会报错
- 匿名引入：前面多一个下划线

## string 声明

- “ ” 字符串

- ``是大段文字，复杂的JSON串推荐用反引号。
- 字节长度：和编码无关，用len(str)获取，获取的是字节长度。
- 字符数量：和编码有关，用编码库来计算。
- string 的拼接直接使用+号 就可以。某些语言支持string和别的类型拼接，但是golang不可以。

- strings主要方法
  - 查找和替换
  - 大小写转换
  - 子字符串相关
  - 相等

## rune类型

- rune, 直观理解， 就是字符
- rune 不是byte
- rune 本质是 int32 一个rune四个字节
- rune 在很多语言里面没有， golang没有char类型。rune不是数字，也不是char, 也不是字节

## bool, int, uint, float家族

- bool: true, false
- int8, int16, int32, int64, int
- uint8, uint16, uint32, uint64, uint
- float32, float64

## byte类型

- byte 字节， 本质是 uint8
- 对应的操作包在bytes上

## 类型总结

- golang 的数字类型明确标注了长度、有无符号
- golang 不会帮做类型转换，类型不同无法通过编译。因此string只能和string 拼接。
- golang 有一个很特殊的rune,接近一般语言的char
- string遇事不决找strings包。

## 变量声明

- var, 语法：var name type = value
  - 局部变量
  - 包变量
  - 块声明
- 驼峰命名
- 首字符是否大写控制了访问性：大写包外可访问；
- golang 支持类型推断

![](../images/Snipaste_2023-12-07_13-46-00.png)

## 变量声明 :=

- 只能用于局部变量，即方法内部
- golang 使用类型推断来推断类型。数字会被理解为int 或者 float64。（所以要其他类型的数字得用var进行声明）

![](../images/Snipaste_2023-12-07_13-49-00.png)

## 变量声明易错点

- 声明了没有哦使用
- 类型不匹配
- 同作用域下，变量只能声明一次

## 常量声明const

- 首字符是否大写控制了访问行：大写包外可以访问；
- 驼峰命名
- 支持类型推断
- 无法修改值

## 方法声明

- 四个部分
  - 关键字 func
  - 方法名字： 首字母是否大写决定了作用域
  - 参数列表： [\<name type>]
  - 返回列表： [\<name type>]

- 参数列表含有参数名
- 返回值不具有返回值名

![](../images/Snipaste_2023-12-07_13-58-23.png)

## 方法调用

- 使用_忽略返回值

## 方法声明与调用总结

- golang 支持多返回值，这是一个很大的不同点
- golang 方法的作用域和变量的作用域一样， 通过大小写控制
- golang 的返回值是可以有名字的，可以通过给与名字让调用方清除知道你返回的是什么。

## fmt 格式化输出

fmt 包有完整的说明

- 掌握常用的： %s, %d, %v, %+v, %#v
- 不仅仅是`fmt`的调用，所有格式化字符串的API都可以用
- 因为golang字符串拼接只能在string之间，所以这个包非常常用。

##  数组和切片

数组和别的语言的数组差不多，语法是：[cap]type

- 初始化要指定长度（或者叫做容量）
- 直接初始化
- arr[i]的形式访问元素
- len和cap操作用于获取数组长度

切片，语法： []type

- 直接初始化
- make初始化：make([]type, length, capacity)
- arr[i] 的形式访问元素
- append 追加元素
- len 获取元素数量
- cap 获取切片容量
- 推荐写法： s1 := make([]type, 0, capacity)  

## 子切片

数组和切片都可以通过[start:end]的形式来获取子切片：

- arr[start:end], 获得[start, end)之间的元素
- arr[:end], 获得[0,end) 之间的元素
- arr[start:], 获得[start, len(arr))之间的元素

## 如何理解切片

最直观的对比：ArrayList， 即基于数组的List实现，切片的底层也是数组。

- 切片操作是有限的，不支持随机增删，需要自己写代码。
- 只有append操作
- 切片支持子切片操作，**和原本切片是共享底层数组**

## for

for和别的语言差不多，有三种形式：

- for{}，类似while的无限循环
- for i， 一般的按照下标循环
- for range 最为特殊的range遍历
- break 和 continue 和别的语言一样

## if - else

带局部变量声明的if-else

- distance 只能在if块，或者后边所有的else块里面使用
- 脱离了if-else 块，则不能再使用

## switch

switch 和别的语言差不多

switch 后面可以是基础类型和字符串，或者满足特定条件的结构体。

最大的差别：不用加break;