## pgsql-note
```postgresql
-- 更新json字段
select param_json from student where param_json ->> 'no' = 'OFFE10099936';
update student set param_json = (jsonb_set(param_json, '{no}', '"11"')) where id = 12040;

VACUUM ANALYSE student;
REFRESH MATERIALIZED VIEW CONCURRENTLY release_list_view;
REFRESH MATERIALIZED VIEW release_list_view;

show random_page_cost;
select name, setting from pg_settings;

select * from pg_stat_activity where usename = 'xxxx';

select locks.pid,
       locks."mode",
       locks.locktype,
       psa.query,
       psa.state,
       locks.relation,
       locks.transactionid,
       locks.virtualtransaction,
       psa.datname,
       psa.usename,
       psa.client_addr,
       psa.client_port
from pg_locks locks
         left join pg_stat_activity psa on
    locks.pid = psa.pid;  
```
