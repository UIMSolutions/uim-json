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
	// alias value this;

	@property override size_t length() { return 1; }

	@property void value(this O)(int newValue) { _value = newValue; 
		return cast(O)this;
	}

	@property O value(this O)(double newValue) { _value = newValue; 
		return cast(O)this;
	}

	@property O value(this O)(string newValue) { 
		import std.conv; 
		this.value(to!double(newValue)); 
		return cast(O)this;
	}

	@property O value(this O)(DJSNNumber newValue) { 
		_value = newValue.value; 
		return cast(O)this;
	}

	@property O value(this O)(DJSNValue newValue) { value = newValue.toString; 
		return cast(O)this;
	}

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

