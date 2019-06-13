module uim.json.string_;

import uim.json;

class DJSONString : DJSONValue {
	string _value;

	this() { }
	this(string value) { this.value = value; }
	this(DJSONString value) { this.value = value.value; }
	alias value this;

	@property void value(string newValue) { _value = newValue; }
	@property void value(DJSONValue newValue) { value = newValue.toString; }

	@property string value() { return _value; }
	@property override size_t length() { return 1; }

	O opBinary(string op, this O)(string rhs) {
		static if (op == "~") { _value ~= rhs; return cast(O)this; }
		else static assert(0, "Operator "~op~" not implemented");
	}
	O opBinary(string op, this O, T)(T rhs) if (is(T == int) || is(T == double)) {
		static if (op == "~") { _value ~= to!string(rhs); return cast(O)this; }
		else static assert(0, "Operator "~op~" not implemented");
	}
	O opBinary(string op, this O, T)(DJSONValue rhs) {
		static if (op == "~") { _value ~= rhs.toString; return cast(O)this; }
		else static assert(0, "Operator "~op~" not implemented");
	}

	string opCast(T : string)() { return _value; }

	override DJSONValue dup() { return JSONString(value); }
	override string toString() {
		import std.string;
		return `"%s"`.format(value);
	}
}
auto JSONString() { return new DJSONString(); }
auto JSONString(T)(T value) { return new DJSONString(value); }

