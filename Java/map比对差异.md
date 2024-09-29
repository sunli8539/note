```java
import com.google.common.collect.MapDifference;
import com.google.common.collect.Maps;
import com.github.wnameless.json.flattener.JsonFlattener;
import cn.hutool.core.util.XmlUtil;

Map<String, Object> left = XMLUtils.flattenAsMap(leftFile);
Map<String, Object> right = XMLUtils.flattenAsMap(rightFile);
MapDifference<String, Object> difference = Maps.difference(left, right);

Map<String, MapDifference.ValueDifference<Object>> diffMap = difference.entriesDiffering();
Map<String, Object> leftOnlyMap = difference.entriesOnlyOnLeft();
Map<String, Object> rightOnlyMap = difference.entriesOnlyOnRight();


    public static Map<String, Object> flattenAsMap(String filePath) {
        long s = System.currentTimeMillis();
        String xml = XmlUtil.toStr(XmlUtil.readXML(filePath));
        String json = JsonUtils.mapToJson(XmlUtil.xmlToMap(xml));
        long e = System.currentTimeMillis();
        log.info("parseXml2Json {} cost {}", filePath, e - s);
        return JsonFlattener.flattenAsMap(json);
    }

    public static String mapToJson(Map map) {
        try {
            return new ObjectMapper().writeValueAsString(map);
        } catch (Exception e) {
            LOGGER.error("mapToJson error:{}", e);
            throw new BusinessException("mapToJson exception");
        }
    }
```
