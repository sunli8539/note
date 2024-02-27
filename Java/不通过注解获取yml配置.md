```java
private void initVal(String activeProfile) {
        YamlPropertiesFactoryBean yaml = new YamlPropertiesFactoryBean();
        yaml.setResources(new ClassPathResource("application-".concat(activeProfile).concat(".yml")));
        Properties properties = yaml.getObject();
        bucketName = (String) properties.get("obs.bucketName");
        host = (String) properties.get("obs.host");
        accessKey = (String) properties.get("obs.accessKey");
        secretKey = (String) properties.get("obs.secretKey");
        rootPath = (String) properties.get("obs.rootPath");
    }
```
