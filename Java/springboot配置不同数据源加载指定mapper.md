```properties
spring.datasource.driverClassName=com.mysql.jdbc.Driver
spring.datasource.url=jdbc:mysql://xxx:3306/cmdb_dev?allowMultiQueries=true&zeroDateTimeBehavior=convertToNull&serverTimezone=Asia/Shanghai
spring.datasource.username=xx
spring.datasource.password=xxx

spring.datasource.url2=jdbc:mysql://xxx:3306/common?allowMultiQueries=true&zeroDateTimeBehavior=convertToNull&serverTimezone=Asia/Shanghai
spring.datasource.username2=xx
spring.datasource.password2=xx
```

```text
不同DataSource加载的mapper接口和xml文件要平级
```

```java
package com.huawei.luban.job.dal.configuration;

import com.huawei.luban.job.dal.exception.LubanJobDatabaseException;

import com.alibaba.druid.pool.DruidDataSource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.mybatis.spring.annotation.MapperScan;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;

import java.io.IOException;
import java.sql.SQLException;

import javax.sql.DataSource;

@Configuration
@MapperScan(basePackages = "com.xxx.mapper", sqlSessionFactoryRef = "xbenchSqlSessionFactory")
public class XbenchDatabaseConfiguration {

    @Value("${spring.datasource.driverClassName}")
    private String dirverName;

    @Value("${spring.datasource.url2}")
    private String url2;

    @Value("${spring.datasource.username}")
    private String username2;

    @Value("${spring.datasource.password}")
    private String password2;

    @Value("${spring.datasource.maxActive}")
    private int maxActive;

    @Value("${spring.datasource.maxWait}")
    private int maxWait;

    @Value("${spring.datasource.minIdle}")
    private int minIdle;

    @Value("${spring.datasource.validationQuery}")
    private String validationQuery;

    @Value("${spring.datasource.testOnBorrow}")
    private boolean testOnBorrow;

    @Value("${spring.datasource.validationQueryTimeout}")
    private int timeout;

    @Value("${spring.datasource.timeBetweenEvictionRunsMillis}")
    private int timeBetweenEvictionRunsMillis;

    @Value("${spring.datasource.minEvictableIdleTimeMillis}")
    private int minEvictableIdleTimeMillis;

    @Value("${spring.datasource.testWhileIdle}")
    private boolean testWhileIdle;

    @Value("${spring.datasource.testOnReturn}")
    private boolean testOnReturn;

    @Value("${spring.datasource.poolPreparedStatements}")
    private boolean poolPreparedStatements;

    @Value("${spring.datasource.maxPoolPreparedStatementPerConnectionSize}")
    private int maxPoolPreparedStatementPerConnectionSize;

    @Value("${spring.datasource.filters}")
    private String filters;

    @Value("{spring.datasource.connectionProperties}")
    private String connectionProperties;

    @Value("${spring.datasource.initialSize}")
    private int initialSize;

    @Value("${spring.datasource.logAbandoned}")
    private boolean logAbandoned;

    private static final Logger LOGGER = LoggerFactory.getLogger(XbenchDatabaseConfiguration.class);

    @Bean(name = "xbenchDataSource")
    public DataSource getXbenchDataSource() {
        DruidDataSource datasource = new DruidDataSource();
        initDataSource(datasource);
        return datasource;
    }

    private void initDataSource(DruidDataSource datasource) {
        datasource.setUrl(url2);
        datasource.setUsername(username2);
        datasource.setPassword(password2);
        datasource.setDriverClassName(dirverName);
        // configuration
        datasource.setInitialSize(initialSize);
        datasource.setMinIdle(minIdle);
        datasource.setMaxActive(maxActive);
        datasource.setMaxWait(maxWait);
        datasource.setTimeBetweenEvictionRunsMillis(timeBetweenEvictionRunsMillis);
        datasource.setMinEvictableIdleTimeMillis(minEvictableIdleTimeMillis);
        datasource.setValidationQueryTimeout(timeout);
        datasource.setValidationQuery(validationQuery);
        datasource.setTestWhileIdle(testWhileIdle);
        datasource.setTestOnBorrow(testOnBorrow);
        datasource.setTestOnReturn(testOnReturn);
        datasource.setPoolPreparedStatements(poolPreparedStatements);
        datasource.setMaxPoolPreparedStatementPerConnectionSize(maxPoolPreparedStatementPerConnectionSize);
        datasource.setLogAbandoned(logAbandoned);
        try {
            datasource.setFilters(filters);
        } catch (SQLException logException) {
            LOGGER.info("DatabaseConfiguration sql  failed error!");
        }
        datasource.setConnectionProperties(connectionProperties);
    }

    @Bean(name = "xbenchTransactionManager")
    public DataSourceTransactionManager transactionManager(@Qualifier("xbenchDataSource") DataSource dataSource) {
        return new DataSourceTransactionManager(dataSource);
    }

    @Bean(name = "xbenchSqlSessionFactory")
    public SqlSessionFactory xbenchSqlSessionFactory(@Qualifier("xbenchDataSource") DataSource dataSource)
        throws LubanJobDatabaseException {

        SqlSessionFactoryBean sessionFactory = new SqlSessionFactoryBean();
        sessionFactory.setDataSource(dataSource);
        sessionFactory.setFailFast(true);
        PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
        try {
            sessionFactory.setMapperLocations(resolver.getResources("com/xxx/mapper/*.xml"));
        } catch (IOException logException) {
            throw new LubanJobDatabaseException(logException.getMessage());
        }
        SqlSessionFactory factory = null;
        try {
            factory = sessionFactory.getObject();
        } catch (Exception logException) {
            throw new LubanJobDatabaseException(logException.getMessage());
        }
        return factory;
    }

    @Bean(name = "xbenchSqlSessionTemplate")
    public SqlSessionTemplate testSqlSessionTemplate(
        @Qualifier("xbenchSqlSessionFactory") SqlSessionFactory sqlSessionFactory) {
        return new SqlSessionTemplate(sqlSessionFactory);
    }
}

```
