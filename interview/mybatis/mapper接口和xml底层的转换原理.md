# mapper接口和xml底层的转换原理

## 一、接口定义

开发者首先定义一个接口，接口中声明了各种数据库操作方法，例如查询、插入、更新和删除等。

## 二 、XML映射文件

在单独的XML映射文件中，开发者为每个接口方法编写SQL语句以及结果映射规则。XML文件通过`namespace`属性关联到对应的接口，并为每个方法定义`select|insert|update|delete`标签，内含SQL和相关属性。

## 三、XML解析

当MyBatis启动时，会通过**XMLConfigBuilder**或**XMLMapperBuilder**等工具类对mapper.xml文件进行解析，构建出对应的`MappedStatement`对象集合，这些对象包含了**SQL语句**、**参数类型映射**、**结果集映射**等信息，并保存在**SqlSessionFactory**中。

```java
public final class MappedStatement {
    private String resource;
    private Configuration configuration;
    private String id;
    private Integer fetchSize;
    private Integer timeout;
    private StatementType statementType;
    private ResultSetType resultSetType;
    private SqlSource sqlSource;
    private Cache cache;
    private ParameterMap parameterMap;
    private List<ResultMap> resultMaps;
    private boolean flushCacheRequired;
    private boolean useCache;
    private boolean resultOrdered;
    private SqlCommandType sqlCommandType;
    private KeyGenerator keyGenerator;
    private String[] keyProperties;
    private String[] keyColumns;
    private boolean hasNestedResultMaps;
    private String databaseId;
    private Log statementLog;
    private LanguageDriver lang;
    private String[] resultSets;
    ....
```

## 四、动态代理

- 使用MyBatis时，一般会通过SqlSessionFactory创建SqlSession。
- 当应用程序请求执行一个mapper接口的方法时，MyBatis并不会直接调用接口方法，而是通过SqlSession来获取一个实现了该接口的代理对象。
- 这个代理对象是通过JDK动态代理或CGLIB动态代理技术创建的，具体实现类可能是MapperProxy。
- MapperProxy实现了InvocationHandler接口，当调用代理对象的方法时，会触发invoke方法。

## 五、方法调用转发

- 在MapperProxy的invoke方法中，会根据方法签名和参数信息，从预先解析并缓存的`MapperStatement`集合中找出对应的SQL执行信息。
- MyBatis会使用SqlSession执行SQL，并将查询结果通过结果映射转换为Java对象，最终返回给调用者。

## 六、为什么要创建代理对象呢？

1. **封装数据库操作**：
   代理对象在接收到调用请求时，不会直接执行接口方法，而是根据接口方法的签名信息找到对应的SQL语句，通过SqlSession执行这些SQL操作。这样就把数据库操作抽象封装到了代理对象中，对外部调用者而言，就像直接调用普通Java方法一样简单，不需要关心数据库连接的打开关闭、SQL语句的拼接执行等细节。
2. **动态SQL处理**：
   MyBatis支持动态SQL，即在接口方法的实现中可以使用`#{}`占位符表示参数，并在运行时根据传入的实际参数值动态生成SQL。代理对象在处理方法调用时会解析这些动态内容，构造出最终要执行的SQL语句。
3. **结果映射**：
   代理对象在执行完SQL后，会依据XML配置中的结果映射规则将数据库查询结果转换为Java对象，这样返回给调用者的便是与接口方法签名相匹配的Java对象，而不是原始的ResultSet。
4. **事务管理**：
   通过代理对象，MyBatis可以更好地整合Spring等框架进行事务管理，使得每次方法调用都在合适的事务上下文中执行，保证了数据操作的原子性和一致性。
5. **减少耦合**：
   通过代理对象，实现了面向接口编程，降低了模块间的耦合度，使得业务代码和数据访问层代码可以分离，有利于项目的架构设计和维护。