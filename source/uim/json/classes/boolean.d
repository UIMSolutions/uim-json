module uim.json.classes.boolean;

import uim.json;

class DJSNBoolean : DJSNValue {
	import std.string;
	bool _value = false;
	alias value this;

	this() { }
	this(bool value) { this.value = value; }
	this(int value) { this.value = value; }
	this(double value) { this.value = value; }
	this(string value) { this.value = value; }
	this(DJSNBoolean value) { this.value = value; }
	this(DJSNValue value) { this.value = value; }

	@property void value(bool newValue) { _value = newValue; }
	@property void value(int newValue) { value = (newValue != 0 ? true : false); }
	@property void value(double newValue) { value = (((newValue == 0) || (newValue.nan))  ? false : true); }
	@property void value(string newValue) { value = (newValue.toLower == "true" ? true : false); }
	@property void value(DJSNBoolean newValue) { value = newValue.value; }
	@property void value(DJSNValue newValue) { value = newValue.toString; }

	@property bool value() { return _value; }
	@property override size_t length() { return 1; }

	void opCall(T)(T newValue) { value = newValue; }

	override DJSNValue dup() { return JSNBoolean(value); }
	override string toString() { return (_value ? "true" : "false"); }
}
auto JSNBoolean() { return new DJSNBoolean(); }
auto JSNBoolean(T)(T value) { return new DJSNBoolean(value); }

