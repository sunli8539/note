## Optional

```java
Optional<Student> student=list.stream().filter(s->StringUtils.isBlank(s.getName())).findFirst();
    if(student.isPresent()){
        
    }  
```

## lambda
```java
List<String> distinctList=list.stream().distinct().collect(Collectors.toList());
long count=list.stream().map(Student::getId).distinct().count();

Map<String, List<Student>>teamMap=tagModelList.stream().collect(Collectors.groupingBy(Student::getTeam));
Map<String, Student> specResMap=list.stream().collect(Collectors.toMap(Student::getName,vo->vo,(v1,v2)->v2));
Map<String, Integer> specResMap=list.stream().collect(Collectors.toMap(Student::getName,Student::getId,(v1,v2)->v2));

LambdaQueryWrapper<Device> lambdaQuery = Wrappers.lambdaQuery();
lambdaQuery.eq(Device::getId, id);
lambdaQuery.ne(Device::getStatus, DeviceEnum.StableStatus.DELETED.getCode());
lambdaQuery.last("limit 1");
Device device = this.getOne(lambdaQuery);
```
