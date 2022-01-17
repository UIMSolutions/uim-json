module uim.json.classes.number;

import uim.json;

class DJSNNumber : DJSNValue {
private:
	double _value = 0;
public:
	this() { }
	this(double value) { this.value = value; }
	this(string value) { this.value = value; }
	this(DJSNNumber value) { this.value = value; }
	alias value this;

	@property override size_t length() { return 1; }

	@property void value(int newValue) { _value = newValue; }
	@property void value(double newValue) { _value = newValue; }
	@property void value(string newValue) { import std.conv; value = to!double(newValue); }
	@property void value(DJSNNumber newValue) { value = newValue.value; }
	@property void value(DJSNValue newValue) { value = newValue.toString; }

	@property double value() { return _value; }

	@property double get() { return _value; }


	override DJSNValue dup() { return JSNNumber(_value); }

	override string toString() {
		import std.conv;

		return to!string(_value);
	}
}
auto JSNNumber() { return new DJSNNumber(); }
auto JSNNumber(T)(T value) { return new DJSNNumber(value); }

