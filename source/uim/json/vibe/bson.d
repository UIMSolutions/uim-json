module uim.json.vibe.bson;

import uim.json; 

auto bsonToStringAA(Bson bson) {
  string[string] results;
  deserializeBson(results, bson);
  foreach (string key, value; bson) writefln("%s: %s", key, value);
  return results; 
}
unittest{
  auto test = ["a":"b", "c":"d"];
  writeln(bsonToStringAA(serializeToBson(test)));
}