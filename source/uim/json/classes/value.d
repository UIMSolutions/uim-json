module uim.json.classes.value;

import std.stdio;
import std.traits;
import uim.json;

class DJSNValue {
	/++ 
	 + JSN values can be:
	 A number (integer or floating point)
	 A string (in double quotes)
	 A Boolean (true or false)
	 An array (in square brackets)
	 An object (in curly braces)
	 null
	 +/

	@property auto keys() { return null; }

	@property size_t length() { return 0; }
	O opIndexAssign(this O, T)(T value, string name) if ((isNarrowString!T) && (isArray!T)) { return cast(O)this; }
	O opIndexAssign(this O, T)(T value, string name) if ((!isNarrowString!T) && (!isArray!T)) { return cast(O)this; }
	O opIndexAssign(this O, T)(T values, string name) if ((!isNarrowString!T) && (isArray!T)) { return cast(O)this; }

	O opIndexAssign(this O, T)(T value, size_t index) if ((isNarrowString!T) && (isArray!T)) { return cast(O)this; }
	O opIndexAssign(this O, T)(T value, size_t index) if ((!isNarrowString!T) && (!isArray!T)) { return cast(O)this; }
	O opIndexAssign(this O, T)(T values, size_t index) if ((!isNarrowString!T) && (isArray!T)) { return cast(O)this; }

	DJSNValue opIndex(size_t index) { return null; }
	DJSNValue opIndex(string name) { return null; }

	bool exists(size_t index) { return (this[index] ? true : false); }
	bool exists(string name) { return (this[name] ? true : false); }
	bool pathExists(string[] names...) {
		if (names.length == 0) { 
      return false; 
    }
		if (auto first = this[names[0]]) {
			if (names.length > 1) return first.pathExists(names[1..$]);
			return true;
		}
		return false;
	}
	DJSNValue pathValue(string[] names...) {
		if (names.length == 0) return null;
		if (auto first = this[names[0]]) {
			if (names.length > 1) return first.pathValue(names[1..$]);
			return first;
		}
		return null;
	}

	bool opEquals(string txt) { return (toString == txt); }

	DJSNValue dup() { return null; }
	override string toString() {
		return "";
	}
}
auto JSNValue() { return JSNNull; }

auto JSNValue(DJSNValue value) { return value/*.dup*/; }
auto JSNValue(string value) { return JSNString(value); }
auto JSNValue(int value) { return JSNNumber(value); }
auto JSNValue(double value) { return JSNNumber(value); }
auto JSNValue(bool value) { return JSNBoolean(value); }
//auto JSNValue(DJSNArray value) { return JSNArray(value); }
auto JSNValue(DJSNObject value) { return JSNObject(value); }
/*
auto JSNValue(DJSNValue[] values) { return JSNArray(values)/ *.dup* /; }
auto JSNValue(string[] values) { return JSNArray(values); }
auto JSNValue(int[] values) { return JSNArray(values); }
auto JSNValue(double[] values) { return JSNArray(values); }
auto JSNValue(bool[] values) { return JSNArray(values); }
*/