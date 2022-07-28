extends IValidator
class_name RegexValidator


func _init(v, m).(v, m) -> void:
	pass


func validate(value) -> bool:
	var regex := RegEx.new()
	regex.compile(self.validation)
	return regex.search(value) != null
