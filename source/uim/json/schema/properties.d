module uim.json.schema.properties;

import uim.json;

class JsonProperties { // : Map!(string, SchemaProperty) { 
	this() {}

	string[] keys;
	string[string] values;

	string opIndex(string name) {
		if (name in values) return values[name]; return null;
	}
	O opIndexAssign(this O)(string value, string name) {
		if (name in values) values[name] = value; 
		else {
			keys ~= name;
			values[name] = value;
		}
		return cast(O)this;
	}
	O remove(this O)(string key) {
		if (name in values) {
			values.remove(key);
			string[] newKeys;
			foreach(k; keys) if (k == key) newKeys ~= k;
			keys = newKeys;
		}
		return cast(O)this;
	}

//	string toJSN() {
//		string[] props;
//		foreach(k; keys) {
//
//		}
//	}
}

