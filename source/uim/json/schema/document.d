module uim.json.schema.document;

import uim.json;

class JsonSchema {
	this() {}

	mixin(TProperty!("string", "schema"));
	mixin(TProperty!("string", "id"));
	mixin(TProperty!("string", "title"));
	mixin(TProperty!("PrimitiveTypes", "type"));
	mixin(TProperty!("string", "description"));
	mixin(TProperty!("string[]", "required"));
	mixin(TProperty!("JsonProperties", "properties"));

	override string toString() {
		string[] results;

		if (schema) results ~= `"$schema": "%s"`.format(schema);
		if (id) results ~= `"id": "%s"`.format(id);
		if (title) results ~= `"title": "%s"`.format(title);
		if (type) results ~= `"type": "%s"`.format(cast(string)type);
		if (description) results ~= `"description": "%s"`.format(description);
		if (required) results ~= `"required": "%s"`.format(required);
		if (properties) results ~= `"properties": %s`.format(properties);
		return "{ %s }".format(results.join(",\n"));
	}
}
auto JSONSCHEMA() { return new JsonSchema; }

unittest {
	writeln(JSONSCHEMA
		.schema("http://json-schema.org/draft-04/schema#")
		.title("Person")
		.type(PrimitiveTypes.OBJECT)
		.description("A representation of a person")
		.required(["familyName", "givenName"])
		);
}
