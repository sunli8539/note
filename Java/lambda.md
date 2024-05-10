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
Map<String, List<String>> tagMap = hostInfoDOList.stream()
            .filter(importModel -> !CollectionUtils.isEmpty(importModel.getTags()))
            .collect(Collectors.toMap(HostFastImportModel::getInnerIp, HostFastImportModel::getTags, (v1, v2) -> v1));

Map<String, List<String>> tagMap = hostInfoDOList.stream()
            .filter(importModel -> !CollectionUtils.isEmpty(importModel.getTags()))
            .collect(Collectors.toMap(HostFastImportModel::getInnerIp, HostFastImportModel::getTags, (v1, v2) -> v1 + v2));


Map<String, Student> specResMap=list.stream().collect(Collectors.toMap(Student::getName,vo->vo,(v1,v2)->v2));
Map<String, Integer> specResMap=list.stream().collect(Collectors.toMap(Student::getName,Student::getId,(v1,v2)->v2));

LambdaQueryWrapper<Device> lambdaQuery = Wrappers.lambdaQuery();
lambdaQuery.eq(Device::getId, id);
lambdaQuery.ne(Device::getStatus, DeviceEnum.StableStatus.DELETED.getCode());
lambdaQuery.last("limit 1");
Device device = this.getOne(lambdaQuery);
```

```java
# LocalDateTime 转 Date
private LocalDateTime collectStartTime;
private LocalDateTime collectEndTime;
Date start = Date.from(monitor.getCollectStartTime().atZone(ZoneId.systemDefault()).toInstant());
Date end = Date.from(monitor.getCollectEndTime().atZone(ZoneId.systemDefault()).toInstant());

# 排序
rsList.stream().sorted(Comparator.comparing(TestCaseResponseVO::getIp).reversed()).collect(Collectors.toList());
```
