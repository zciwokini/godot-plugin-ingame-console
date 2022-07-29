extends IValidator
class_name FunctionValidator


func _init(v, m).(v, m) -> void:
	pass


func validate(value) -> bool:
	return self.validation.call_funcv([value])
