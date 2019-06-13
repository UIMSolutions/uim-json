module uim.json.number;

import uim.json;

class DJSONNumber : DJSONValue {
private:
	double _value = 0;
public:
	this() { }
	this(double value) { this.value = value; }
	this(string value) { this.value = value; }
	this(DJSONNumber value) { this.value = value; }
	alias value this;

	@property override size_t length() { return 1; }

	@property void value(int newValue) { _value = newValue; }
	@property void value(double newValue) { _value = newValue; }
	@property void value(string newValue) { import std.conv; value = to!double(newValue); }
	@property void value(DJSONNumber newValue) { value = newValue.value; }
	@property void value(DJSONValue newValue) { value = newValue.toString; }

	@property double value() { return _value; }

	@property double get() { return _value; }


	override DJSONValue dup() { return JSONNumber(_value); }

	override string toString() {
		import std.conv;

		return to!string(_value);
	}
}
auto JSONNumber() { return new DJSONNumber(); }
auto JSONNumber(T)(T value) { return new DJSONNumber(value); }

