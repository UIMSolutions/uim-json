module uim.json.parser;
//
//// Written in the D programming language.
//
///**
//JavaScript Object Notation
//
//Synopsis:
//----
//    //parse a file or string of json into a usable structure
//    string s = "{ \"language\": \"D\", \"rating\": 3.14, \"code\": \"42\" }";
//    JSONValue j = parseJSON(s);
//    writeln("Language: ", j["language"].str(),
//            " Rating: ", j["rating"].floating()
//    );
//
//    // j and j["language"] return JSONValue,
//    // j["language"].str returns a string
//
//    //check a type
//    long x;
//    if (const(JSONValue)* code = "code" in j)
//    {
//        if (code.type() == JSON_TYPE.INTEGER)
//            x = code.integer;
//        else
//            x = to!int(code.str);
//    }
//
//    // create a json struct
//    JSONValue jj = [ "language": "D" ];
//    // rating doesnt exist yet, so use .object to assign
//    jj.object["rating"] = JSONValue(3.14);
//    // create an array to assign to list
//    jj.object["list"] = JSONValue( ["a", "b", "c"] );
//    // list already exists, so .object optional
//    jj["list"].array ~= JSONValue("D");
//
//    s = j.toString();
//    writeln(s);
//----
//
//Copyright: Copyright Jeremie Pelletier 2008 - 2009.
//License:   $(HTTP www.boost.org/LICENSE_1_0.txt, Boost License 1.0).
//Authors:   Jeremie Pelletier, David Herberth
//References: $(LINK http://json.org/)
//Source:    $(PHOBOSSRC std/_json.d)
//*/
///*
//         Copyright Jeremie Pelletier 2008 - 2009.
//Distributed under the Boost Software License, Version 1.0.
//   (See accompanying file LICENSE_1_0.txt or copy at
//         http://www.boost.org/LICENSE_1_0.txt)
//*/
//module std.json;
//
//import std.conv;
//import std.range.primitives;
//import std.array;
//import std.traits;
//
///**
//String literals used to represent special float values within JSON strings.
//*/
//enum JSONFloatLiteral : string
//{
//	nan         = "NaN",       /// string representation of floating-point NaN
//	inf         = "Infinite",  /// string representation of floating-point Infinity
//	negativeInf = "-Infinite", /// string representation of floating-point negative Infinity
//}
//
///**
//Flags that control how json is encoded and parsed.
//*/
//enum JSONOptions
//{
//	none,                       /// standard parsing
//	specialFloatLiterals = 0x1, /// encode NaN and Inf float values as strings
//	escapeNonAsciiChars = 0x2   /// encode non ascii characters with an unicode escape sequence
//}
//
///**
//JSON type enumeration
//*/
//enum JSON_TYPE : byte
//{
//	/// Indicates the type of a $(D JSONValue).
//	NULL,
//	STRING,  /// ditto
//	INTEGER, /// ditto
//	UINTEGER,/// ditto
//	FLOAT,   /// ditto
//	OBJECT,  /// ditto
//	ARRAY,   /// ditto
//	TRUE,    /// ditto
//	FALSE    /// ditto
//}
//
///**
//JSON value node
//*/
//struct JSONValue
//{
//	import std.exception : enforceEx, enforce;
//	
//	union Store
//	{
//		string                          str;
//		long                            integer;
//		ulong                           uinteger;
//		double                          floating;
//		JSONValue[string]               object;
//		JSONValue[]                     array;
//	}
//	private Store store;
//	private JSON_TYPE type_tag;
//	
//	/**
//      Returns the JSON_TYPE of the value stored in this structure.
//    */
//	@property JSON_TYPE type() const pure nothrow @safe @nogc
//	{
//		return type_tag;
//	}
//	///
//	unittest
//	{
//		string s = "{ \"language\": \"D\" }";
//		JSONValue j = parseJSON(s);
//		assert(j.type == JSON_TYPE.OBJECT);
//		assert(j["language"].type == JSON_TYPE.STRING);
//	}
//	
//
//	
//	/// Value getter/setter for $(D JSON_TYPE.STRING).
//	/// Throws: $(D JSONException) for read access if $(D type) is not
//	/// $(D JSON_TYPE.STRING).
//	@property string str() const pure @trusted
//	{
//		enforce!JSONException(type == JSON_TYPE.STRING,
//			"JSONValue is not a string");
//		return store.str;
//	}
//	/// ditto
//	@property string str(string v) pure nothrow @nogc @safe
//	{
//		assign(v);
//		return v;
//	}
//	
//	/// Value getter/setter for $(D JSON_TYPE.INTEGER).
//	/// Throws: $(D JSONException) for read access if $(D type) is not
//	/// $(D JSON_TYPE.INTEGER).
//	@property inout(long) integer() inout pure @safe
//	{
//		enforce!JSONException(type == JSON_TYPE.INTEGER,
//			"JSONValue is not an integer");
//		return store.integer;
//	}
//	/// ditto
//	@property long integer(long v) pure nothrow @safe @nogc
//	{
//		assign(v);
//		return store.integer;
//	}
//	
//	/// Value getter/setter for $(D JSON_TYPE.UINTEGER).
//	/// Throws: $(D JSONException) for read access if $(D type) is not
//	/// $(D JSON_TYPE.UINTEGER).
//	@property inout(ulong) uinteger() inout pure @safe
//	{
//		enforce!JSONException(type == JSON_TYPE.UINTEGER,
//			"JSONValue is not an unsigned integer");
//		return store.uinteger;
//	}
//	/// ditto
//	@property ulong uinteger(ulong v) pure nothrow @safe @nogc
//	{
//		assign(v);
//		return store.uinteger;
//	}
//	
//	/// Value getter/setter for $(D JSON_TYPE.FLOAT). Note that despite
//	/// the name, this is a $(B 64)-bit `double`, not a 32-bit `float`.
//	/// Throws: $(D JSONException) for read access if $(D type) is not
//	/// $(D JSON_TYPE.FLOAT).
//	@property inout(double) floating() inout pure @safe
//	{
//		enforce!JSONException(type == JSON_TYPE.FLOAT,
//			"JSONValue is not a floating type");
//		return store.floating;
//	}
//	/// ditto
//	@property double floating(double v) pure nothrow @safe @nogc
//	{
//		assign(v);
//		return store.floating;
//	}
//	
//	/// Value getter/setter for $(D JSON_TYPE.OBJECT).
//	/// Throws: $(D JSONException) for read access if $(D type) is not
//	/// $(D JSON_TYPE.OBJECT).
//	/* Note: this is @system because of the following pattern:
//       ---
//       auto a = &(json.object());
//       json.uinteger = 0;        // overwrite AA pointer
//       (*a)["hello"] = "world";  // segmentation fault
//       ---
//     */
//	@property ref inout(JSONValue[string]) object() inout pure @system
//	{
//		enforce!JSONException(type == JSON_TYPE.OBJECT,
//			"JSONValue is not an object");
//		return store.object;
//	}
//	/// ditto
//	@property JSONValue[string] object(JSONValue[string] v) pure nothrow @nogc @safe
//	{
//		assign(v);
//		return v;
//	}
//	
//	/// Value getter for $(D JSON_TYPE.OBJECT).
//	/// Unlike $(D object), this retrieves the object by value and can be used in @safe code.
//	///
//	/// A caveat is that, if the returned value is null, modifications will not be visible:
//	/// ---
//	/// JSONValue json;
//	/// json.object = null;
//	/// json.objectNoRef["hello"] = JSONValue("world");
//	/// assert("hello" !in json.object);
//	/// ---
//	///
//	/// Throws: $(D JSONException) for read access if $(D type) is not
//	/// $(D JSON_TYPE.OBJECT).
//	@property inout(JSONValue[string]) objectNoRef() inout pure @trusted
//	{
//		enforce!JSONException(type == JSON_TYPE.OBJECT,
//			"JSONValue is not an object");
//		return store.object;
//	}
//	
//	/// Value getter/setter for $(D JSON_TYPE.ARRAY).
//	/// Throws: $(D JSONException) for read access if $(D type) is not
//	/// $(D JSON_TYPE.ARRAY).
//	/* Note: this is @system because of the following pattern:
//       ---
//       auto a = &(json.array());
//       json.uinteger = 0;  // overwrite array pointer
//       (*a)[0] = "world";  // segmentation fault
//       ---
//     */
//	@property ref inout(JSONValue[]) array() inout pure @system
//	{
//		enforce!JSONException(type == JSON_TYPE.ARRAY,
//			"JSONValue is not an array");
//		return store.array;
//	}
//	/// ditto
//	@property JSONValue[] array(JSONValue[] v) pure nothrow @nogc @safe
//	{
//		assign(v);
//		return v;
//	}
//	
//	/// Value getter for $(D JSON_TYPE.ARRAY).
//	/// Unlike $(D array), this retrieves the array by value and can be used in @safe code.
//	///
//	/// A caveat is that, if you append to the returned array, the new values aren't visible in the
//	/// JSONValue:
//	/// ---
//	/// JSONValue json;
//	/// json.array = [JSONValue("hello")];
//	/// json.arrayNoRef ~= JSONValue("world");
//	/// assert(json.array.length == 1);
//	/// ---
//	///
//	/// Throws: $(D JSONException) for read access if $(D type) is not
//	/// $(D JSON_TYPE.ARRAY).
//	@property inout(JSONValue[]) arrayNoRef() inout pure @trusted
//	{
//		enforce!JSONException(type == JSON_TYPE.ARRAY,
//			"JSONValue is not an array");
//		return store.array;
//	}
//	
//	/// Test whether the type is $(D JSON_TYPE.NULL)
//	@property bool isNull() const pure nothrow @safe @nogc
//	{
//		return type == JSON_TYPE.NULL;
//	}
//	
//	private void assign(T)(T arg) @safe
//	{
//		static if (is(T : typeof(null)))
//		{
//			type_tag = JSON_TYPE.NULL;
//		}
//		else static if (is(T : string))
//		{
//			type_tag = JSON_TYPE.STRING;
//			store.str = arg;
//		}
//		else static if (isSomeString!T) // issue 15884
//		{
//			type_tag = JSON_TYPE.STRING;
//			// FIXME: std.array.array(Range) is not deduced as 'pure'
//			() @trusted {
//				import std.utf : byUTF;
//				store.str = cast(immutable)(arg.byUTF!char.array);
//			}();
//		}
//		else static if (is(T : bool))
//		{
//			type_tag = arg ? JSON_TYPE.TRUE : JSON_TYPE.FALSE;
//		}
//		else static if (is(T : ulong) && isUnsigned!T)
//		{
//			type_tag = JSON_TYPE.UINTEGER;
//			store.uinteger = arg;
//		}
//		else static if (is(T : long))
//		{
//			type_tag = JSON_TYPE.INTEGER;
//			store.integer = arg;
//		}
//		else static if (isFloatingPoint!T)
//		{
//			type_tag = JSON_TYPE.FLOAT;
//			store.floating = arg;
//		}
//		else static if (is(T : Value[Key], Key, Value))
//		{
//			static assert(is(Key : string), "AA key must be string");
//			type_tag = JSON_TYPE.OBJECT;
//			static if (is(Value : JSONValue))
//			{
//				store.object = arg;
//			}
//			else
//			{
//				JSONValue[string] aa;
//				foreach (key, value; arg)
//					aa[key] = JSONValue(value);
//				store.object = aa;
//			}
//		}
//		else static if (isArray!T)
//		{
//			type_tag = JSON_TYPE.ARRAY;
//			static if (is(ElementEncodingType!T : JSONValue))
//			{
//				store.array = arg;
//			}
//			else
//			{
//				JSONValue[] new_arg = new JSONValue[arg.length];
//				foreach (i, e; arg)
//					new_arg[i] = JSONValue(e);
//				store.array = new_arg;
//			}
//		}
//		else static if (is(T : JSONValue))
//		{
//			type_tag = arg.type;
//			store = arg.store;
//		}
//		else
//		{
//			static assert(false, text(`unable to convert type "`, T.stringof, `" to json`));
//		}
//	}
//	
//	private void assignRef(T)(ref T arg) if (isStaticArray!T)
//	{
//		type_tag = JSON_TYPE.ARRAY;
//		static if (is(ElementEncodingType!T : JSONValue))
//		{
//			store.array = arg;
//		}
//		else
//		{
//			JSONValue[] new_arg = new JSONValue[arg.length];
//			foreach (i, e; arg)
//				new_arg[i] = JSONValue(e);
//			store.array = new_arg;
//		}
//	}
//	
//	/**
//     * Constructor for $(D JSONValue). If $(D arg) is a $(D JSONValue)
//     * its value and type will be copied to the new $(D JSONValue).
//     * Note that this is a shallow copy: if type is $(D JSON_TYPE.OBJECT)
//     * or $(D JSON_TYPE.ARRAY) then only the reference to the data will
//     * be copied.
//     * Otherwise, $(D arg) must be implicitly convertible to one of the
//     * following types: $(D typeof(null)), $(D string), $(D ulong),
//     * $(D long), $(D double), an associative array $(D V[K]) for any $(D V)
//     * and $(D K) i.e. a JSON object, any array or $(D bool). The type will
//     * be set accordingly.
//    */
//	this(T)(T arg) if (!isStaticArray!T)
//	{
//		assign(arg);
//	}
//	/// Ditto
//	this(T)(ref T arg) if (isStaticArray!T)
//	{
//		assignRef(arg);
//	}
//	/// Ditto
//	this(T : JSONValue)(inout T arg) inout
//	{
//		store = arg.store;
//		type_tag = arg.type;
//	}
//	///
//	unittest
//	{
//		JSONValue j = JSONValue( "a string" );
//		j = JSONValue(42);
//		
//		j = JSONValue( [1, 2, 3] );
//		assert(j.type == JSON_TYPE.ARRAY);
//		
//		j = JSONValue( ["language": "D"] );
//		assert(j.type == JSON_TYPE.OBJECT);
//	}
//	
//	void opAssign(T)(T arg) if (!isStaticArray!T && !is(T : JSONValue))
//	{
//		assign(arg);
//	}
//	
//	void opAssign(T)(ref T arg) if (isStaticArray!T)
//	{
//		assignRef(arg);
//	}
//	
//	/// Array syntax for json arrays.
//	/// Throws: $(D JSONException) if $(D type) is not $(D JSON_TYPE.ARRAY).
//	ref inout(JSONValue) opIndex(size_t i) inout pure @safe
//	{
//		auto a = this.arrayNoRef;
//		enforceEx!JSONException(i < a.length,
//			"JSONValue array index is out of range");
//		return a[i];
//	}
//	///
//	unittest
//	{
//		JSONValue j = JSONValue( [42, 43, 44] );
//		assert( j[0].integer == 42 );
//		assert( j[1].integer == 43 );
//	}
//	
//	/// Hash syntax for json objects.
//	/// Throws: $(D JSONException) if $(D type) is not $(D JSON_TYPE.OBJECT).
//	ref inout(JSONValue) opIndex(string k) inout pure @safe
//	{
//		auto o = this.objectNoRef;
//		return *enforce!JSONException(k in o,
//			"Key not found: " ~ k);
//	}
//	///
//	unittest
//	{
//		JSONValue j = JSONValue( ["language": "D"] );
//		assert( j["language"].str == "D" );
//	}
//	
//	/// Operator sets $(D value) for element of JSON object by $(D key).
//	///
//	/// If JSON value is null, then operator initializes it with object and then
//	/// sets $(D value) for it.
//	///
//	/// Throws: $(D JSONException) if $(D type) is not $(D JSON_TYPE.OBJECT)
//	/// or $(D JSON_TYPE.NULL).
//	void opIndexAssign(T)(auto ref T value, string key) pure
//	{
//		enforceEx!JSONException(type == JSON_TYPE.OBJECT || type == JSON_TYPE.NULL,
//			"JSONValue must be object or null");
//		JSONValue[string] aa = null;
//		if (type == JSON_TYPE.OBJECT)
//		{
//			aa = this.objectNoRef;
//		}
//		
//		aa[key] = value;
//		this.object = aa;
//	}
//	///
//	unittest
//	{
//		JSONValue j = JSONValue( ["language": "D"] );
//		j["language"].str = "Perl";
//		assert( j["language"].str == "Perl" );
//	}
//	
//	void opIndexAssign(T)(T arg, size_t i) pure
//	{
//		auto a = this.arrayNoRef;
//		enforceEx!JSONException(i < a.length,
//			"JSONValue array index is out of range");
//		a[i] = arg;
//		this.array = a;
//	}
//	///
//	unittest
//	{
//		JSONValue j = JSONValue( ["Perl", "C"] );
//		j[1].str = "D";
//		assert( j[1].str == "D" );
//	}
//	
//	JSONValue opBinary(string op : "~", T)(T arg) @safe
//	{
//		auto a = this.arrayNoRef;
//		static if (isArray!T)
//		{
//			return JSONValue(a ~ JSONValue(arg).arrayNoRef);
//		}
//		else static if (is(T : JSONValue))
//		{
//			return JSONValue(a ~ arg.arrayNoRef);
//		}
//		else
//		{
//			static assert(false, "argument is not an array or a JSONValue array");
//		}
//	}
//	
//	void opOpAssign(string op : "~", T)(T arg) @safe
//	{
//		auto a = this.arrayNoRef;
//		static if (isArray!T)
//		{
//			a ~= JSONValue(arg).arrayNoRef;
//		}
//		else static if (is(T : JSONValue))
//		{
//			a ~= arg.arrayNoRef;
//		}
//		else
//		{
//			static assert(false, "argument is not an array or a JSONValue array");
//		}
//		this.array = a;
//	}
//	
//	/**
//     * Support for the $(D in) operator.
//     *
//     * Tests wether a key can be found in an object.
//     *
//     * Returns:
//     *      when found, the $(D const(JSONValue)*) that matches to the key,
//     *      otherwise $(D null).
//     *
//     * Throws: $(D JSONException) if the right hand side argument $(D JSON_TYPE)
//     * is not $(D OBJECT).
//     */
//	auto opBinaryRight(string op : "in")(string k) const @safe
//	{
//		return k in this.objectNoRef;
//	}
//	///
//	unittest
//	{
//		JSONValue j = [ "language": "D", "author": "walter" ];
//		string a = ("author" in j).str;
//	}
//	
//	bool opEquals(const JSONValue rhs) const @nogc nothrow pure @safe
//	{
//		return opEquals(rhs);
//	}
//	
//	bool opEquals(ref const JSONValue rhs) const @nogc nothrow pure @trusted
//	{
//		// Default doesn't work well since store is a union.  Compare only
//		// what should be in store.
//		// This is @trusted to remain nogc, nothrow, fast, and usable from @safe code.
//		if (type_tag != rhs.type_tag) return false;
//		
//		final switch (type_tag)
//		{
//			case JSON_TYPE.STRING:
//				return store.str == rhs.store.str;
//			case JSON_TYPE.INTEGER:
//				return store.integer == rhs.store.integer;
//			case JSON_TYPE.UINTEGER:
//				return store.uinteger == rhs.store.uinteger;
//			case JSON_TYPE.FLOAT:
//				return store.floating == rhs.store.floating;
//			case JSON_TYPE.OBJECT:
//				return store.object == rhs.store.object;
//			case JSON_TYPE.ARRAY:
//				return store.array == rhs.store.array;
//			case JSON_TYPE.TRUE:
//			case JSON_TYPE.FALSE:
//			case JSON_TYPE.NULL:
//				return true;
//		}
//	}
//	
//	/// Implements the foreach $(D opApply) interface for json arrays.
//	int opApply(int delegate(size_t index, ref JSONValue) dg) @system
//	{
//		int result;
//		
//		foreach (size_t index, ref value; array)
//		{
//			result = dg(index, value);
//			if (result)
//				break;
//		}
//		
//		return result;
//	}
//	
//	/// Implements the foreach $(D opApply) interface for json objects.
//	int opApply(int delegate(string key, ref JSONValue) dg) @system
//	{
//		enforce!JSONException(type == JSON_TYPE.OBJECT,
//			"JSONValue is not an object");
//		int result;
//		
//		foreach (string key, ref value; object)
//		{
//			result = dg(key, value);
//			if (result)
//				break;
//		}
//		
//		return result;
//	}
//	
//	/// Implicitly calls $(D toJSON) on this JSONValue.
//	///
//	/// $(I options) can be used to tweak the conversion behavior.
//	string toString(in JSONOptions options = JSONOptions.none) const @safe
//	{
//		return toJSON(this, false, options);
//	}
//	
//	/// Implicitly calls $(D toJSON) on this JSONValue, like $(D toString), but
//	/// also passes $(I true) as $(I pretty) argument.
//	///
//	/// $(I options) can be used to tweak the conversion behavior
//	string toPrettyString(in JSONOptions options = JSONOptions.none) const @safe
//	{
//		return toJSON(this, true, options);
//	}
//}
//
///**
//Parses a serialized string and returns a tree of JSON values.
//Throws: $(LREF JSONException) if the depth exceeds the max depth.
//Params:
//    json = json-formatted string to parse
//    maxDepth = maximum depth of nesting allowed, -1 disables depth checking
//    options = enable decoding string representations of NaN/Inf as float values
//*/
//JSONValue parseJSON(T)(T json, int maxDepth = -1, JSONOptions options = JSONOptions.none)
//	if (isInputRange!T)
//{
//	import std.ascii : isWhite, isDigit, isHexDigit, toUpper, toLower;
//	import std.utf : toUTF8;
//	
//	JSONValue root;
//	root.type_tag = JSON_TYPE.NULL;
//	
//	if (json.empty) return root;
//	
//	int depth = -1;
//	dchar next = 0;
//	int line = 1, pos = 0;
//
//	/* */
//	void error(string msg)
//	{
//		throw new JSONException(msg, line, pos);
//	}
//	
//	dchar popChar()
//	{
//		if (json.empty) error("Unexpected end of data.");
//		dchar c = json.front;
//		json.popFront();
//		
//		if (c == '\n') {
//			line++;
//			pos = 0;
//		}
//		else {
//			pos++;
//		}
//		
//		return c;
//	}
//	
//	dchar peekChar() {
//		if (!next) {
//			if (json.empty) return '\0';
//			next = popChar();
//		}
//		return next;
//	}
//	
//	void skipWhitespace() {
//		while (isWhite(peekChar())) next = 0;
//	}
//	
//	dchar getChar(bool SkipWhitespace = false)() {
//		static if (SkipWhitespace) skipWhitespace();
//		
//		dchar c;
//		if (next) {
//			c = next;
//			next = 0;
//		}
//		else c = popChar();
//		
//		return c;
//	}
//	
//	void checkChar(bool SkipWhitespace = true, bool CaseSensitive = true)(char c) {
//		static if (SkipWhitespace) skipWhitespace();
//		auto c2 = getChar();
//		static if (!CaseSensitive) c2 = toLower(c2);
//		
//		if (c2 != c) error(text("Found '", c2, "' when expecting '", c, "'."));
//	}
//	
//	bool testChar(bool SkipWhitespace = true, bool CaseSensitive = true)(char c) {
//		static if (SkipWhitespace) skipWhitespace();
//		auto c2 = peekChar();
//		static if (!CaseSensitive) c2 = toLower(c2);
//		
//		if (c2 != c) return false;
//		
//		getChar();
//		return true;
//	}
//	
//	string parseString() {
//		auto str = appender!string();
//		
//	Next:
//		switch (peekChar()) {
//			case '"':
//				getChar();
//				break;
//				
//			case '\\':
//				getChar();
//				auto c = getChar();
//				switch (c)	{
//					case '"':       str.put('"');   break;
//					case '\\':      str.put('\\');  break;
//					case '/':       str.put('/');   break;
//					case 'b':       str.put('\b');  break;
//					case 'f':       str.put('\f');  break;
//					case 'n':       str.put('\n');  break;
//					case 'r':       str.put('\r');  break;
//					case 't':       str.put('\t');  break;
//					case 'u':
//						dchar val = 0;
//						foreach_reverse (i; 0 .. 4)
//						{
//							auto hex = toUpper(getChar());
//							if (!isHexDigit(hex)) error("Expecting hex character");
//							val += (isDigit(hex) ? hex - '0' : hex - ('A' - 10)) << (4 * i);
//						}
//						char[4] buf;
//						str.put(toUTF8(buf, val));
//						break;
//						
//					default:
//						error(text("Invalid escape sequence '\\", c, "'."));
//				}
//				goto Next;
//				
//			default:
//				auto c = getChar();
//				appendJSONChar(str, c, options, &error);
//				goto Next;
//		}
//		
//		return str.data.length ? str.data : "";
//	}
//	
//	bool tryGetSpecialFloat(string str, out double val) {
//		switch (str)
//		{
//			case JSONFloatLiteral.nan:
//				val = double.nan;
//				return true;
//			case JSONFloatLiteral.inf:
//				val = double.infinity;
//				return true;
//			case JSONFloatLiteral.negativeInf:
//				val = -double.infinity;
//				return true;
//			default:
//				return false;
//		}
//	}
//	
//	void parseValue(ref JSONValue value)
//	{
//		auto c = getChar!true();
//		
//		switch (c)
//		{
//			case '{':
//				if (testChar('}'))
//				{
//					value.object = null;
//					break;
//				}
//				
//				JSONValue[string] obj;
//				do
//				{
//					checkChar('"');
//					string name = parseString();
//					checkChar(':');
//					JSONValue member;
//					parseValue(member);
//					obj[name] = member;
//				}
//				while (testChar(','));
//				value.object = obj;
//				
//				checkChar('}');
//				break;
//				
//			case '[':
//				if (testChar(']'))
//				{
//					value.type_tag = JSON_TYPE.ARRAY;
//					break;
//				}
//				
//				JSONValue[] arr;
//				do
//				{
//					JSONValue element;
//					parseValue(element);
//					arr ~= element;
//				}
//				while (testChar(','));
//				
//				checkChar(']');
//				value.array = arr;
//				break;
//				
//			case '"':
//				auto str = parseString();
//				
//				// if special float parsing is enabled, check if string represents NaN/Inf
//				if ((options & JSONOptions.specialFloatLiterals) &&
//					tryGetSpecialFloat(str, value.store.floating))
//				{
//					// found a special float, its value was placed in value.store.floating
//					value.type_tag = JSON_TYPE.FLOAT;
//					break;
//				}
//				
//				value.type_tag = JSON_TYPE.STRING;
//				value.store.str = str;
//				break;
//				
//			case '0': .. case '9':
//			case '-':
//				auto number = appender!string();
//				bool isFloat, isNegative;
//				
//				void readInteger()
//				{
//					if (!isDigit(c)) error("Digit expected");
//					
//				Next: number.put(c);
//					
//					if (isDigit(peekChar()))
//					{
//						c = getChar();
//						goto Next;
//					}
//				}
//				
//				if (c == '-')
//				{
//					number.put('-');
//					c = getChar();
//					isNegative = true;
//				}
//				
//				readInteger();
//				
//				if (testChar('.'))
//				{
//					isFloat = true;
//					number.put('.');
//					c = getChar();
//					readInteger();
//				}
//				if (testChar!(false, false)('e'))
//				{
//					isFloat = true;
//					number.put('e');
//					if (testChar('+')) number.put('+');
//					else if (testChar('-')) number.put('-');
//					c = getChar();
//					readInteger();
//				}
//				
//				string data = number.data;
//				if (isFloat)
//				{
//					value.type_tag = JSON_TYPE.FLOAT;
//					value.store.floating = parse!double(data);
//				}
//				else
//				{
//					if (isNegative)
//						value.store.integer = parse!long(data);
//					else
//						value.store.uinteger = parse!ulong(data);
//					
//					value.type_tag = !isNegative && value.store.uinteger & (1UL << 63) ?
//						JSON_TYPE.UINTEGER : JSON_TYPE.INTEGER;
//				}
//				break;
//				
//			case 't':
//			case 'T':
//				value.type_tag = JSON_TYPE.TRUE;
//				checkChar!(false, false)('r');
//				checkChar!(false, false)('u');
//				checkChar!(false, false)('e');
//				break;
//				
//			case 'f':
//			case 'F':
//				value.type_tag = JSON_TYPE.FALSE;
//				checkChar!(false, false)('a');
//				checkChar!(false, false)('l');
//				checkChar!(false, false)('s');
//				checkChar!(false, false)('e');
//				break;
//				
//			case 'n':
//			case 'N':
//				value.type_tag = JSON_TYPE.NULL;
//				checkChar!(false, false)('u');
//				checkChar!(false, false)('l');
//				checkChar!(false, false)('l');
//				break;
//				
//			default:
//				error(text("Unexpected character '", c, "'."));
//		}
//		
//		depth--;
//	}
//	
//	parseValue(root);
//	return root;
//}
//
//
///*
//Parses a serialized string and returns a tree of JSON values.
//Throws: $(REF JSONException, std,json) if the depth exceeds the max depth.
//Params:
//    json = json-formatted string to parse
//    options = enable decoding string representations of NaN/Inf as float values
//*/
//JSONValue parseJSON(T)(T json, JSONOptions options)
//	if (isInputRange!T)
//{
//	return parseJSON!T(json, -1, options);
//}
//
//deprecated(
//	"Please use the overload that takes a ref JSONValue rather than a pointer. This overload will "
//	~ "be removed in November 2017.")
//	string toJSON(in JSONValue* root, in bool pretty = false, in JSONOptions options = JSONOptions.none) @safe
//{
//	return toJSON(*root, pretty, options);
//}
//
///**
//Takes a tree of JSON values and returns the serialized string.
//
//Any Object types will be serialized in a key-sorted order.
//
//If $(D pretty) is false no whitespaces are generated.
//If $(D pretty) is true serialized string is formatted to be human-readable.
//Set the $(specialFloatLiterals) flag is set in $(D options) to encode NaN/Infinity as strings.
//*/
//string toJSON(const ref JSONValue root, in bool pretty = false, in JSONOptions options = JSONOptions.none) @safe
//{
//	auto json = appender!string();
//	
//	void toString(string str) @safe
//	{
//		json.put('"');
//		
//		foreach (dchar c; str)
//		{
//			switch (c)
//			{
//				case '"':       json.put("\\\"");       break;
//				case '\\':      json.put("\\\\");       break;
//				case '/':       json.put("\\/");        break;
//				case '\b':      json.put("\\b");        break;
//				case '\f':      json.put("\\f");        break;
//				case '\n':      json.put("\\n");        break;
//				case '\r':      json.put("\\r");        break;
//				case '\t':      json.put("\\t");        break;
//				default:
//					appendJSONChar(json, c, options,
//						(msg) { throw new JSONException(msg); });
//			}
//		}
//		
//		json.put('"');
//	}
//	
//	void toValue(ref in JSONValue value, ulong indentLevel) @safe
//	{
//		void putTabs(ulong additionalIndent = 0)
//		{
//			if (pretty)
//				foreach (i; 0 .. indentLevel + additionalIndent)
//					json.put("    ");
//		}
//		void putEOL()
//		{
//			if (pretty)
//				json.put('\n');
//		}
//		void putCharAndEOL(char ch)
//		{
//			json.put(ch);
//			putEOL();
//		}
//		
//		final switch (value.type)
//		{
//			case JSON_TYPE.OBJECT:
//				auto obj = value.objectNoRef;
//				if (!obj.length)
//				{
//					json.put("{}");
//				}
//				else
//				{
//					putCharAndEOL('{');
//					bool first = true;
//					
//					void emit(R)(R names)
//					{
//						foreach (name; names)
//						{
//							auto member = obj[name];
//							if (!first)
//								putCharAndEOL(',');
//							first = false;
//							putTabs(1);
//							toString(name);
//							json.put(':');
//							if (pretty)
//								json.put(' ');
//							toValue(member, indentLevel + 1);
//						}
//					}
//					
//					import std.algorithm : sort;
//					import std.array;
//					// @@@BUG@@@ 14439
//					// auto names = obj.keys;  // aa.keys can't be called in @safe code
//					auto names = new string[obj.length];
//					size_t i = 0;
//					foreach (k, v; obj)
//					{
//						names[i] = k;
//						i++;
//					}
//					sort(names);
//					emit(names);
//					
//					putEOL();
//					putTabs();
//					json.put('}');
//				}
//				break;
//				
//			case JSON_TYPE.ARRAY:
//				auto arr = value.arrayNoRef;
//				if (arr.empty)
//				{
//					json.put("[]");
//				}
//				else
//				{
//					putCharAndEOL('[');
//					foreach (i, el; arr)
//					{
//						if (i)
//							putCharAndEOL(',');
//						putTabs(1);
//						toValue(el, indentLevel + 1);
//					}
//					putEOL();
//					putTabs();
//					json.put(']');
//				}
//				break;
//				
//			case JSON_TYPE.STRING:
//				toString(value.str);
//				break;
//				
//			case JSON_TYPE.INTEGER:
//				json.put(to!string(value.store.integer));
//				break;
//				
//			case JSON_TYPE.UINTEGER:
//				json.put(to!string(value.store.uinteger));
//				break;
//				
//			case JSON_TYPE.FLOAT:
//				import std.math : isNaN, isInfinity;
//				
//				auto val = value.store.floating;
//				
//				if (val.isNaN)
//				{
//					if (options & JSONOptions.specialFloatLiterals)
//					{
//						toString(JSONFloatLiteral.nan);
//					}
//					else
//					{
//						throw new JSONException(
//							"Cannot encode NaN. Consider passing the specialFloatLiterals flag.");
//					}
//				}
//				else if (val.isInfinity)
//				{
//					if (options & JSONOptions.specialFloatLiterals)
//					{
//						toString((val > 0) ?  JSONFloatLiteral.inf : JSONFloatLiteral.negativeInf);
//					}
//					else
//					{
//						throw new JSONException(
//							"Cannot encode Infinity. Consider passing the specialFloatLiterals flag.");
//					}
//				}
//				else
//				{
//					import std.format : format;
//					// The correct formula for the number of decimal digits needed for lossless round
//					// trips is actually:
//					//     ceil(log(pow(2.0, double.mant_dig - 1)) / log(10.0) + 1) == (double.dig + 2)
//					// Anything less will round off (1 + double.epsilon)
//					json.put("%.18g".format(val));
//				}
//				break;
//				
//			case JSON_TYPE.TRUE:
//				json.put("true");
//				break;
//				
//			case JSON_TYPE.FALSE:
//				json.put("false");
//				break;
//				
//			case JSON_TYPE.NULL:
//				json.put("null");
//				break;
//		}
//	}
//	
//	toValue(root, 0);
//	return json.data;
//}
//
//private void appendJSONChar(ref Appender!string dst, dchar c, JSONOptions opts,
//	scope void delegate(string) error) @safe
//{
//	import std.uni : isControl;
//	
//	with (JSONOptions) if (isControl(c) ||
//		((opts & escapeNonAsciiChars) >= escapeNonAsciiChars && c >= 0x80))
//	{
//		dst.put("\\u");
//		foreach_reverse (i; 0 .. 4)
//		{
//			char ch = (c >>> (4 * i)) & 0x0f;
//			ch += ch < 10 ? '0' : 'A' - 10;
//			dst.put(ch);
//		}
//	}
//	else
//	{
//		dst.put(c);
//	}
//}
//
//
//
///**
//Exception thrown on JSON errors
//*/
//class JSONException : Exception
//{
//	this(string msg, int line = 0, int pos = 0) pure nothrow @safe
//	{
//		if (line)
//			super(text(msg, " (Line ", line, ":", pos, ")"));
//		else
//			super(msg);
//	}
//	
//	this(string msg, string file, size_t line) pure nothrow @safe
//	{
//		super(msg, file, line);
//	}
//}
//
