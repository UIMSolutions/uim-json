module uim.json.classes.string_;

import uim.json;

class DJSNString : DJSNValue {
	string _value;

	this() { }
	this(string value) { this.value = value; }
	this(DJSNString value) { this.value = value.value; }
	alias value this;

	@property void value(string newValue) { _value = newValue; }
	@property void value(DJSNValue newValue) { value = newValue.toString; }

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
	O opBinary(string op, this O, T)(DJSNValue rhs) {
		static if (op == "~") { _value ~= rhs.toString; return cast(O)this; }
		else static assert(0, "Operator "~op~" not implemented");
	}

	string opCast(T : string)() { return _value; }

	override DJSNValue dup() { return JSNString(value); }
	override string toString() {
		import std.string;
		return `"%s"`.format(value);
	}
}
auto JSNString() { return new DJSNString(); }
auto JSNString(T)(T value) { return new DJSNString(value); }

