```java
    private String getJsonStr(InputStream is) {
        try (JSONReader reader = new JSONReader(new InputStreamReader(is))) {
            JSONObject jsonObject = reader.readObject(JSONObject.class);
            return jsonObject.toJSONString();
        }
    }

private String getJsonStr(String path) throws FileNotFoundException {
        JSONReader reader = new JSONReader(new FileReader(path));
        String jsonStr = reader.readObject(JSONObject.class).toJSONString(); 
    }
```
