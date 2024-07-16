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

-- 结果聚合
查询mysql，select time, num from table1;
返回结果如下
2024-07-01   1
2024-07-02   1
2024-07-03   2

期望结果按时间汇总
2024-07-01   1
2024-07-02   2
2024-07-03   4

使用mysql窗口函数
SELECT
        time, SUM(num) OVER (ORDER BY time ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS num
from table1

```
