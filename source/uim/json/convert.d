module uim.json.convert;

import uim.json;

/**
 * toJson - Converts string arrays to Vibe.d Json
 */
Json toJson(T)(T[] props) if ((isBoolean!T) || (isIntegral!T) || (isFloatingPoint!T) || (isSomeString!T)) {
	Json result = Json.emptyArray;
	foreach(prop; props) result ~= prop;
	return result;
}
unittest {
	assert([1, 2, 3].toJson.toString == `[1,2,3]`);
	assert(["1", "2", "3"].toJson.toString == `["1","2","3"]`);
}

Json toJson(T)(T[] props) if ((!isSomeString!T) && ((isArray!T) || (isAssociativeArray!T))) {
	Json result = Json.emptyArray;
	foreach(prop; props) result ~= prop.toJson;
	return result;
}
unittest {
	assert([1, 2, 3].toJson.toString == `[1,2,3]`);
	assert(["1", "2", "3"].toJson.toString == `["1","2","3"]`);
}

/**
 * toJson - Converts string associative arrays to Vibe.d Json
 */
Json toJson(T)(T[string] props) if ((isBoolean!T) || (isIntegral!T) || (isFloatingPoint!T) || (isSomeString!T)) {
	Json result = Json.emptyObject;
	foreach(k, v; props) {
		result[k] = v;
	}
	return result;
}
unittest {
	assert(["a":1].toJson.toString == `{"a":1}`);
	assert(["a":"x"].toJson.toString == `{"a":"x"}`);
}

Json toJson(T)(T[string] props) if ((!isSomeString!T) && ((isArray!T) || (isAssociativeArray!T))) {
	Json result = Json.emptyObject;
	foreach(k, v; props) {
		result[k] = v.toJson;
	}
	return result;
}
unittest {
	assert(["a":1].toJson.toString == `{"a":1}`);
	assert(["a":"x"].toJson.toString == `{"a":"x"}`);
}
