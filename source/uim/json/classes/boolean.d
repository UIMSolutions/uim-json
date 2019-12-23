module uim.json.classes.boolean;

import uim.json;

class DJSONBoolean : DJSONValue {
	import std.string;
	bool _value = false;
	alias value this;

	this() { }
	this(bool value) { this.value = value; }
	this(int value) { this.value = value; }
	this(double value) { this.value = value; }
	this(string value) { this.value = value; }
	this(DJSONBoolean value) { this.value = value; }
	this(DJSONValue value) { this.value = value; }

	@property void value(bool newValue) { _value = newValue; }
	@property void value(int newValue) { value = (newValue != 0 ? true : false); }
	@property void value(double newValue) { value = (((newValue == 0) || (newValue.nan))  ? false : true); }
	@property void value(string newValue) { value = (newValue.toLower == "true" ? true : false); }
	@property void value(DJSONBoolean newValue) { value = newValue.value; }
	@property void value(DJSONValue newValue) { value = newValue.toString; }

	@property bool value() { return _value; }
	@property override size_t length() { return 1; }

	void opCall(T)(T newValue) { value = newValue; }

	override DJSONValue dup() { return JSONBoolean(value); }
	override string toString() { return (_value ? "true" : "false"); }
}
auto JSONBoolean() { return new DJSONBoolean(); }
auto JSONBoolean(T)(T value) { return new DJSONBoolean(value); }

