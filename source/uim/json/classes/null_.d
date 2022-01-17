module uim.json.classes.null_;

import uim.json;

class DJSNNull : DJSNValue {
	@property override size_t length() { return 1; }

	override DJSNNull dup() { return JSNNull(); }
	override string toString() {
		return "null";
	}
}
auto JSNNull() { return new DJSNNull(); }

