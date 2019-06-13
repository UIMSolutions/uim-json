module uim.json.schema;

import uim.json;
public import uim.json.schema.property;
public import uim.json.schema.document;
public import uim.json.schema.properties;


enum PrimitiveTypes : string {
	NULL = "null", // A JSON "null" production
	BOOLEAN = "boolean", // A "true" or "false" value, from the JSON "true" or "false" productions
	OBJECT = "object", // An unordered set of properties mapping a string to an instance, from the JSON "object" production
	ARRAY = "array", // An ordered list of instances, from the JSON "array" production
	NUMBER = "number", // An arbitrary-precision, base-10 decimal number value, from the JSON "number" production
	STRING = "string" //A string of Unicode code points, from the JSON "string" production
}

unittest {
	assert(PrimitiveTypes.STRING == "string");
}