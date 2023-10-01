# 2.5 Nacos集成dubbo

通过上面的学习我们大概了解了nacos的两大功能，然后我们就要看一下nacos和
dubbo的结合使用，这个项目是nacos-dubbo-example。众所周知，dubbo是远程功能调用，那么这就会涉及三个概念，**调用方**，**提供方**和**接口**

首先是调用方,也被称为消费者。

```java
// 开启dubbo
@EnableDubbo
// 配置文件的路径
@PropertySource(value = "classpath:/consumer-config.properties")
public class DemoServiceConsumerBootstrap {
	
    // 远程服务的注入
    @DubboReference(version = "${demo.service.version}")
    private DemoService demoService;
	
    // 等待注入后的调用
    @PostConstruct
    public void init() {
        for (int i = 0; i < 10; i++) {
            System.out.println(demoService.sayName("Nacos"));
        }
    }
	
    // 主程序，用于创建上下文
    public static void main(String[] args) throws IOException {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext();
        // 启动类
        context.register(DemoServiceConsumerBootstrap.class);
        // 刷新上下文容器
        context.refresh();
        context.close();
    }
}
```

对应的配置文件

```properties
## Dubbo Application info
dubbo.application.name = dubbo-consumer-demo

## Nacos registry address
dubbo.registry.address = nacos://192.168.150.101:8848
#dubbo.registry.address = nacos://127.0.0.1:8848?namespace=5cbb70a5-xxx-xxx-xxx-d43479ae0932
#dubbo.registry.parameters.namespace=5cbb70a5-xxx-xxx-xxx-d43479ae0932

# @Reference version
demo.service.version= 1.0.0

dubbo.application.qosEnable=false
```

生产者

```java
// 开启dubbo
@EnableDubbo(scanBasePackages = "com.alibaba.nacos.example.dubbo.service")
// 配置文件
@PropertySource(value = "classpath:/provider-config.properties")
public class DemoServiceProviderBootstrap {
	// 主程序
    public static void main(String[] args) throws IOException {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext();
        context.register(DemoServiceProviderBootstrap.class);
        context.refresh();
        System.out.println("DemoService provider is starting...");
        System.in.read();
    }
}
```

然后就是接口

```java
public interface DemoService {
    String sayName(String name);
}
```

基本上是这样，调用方只拥有接口，而提供方拥有接口和具体的实现，两者通过dubbo进行调用，而nacos则是起一个注册中心的角色，调用方需要根据注册中心的内容去寻找到具体的调用实现，dubbo的默认的注册中心就是nacos。

然后我们来进行测试，确实进行调用。

![](../images/20230930152459.png)

而nacos上也有了提供方的信息

![](../images/20230930152602.png)

