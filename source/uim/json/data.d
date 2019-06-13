module uim.json.data;

import std.string;
import uim.json;

class DJSONData {
private:
	string _name;
	DJSONValue _value;

public:
	this(string name) { this.name = name; }
	this(string name, DJSONValue value) { this(name); this.value = value; }
	this(string name, string value) { this(name); this.value = JSONValue(value); }

	this(string name, bool value) { this(name); this.value = JSONValue(value); }
	this(string name, double value) { this(name); this.value = JSONValue(value); }
	this(string name, int value) { this(name, JSONValue(value)); }

	this(string name, bool[] values) { this(name, JSONValue(values)); }
	this(string name, double[] values) { this(name, JSONValue(values)); }
	this(string name, int[] values) { this(name, JSONValue(values)); }

	@property auto name() { return _name; }
	@property void name(string newName) { _name = newName; }

	@property auto value() { return _value; }
	@property void value(DJSONValue newValue) { _value = newValue; }
	@property size_t length() { return 1; }

	override string toString() {
		import std.string;
		return `"%s" : %s`.format(name, value.toString);
	}
}
auto JSONData(string name) { return new DJSONData(name); }
auto JSONData(string name, DJSONValue value) { return new DJSONData(name, value); }
auto JSONData(string name, string value) { return new DJSONData(name, value); }

unittest {

}