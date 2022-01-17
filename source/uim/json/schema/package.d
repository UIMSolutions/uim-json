module uim.json.schema;

import uim.json;
public import uim.json.schema.property;
public import uim.json.schema.document;
public import uim.json.schema.properties;


enum PrimitiveTypes : string {
	NULL = "null", // A JSN "null" production
	BOOLEAN = "boolean", // A "true" or "false" value, from the JSN "true" or "false" productions
	OBJECT = "object", // An unordered set of properties mapping a string to an instance, from the JSN "object" production
	ARRAY = "array", // An ordered list of instances, from the JSN "array" production
	NUMBER = "number", // An arbitrary-precision, base-10 decimal number value, from the JSN "number" production
	STRING = "string" //A string of Unicode code points, from the JSN "string" production
}

unittest {
	assert(PrimitiveTypes.STRING == "string");
}