extends Object
class_name Arg


var id: String
var validators: Array
var description: String


func _init(id: String, validators: Array = [], description: String = "") -> void:
	self.id = id
	self.validators = validators
	self.description = description


func validate(value) -> Array:
	var messages = []
	for validator in validators:
		if not validator.validate(value):
			messages.push_back(validator.message.format({"value": value}))
	
	return messages
