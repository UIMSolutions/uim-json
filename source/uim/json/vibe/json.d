module uim.json.vibe.json;

import uim.json; 

auto jsonToStringAA(Json json) {
  string[string] results;
  deserializeJson(results, json);
  foreach (string key, value; json) writefln("%s: %s", key, value);
  return results; 
}
version(test_uim_json) { unittest {
/*   auto test = ["a":"b", "c":"d"];
  writeln(jsonToStringAA(serializeToJson(test)));
  writeln(serializeToJson(test)); */
}}