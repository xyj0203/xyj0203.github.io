# redis的五种基本数据类型

redis是由五种基本的数据类型，包括string, hash, list, set, sort set

## String

String 顾名思义是字符串，但是对于不同的设计者来说字符串的实现方法也是不尽相同的，而我们的redis采用的是SDS（simple dynamic string）。

我们先来看一下SDS的具体是如何进行定义的

```C
struct __attribute__ ((__packed__)) sdshdr8 {
    // s
    uint8_t len; /* used */
    uint8_t alloc; /* excluding the header and null terminator */
    unsigned char flags; /* 3 lsb of type, 5 unused bits */
    char buf[];
};
```



redis采用的设计语言是C语言，因为它是基于内存的一个程序，设计的目的是充当缓存，于是就会冒出第一个问题：**为什么不去采取C语言的字符串？**

这里就涉及到C语言的字符串的实现，C语言中的字符串是由字符串数组形成的，其判断末尾的方式是通过\0进行判断。
