module uim.json.null_;

import uim.json;

class DJSONNull : DJSONValue {
	@property override size_t length() { return 1; }

	override DJSONNull dup() { return JSONNull(); }
	override string toString() {
		return "null";
	}
}
auto JSONNull() { return new DJSONNull(); }

