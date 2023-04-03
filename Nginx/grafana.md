## grafana  
```shell
location /stats/ {  
    add_header 'Access-Control-Allow-Origin' '*';  
    rewrite ^/stats/(.*) /$1 break;  
    proxy_pass  http://xxxx:3000/;  
    proxy_set_header   Host $host;  
}  
```

```text
修改grafana配置(grafana.ini)  
doamin  
root_url  
```

