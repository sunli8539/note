## java bean
```java
StudentDetailVO  
   private Student baseInfo ;  
   private StudentRel relInfo;  
   private List<Lesson> lessonList;  
```

## mybatis配置
```xml
<select id="detail" resultMap="StudentDetailMap">  
    <!--extends 可继承其他map对象, 没有则不写-->  
    <resultMap id="StudentDetailMap" type="com.smartai.student.vo.StudentDetailVO" extends="xxx">  
	<!--association 对象  select如果是其他mapper的sql 则需要指定全路径-->  
        <association property="relInfo" javaType="com.smartai.studentrel.entity.StudentRel"  
            select="com.smartai.studentrel.mapper.StudentRelMapper.selectRelInfoByStudentId" column="{studentId=id}"/>  
 	<!--collection 集合-->  
        <collection property="lessonList" ofType="com.smartai.student.entity.entity.Lesson"  
            select="selectLessonsByStudentId" column="{studentId=id}"/>  
    </resultMap>  
 
    <select id="selectRelInfoByStudentId" resultType="com.smartai.studentrel.entity.StudentRel">  
	select xxx  where student_id = #{studentId}  
    <select id="selectLessonsByStudentId" resultType="com.smartai.student.entity.Lesson">  
	select xxx  where student_id = #{studentId} 
	   
```
```text
如果报错  
org.mybatis.spring.MyBatisSystemException: nested exception is org.apache.ibatis.reflection.ReflectionException: Error instantiating class java.lang.Long with invalid types () or values (). Cause: java.lang.NoSuchMethodException: java.lang.Long.<init>()  

删除相关sql的 parameterType
```




