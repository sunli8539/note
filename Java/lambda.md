Optional  
Optional<Student> student = list.stream().filter(s -> StringUtils.isBlank(s.getName())).findFirst();    
if (student.isPresent()) { }  

去重  
List<String> distinctList = list.stream().distinct().collect(Collectors.toList());  

判重
long count = list.stream().map(Student::getId).distinct().count();

转map
Map<String, List<Student>> teamMap = tagModelList.stream().collect(Collectors.groupingBy(Student::getTeam));
Map<String, Student> specResMap = list.stream().collect(Collectors.toMap(Student::getName, vo -> vo, (v1, v2) -> v2));
Map<String, Integer> specResMap = list.stream().collect(Collectors.toMap(Student::getName, Student::getId, (v1, v2) -> v2));


