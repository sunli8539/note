## mysql-note
```mysql
-- 查询所有表  
SELECT table_name FROM information_schema.TABLES WHERE TABLE_SCHEMA= 'xxx';  

-- 判断表是否存在  
SELECT count(1) FROM information_schema.TABLES WHERE  table_name='xxx';  

-- 判断字段是否存在  
select count(1) from information_schema.columns where table_name = 'xxx' and column_name = 'xxx';  

-- 修改自增id  
alter table xxx  AUTO_INCREMENT = 500;  


-- 截取第一个: 左边所有字符
SUBSTRING_INDEX(str, ':', 1)
-- 截取第一个: 右边所有字符
SUBSTRING_INDEX(str, ':', -1)
```
