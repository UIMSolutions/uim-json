module uim.json.vibe.bson;

import uim.json; 

auto bsonToStringAA(Bson bson) {
  STRINGAA results;
  deserializeBson(results, bson);
  foreach (string key, value; bson) writefln("%s: %s", key, value);
  return results; 
}
version(test_uim_json) { unittest {
/*   auto test = ["a":"b", "c":"d"];
  writeln(bsonToStringAA(serializeToBson(test))); */
}}