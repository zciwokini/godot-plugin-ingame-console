extends IValidator
class_name StringValidator


func _init(v, m).(v, m) -> void:
	pass


func validate(value) -> bool:
	return value.match(validation)
