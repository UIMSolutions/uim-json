module uim.json.classes.array_;

import uim.json; 
/*
class DJSONArray : DJSONValue {
	protected DJSONValue[] _values;

	this() { }
	this(DJSONArray value) { this.values = value.values; }
	this(DJSONValue[] values) { this.values = values; }
	this(DJSONObject[] values) { this.values = values; }
	this(DJSONArray[] values) { this.values = values; }
	this(string[] values) { foreach(v; values) _values ~= JSONValue(v); }
	this(bool[] values) { foreach(v; values) _values ~= JSONValue(v); }
	this(int[] values) { foreach(v; values) _values ~= JSONValue(v); }
	this(double[] values) { foreach(v; values) _values ~= JSONValue(v); }

	@property void values(DJSONValue[] newValues) { _values = null; foreach(v; newValues) _values ~= v.dup; }
	@property void values(DJSONArray[] newValues) { _values = null; foreach(v; newValues) _values ~= v.dup; }
	@property void values(DJSONObject[] newValues) { _values = null; foreach(v; newValues) _values ~= v.dup; }
	@property auto values() { return _values; }

	@property override size_t length() { return _values.length; }
	@property void length(size_t newLength) { 
		if (newLength > length) foreach(i; length..newLength) _values ~= JSONNull;  
		else _values.length = newLength;							
	}
	@property DJSONArray subArray(size_t start, size_t end) { 
		auto last = end;
		if (last > length) last = length;
		return JSONArray(_values[start..last]);
	}
	@property DJSONArray reverse() { 
		DJSONValue[] reversedValues; 
		foreach_reverse(v; values) reversedValues ~= v;
		_values = reversedValues;
		return this;
	}

	override DJSONValue opIndex(size_t index) {
		if (index < _values.length) return _values[index];
		return null;
	}
	O opOpAssign(string op, this O)(DJSONValue value) if (op == "~") { 
		_values ~= value;
		return cast(O)this;
	}
	O opBinary(string op, this O)(DJSONValue value) if (op == "~") { 
		_values ~= value;
		return cast(O)this;
	}
	unittest {
		/// test
	}
	
	override DJSONValue dup() { return new DJSONArray(_values); }
	override string toString() {
		if (_values.length == 0) return "[ ]";

		import std.string;
		string[] strings;
		foreach(value; _values) strings ~= value.toString;
		return `[ %s ]`.format(strings.join(", "));
	}
}
auto JSONArray() { return new DJSONArray(); }
auto JSONArray(DJSONArray value) { return new DJSONArray(value); }
//auto JSONArray(T)(T[] values) { return new DJSONArray(values); }
//auto JSONArray(string text) { return new DJSONArray(); }
*/