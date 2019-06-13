module uim.json.object_;

import std.stdio; 
import std.string; 
import std.traits; 
import uim.json; 

class DJSONObject : DJSONValue {
private:
	DJSONValue[string] _values;

public:
	this() { }
	this(DJSONObject value) { this.values = value.values; }
	this(DJSONValue[string] values) { this.values = values; }
	this(bool[string] values) { this.values = values; }
	this(double[string] values) { this.values = values; }
	this(string[string] values) { this.values = values; }

	@property auto fields() { return _values.keys; }

	@property auto values() { return _values; }
	@property void values(DJSONValue[string] values) { foreach(k, v; values) _values[k] = v.dup; }
	@property void values(T)(T[string] values) { foreach(k, v; values) _values[k] = JSONValue(v); }
	@property override size_t length() { return 1; }

	void opCall(DJSONObject value) { this.values = value.values; }
	void opCall(DJSONValue[string] values) { this.values = values; }
	void opCall(string[string] values) { this.values = values; }

	//alias opIndexAssign = super.opIndexAssign;
	O opIndexAssign(this O, T)(T value, string name) if ((isNarrowString!T) && (isArray!T)) { _values[name] = JSONString(value); return cast(O)this; }
	O opIndexAssign(this O, T)(T value, string name) if ((!isNarrowString!T) && (!isArray!T)) { 
//		writeln("override void opIndexAssign(T)(T value, string name)");
//		writeln("Before... ", values);
		_values[name] = JSONValue(value); 
//		writeln("After... ", values);
		return cast(O)this;
	}
	O opIndexAssign(this O, T)(T values, string name) if ((!isNarrowString!T) && (isArray!T)) { _values[name] = JSONArray(values); return cast(O)this; }

	O opIndexAssign(this O, T)(T value, size_t index) if ((isNarrowString!T) && (isArray!T)) { if (index < length) _values[_values.keys[index]] = JSONString(value); return cast(O)this; }
	O opIndexAssign(this O, T)(T value, size_t index) if ((!isNarrowString!T) && (!isArray!T)) { 
		writeln("override void opIndexAssign(T)(T value, string name)");
		writeln("Before... ", values);
		if (index < length) _values[_values.keys[index]] = JSONValue(value); 
		writeln("After... ", values);
		return cast(O)this;
	}
	O opIndexAssign(this O, T)(T values, size_t index) if ((!isNarrowString!T) && (isArray!T)) { if (index < length) _values[_values.keys[index]] = JSONArray(values); return cast(O)this; }

	override DJSONValue opIndex(string name) { if (name in values) return values[name]; return null; }
	override DJSONValue opIndex(size_t index) { if (index < length) return this[fields[index]]; return null; }

	DJSONValue remove(string name) {
		if (auto result = this[name]) {
			_values.remove(name); return result;
		}  
		return null;
	}
	auto clear() { _values.clear; return this; }

	override DJSONValue dup() { return JSONObject(values); }

//	void fromString(string jsonString) {
//		auto str = jsonString.strip;
//		if (str.empty) return;
//		if (!str.startsWith("{")) return;
//		if (!str.endsWith("}")) return;
//
//		auto innerStr = str[1..$-1].strip; 
//		if (innerStr.empty) return;
//
//		string fieldName = readNextFieldName(innerStr);
//	}
	override string toString() {
		import std.string;

		string[] strings;
		foreach(k, v; values) strings ~= `"%s" : %s`.format(k, v.toString);
		return `{ %s }`.format(strings.join(", "));
	}
}
auto JSONObject() { return new DJSONObject(); }
auto JSONObject(DJSONObject value) { return new DJSONObject(value); }
auto JSONObject(DJSONValue[string] values) { return new DJSONObject(values); }
auto JSONObject(string[string] values) { return new DJSONObject(values); }
auto JSONObject(bool[string] values) { return new DJSONObject(values); }
auto JSONObject(double[string] values) { return new DJSONObject(values); }

auto JSONObject(string text) {
	auto txt = strip(text);
	if (txt[0] != '{') return null;
	if (txt[$-1] != '}') return null;

	return JSONObject(text);
}

