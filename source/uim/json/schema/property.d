module uim.json.schema.property;

import uim.json;

class SchemaProperty {
	this() {}

	mixin(TProperty!("string", "name"));
	mixin(TProperty!("PrimitiveTypes", "type", ));

	mixin(TProperty!("string", "description"));
	mixin(TProperty!("string", "minimum", ));
}

