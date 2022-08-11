module uim.json.classes.data;

import std.string;
import uim.json;
/*
class DJSNData {
private:
	string _name;
	DJSNValue _value;

public:
	this(string name) { this.name = name; }
	this(string name, DJSNValue value) { this(name); this.value = value; }
	this(string name, string value) { this(name); this.value = JSNValue(value); }

	this(string name, bool value) { this(name); this.value = JSNValue(value); }
	this(string name, double value) { this(name); this.value = JSNValue(value); }
	this(string name, int value) { this(name, JSNValue(value)); }

	this(string name, bool[] values) { this(name, JSNValue(values)); }
	this(string name, double[] values) { this(name, JSNValue(values)); }
	this(string name, int[] values) { this(name, JSNValue(values)); }

	@property auto name() { return _name; }
	@property void name(string newName) { _name = newName; }

	@property auto value() { return _value; }
	@property void value(DJSNValue newValue) { _value = newValue; }
	@property size_t length() { return 1; }

	override string toString() {
		import std.string;
		return `"%s" : %s`.format(name, value.toString);
	}
}
auto JSNData(string name) { return new DJSNData(name); }
auto JSNData(string name, DJSNValue value) { return new DJSNData(name, value); }
auto JSNData(string name, string value) { return new DJSNData(name, value); }

version(test_uim_json) { unittest {

}*/