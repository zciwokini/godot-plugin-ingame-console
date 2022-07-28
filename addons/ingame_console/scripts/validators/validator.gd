extends Object
class_name IValidator


var validation
var message


func _init(validation, message) -> void:
	self.validation = validation
	self.message = message


func validate(value) -> bool:
	return true
