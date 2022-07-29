extends IValidator
class_name StringsValidator


func _init(v, m).(v, m) -> void:
	pass


func validate(value) -> bool:
	for v in self.validation:
		if value.match(v):
			return true
	
	return false
