module uim.json.value;

import std.stdio;
import std.traits;
import uim.json;

class DJSONValue {
	/++ 
	 + JSON values can be:
	 A number (integer or floating point)
	 A string (in double quotes)
	 A Boolean (true or false)
	 An array (in square brackets)
	 An object (in curly braces)
	 null
	 +/

	@property auto keys() { return null; }

	@property size_t length() { return 0; }
	O opIndexAssign(this O, T)(T value, string name) if ((isNarrowString!T) && (isArray!T)) { return cast(O)this; }
	O opIndexAssign(this O, T)(T value, string name) if ((!isNarrowString!T) && (!isArray!T)) { return cast(O)this; }
	O opIndexAssign(this O, T)(T values, string name) if ((!isNarrowString!T) && (isArray!T)) { return cast(O)this; }

	O opIndexAssign(this O, T)(T value, size_t index) if ((isNarrowString!T) && (isArray!T)) { return cast(O)this; }
	O opIndexAssign(this O, T)(T value, size_t index) if ((!isNarrowString!T) && (!isArray!T)) { return cast(O)this; }
	O opIndexAssign(this O, T)(T values, size_t index) if ((!isNarrowString!T) && (isArray!T)) { return cast(O)this; }

	DJSONValue opIndex(size_t index) { return null; }
	DJSONValue opIndex(string name) { return null; }

	bool exists(size_t index) { return (this[index] ? true : false); }
	bool exists(string name) { return (this[name] ? true : false); }
	bool pathExists(string[] names...) {
		if (names.length == 0) return false;
		if (auto first = this[names[0]]) {
			if (names.length > 1) return first.pathExists(names[1..$]);
			return true;
		}
		return false;
	}
	DJSONValue pathValue(string[] names...) {
		if (names.length == 0) return null;
		if (auto first = this[names[0]]) {
			if (names.length > 1) return first.pathValue(names[1..$]);
			return first;
		}
		return null;
	}

	DJSONValue dup() { return null; }
	override string toString() {
		return "";
	}
}
auto JSONValue() { return JSONNull; }

/*
auto JSONValue(DJSONValue value) { return value/*.dup* /; }
auto JSONValue(string value) { return JSONString(value); }
auto JSONValue(int value) { return JSONNumber(value); }
auto JSONValue(double value) { return JSONNumber(value); }
auto JSONValue(bool value) { return JSONBoolean(value); }
auto JSONValue(DJSONArray value) { return JSONArray(value); }
auto JSONValue(DJSONObject value) { return JSONObject(value); }

auto JSONValue(DJSONValue[] values) { return JSONArray(values)/ *.dup* / ; }
auto JSONValue(string[] values) { return JSONArray(values); }
auto JSONValue(int[] values) { return JSONArray(values); }
auto JSONValue(double[] values) { return JSONArray(values); }
auto JSONValue(bool[] values) { return JSONArray(values); }*/
