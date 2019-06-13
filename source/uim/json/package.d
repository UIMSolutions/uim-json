module uim.json;

/++ 
 The file type for JSON files is ".json"
 The MIME type for JSON text is "application/json"
 +/
import std.stdio;
import std.string;

public import uim.core;
public import uim.oop;

public import uim.json.data;

public import uim.json.value;
public import uim.json.number;
public import uim.json.object_;
public import uim.json.string_;
public import uim.json.array_;
public import uim.json.boolean;
public import uim.json.null_;

public import uim.json.schema;

size_t positionOfString(string text, string searchString, bool strict) { return positionOfString(text, searchString, 0, strict); }
size_t positionOfString(string text, string searchString, size_t start = 0, bool strict = false) {
	if (text.empty) return -1;	
	auto subString = text[start..$];
	if (subString.empty) return -1;	
	if (searchString.empty) return -1;	

	auto pos = subString.indexOf(searchString);
	if (pos == -1) return -1;	
	if (pos == 0) return start;

	if (strict) {
		if (subString[pos-1] == '\\') pos = subString.positionOfString(searchString, pos+1, strict);
	}
	if (pos == -1) return -1;	

	return pos+start;
}
size_t[] positionsOfString(string text, string searchString, bool strict = false) { return positionsOfString(text, searchString, 0, strict); }
size_t[] positionsOfString(string text, string searchString, size_t start = 0, bool strict = false) {
	size_t[] positions;
	size_t lastPos = -1;
	do {
		lastPos = text.positionOfString(searchString, lastPos+1, strict);
		if (lastPos != -1) positions ~= lastPos;
	} while(lastPos != -1);

	return positions;
}

size_t[][string] positionsOfStrings(string text, string[] searchStrings, bool strict = false) { return positionsOfStrings(text, searchStrings, 0, strict); }
size_t[][string] positionsOfStrings(string text, string[] searchStrings, size_t start = 0, bool strict = false) {
	size_t[][string] positions;
	foreach(str; searchStrings) positions[str] = text.positionsOfString(str, start, strict);
	return positions;
}

size_t[] positionOfStrings(string text, string[] searchStrings, bool strict = false) { return positionOfStrings(text, searchStrings, 0, strict); }
size_t[] positionOfStrings(string text, string[] searchStrings, size_t start = 0, bool strict = false) {
	size_t[] positions;
	foreach(str; searchStrings) positions ~= text.positionOfString(str, start, strict);
	return positions;
}

bool stringExists(string text, string searchString, bool strict = false) {
	auto pos = text.indexOf(searchString);
	if (pos == -1) return false;

	if (pos == 0) return true;
	if (strict) while ((text[pos-1] == '\\') && (pos != -1)) {
		pos = text.indexOf(searchString, pos+1);
	}
	if (pos == -1) return false;
	return true;
}
string subStringBetweenStrings(string text, string leftString, string rightString, bool strict = false) {
	if (text.empty) return null;
	if (leftString.empty) return null;
	if (rightString.empty) return null;

	auto leftPos = text.positionOfString(leftString, 0, strict);
	if (leftPos == -1) return null;

	auto rightPos = text.positionOfString(rightString, leftPos+1, strict);
	if (rightPos == -1) return null;

	return text[leftPos+1..rightPos];
}
string readNextFieldName(string jsonText, bool strict = false) {
	return jsonText.subStringBetweenStrings("\"", "\"", strict);
}

class JSON {
	static DJSONValue fromText(string text) {
		DJSONValue result;
		
		if (auto txt = strip(text)) {
			switch (txt[0]) {
				case '{': return JSONObject(text);
				case '[': return JSONArray(text);
				default: writeln("Wrong character: ", txt[0]);
			}
		}
		return null; 
	}
	
	this() {}
}

Json toJson(Json json, string[] props) {
	Json result = Json.emptyObject;
	foreach(prop; props) {
		if (prop in json) result[prop] = json["prop"];
	}
	return result;
}

unittest {
	import std.stdio;

	writeln("Loading uim.json...");
}


