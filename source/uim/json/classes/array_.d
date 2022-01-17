module uim.json.classes.array_;

import uim.json; 
/*
class DJSNArray : DJSNValue {
	protected DJSNValue[] _values;

	this() { }
	this(DJSNArray value) { this.values = value.values; }
	this(DJSNValue[] values) { this.values = values; }
	this(DJSNObject[] values) { this.values = values; }
	this(DJSNArray[] values) { this.values = values; }
	this(string[] values) { foreach(v; values) _values ~= JSNValue(v); }
	this(bool[] values) { foreach(v; values) _values ~= JSNValue(v); }
	this(int[] values) { foreach(v; values) _values ~= JSNValue(v); }
	this(double[] values) { foreach(v; values) _values ~= JSNValue(v); }

	@property void values(DJSNValue[] newValues) { _values = null; foreach(v; newValues) _values ~= v.dup; }
	@property void values(DJSNArray[] newValues) { _values = null; foreach(v; newValues) _values ~= v.dup; }
	@property void values(DJSNObject[] newValues) { _values = null; foreach(v; newValues) _values ~= v.dup; }
	@property auto values() { return _values; }

	@property override size_t length() { return _values.length; }
	@property void length(size_t newLength) { 
		if (newLength > length) foreach(i; length..newLength) _values ~= JSNNull;  
		else _values.length = newLength;							
	}
	@property DJSNArray subArray(size_t start, size_t end) { 
		auto last = end;
		if (last > length) last = length;
		return JSNArray(_values[start..last]);
	}
	@property DJSNArray reverse() { 
		DJSNValue[] reversedValues; 
		foreach_reverse(v; values) reversedValues ~= v;
		_values = reversedValues;
		return this;
	}

	override DJSNValue opIndex(size_t index) {
		if (index < _values.length) return _values[index];
		return null;
	}
	O opOpAssign(string op, this O)(DJSNValue value) if (op == "~") { 
		_values ~= value;
		return cast(O)this;
	}
	O opBinary(string op, this O)(DJSNValue value) if (op == "~") { 
		_values ~= value;
		return cast(O)this;
	}
	unittest {
		/// test
	}
	
	override DJSNValue dup() { return new DJSNArray(_values); }
	override string toString() {
		if (_values.length == 0) return "[ ]";

		import std.string;
		string[] strings;
		foreach(value; _values) strings ~= value.toString;
		return `[ %s ]`.format(strings.join(", "));
	}
}
auto JSNArray() { return new DJSNArray(); }
auto JSNArray(DJSNArray value) { return new DJSNArray(value); }
//auto JSNArray(T)(T[] values) { return new DJSNArray(values); }
//auto JSNArray(string text) { return new DJSNArray(); }
*/