# 2.9 技术探讨OR学习总结

前面我们大概学习了nacos与各种框架的结合使用，大多数是参照官网的，这里也是我想告诉大家的一点，学习最快的方式就是参照官网，然后先会使用，然后了解实现，再到深入源码。

## 2.9.1 关于日志的问题

[SLF4J: Failed to load class "org.slf4j.impl.StaticLoggerBinder". SLF4J: Defaulting to no-operation (NOP) logger implementation](https://www.cnblogs.com/fangjb/p/12964710.html)

## 2.9.2 关于Mysql的报错

MySQLNonTransientConnectionException: Could not create connection to database server.

mysql驱动5和8不兼容，换一个驱动即可。

## 2.9.3 关于开启权限认证

因为大多数的nacos是线上服务（暴露在内网的线上服务），那么最好还是开启权限认证比较好。那么开启的方式官网也已经告诉我们了。

[权限认证](https://nacos.io/zh-cn/docs/v2/guide/user/auth.html)文档清晰明了，如果开启了验证那么要在使用服务前先进行权限的校验，我们来进行docker的开启鉴权的测试。

**为了系统安全起见，新版本（Nacos 2.2.1）删除了以下环境变量的默认值，请在启动时自行添加，否则启动时会报错。**

1. NACOS_AUTH_IDENTITY_KEY
2. NACOS_AUTH_IDENTITY_VALUE
3. NACOS_AUTH_TOKEN

首先的话我们需要移除docker容器

```bash
# 停止容器 
docker stop b59ea55b8973
# 移除容器
docker rm b59ea55b8973
# 启动新的容器
docker run \
--name nacos-quick \
-e MODE=standalone \
-e NACOS_AUTH_ENABLE=true \
-e NACOS_AUTH_TOKEN=VGhpc0lzTXlDdXN0b21TZWNyZXRLZXkwMTIzNDU2Nzg \
-e NACOS_AUTH_IDENTITY_KEY=nacos  \
-e NACOS_AUTH_IDENTITY_VALUE=nacos \
-p 8848:8848 \
-p 9848:9848 \
-d nacos/nacos-server:v2.2.3
```

这样就配置了认证之后的操作都要先输入账号密码才能访问， 我们以dubbo为示例来继续演示。

未添加权限

![](../images/20230930154336.png)

会在注册的时候报错，这个时候我们就需要进行添加账号密码

```properties
nacos://192.168.150.101:8848?username=nacos&password=nacos
```

这样我们就会鉴权成功。



