class_name Command
extends Object


##############
# Properties #
##############


var id: String
var function: FuncRef
var arguments: Array
var short_description: String
var long_description: String


func _init(id: String, function: FuncRef, arguments: Array = [], short_description: String = "", long_description: String = "") -> void:
	self.id = id
	self.function = function
	self.arguments = arguments
	self.short_description = short_description
	self.long_description = long_description


func run(command_string: String) -> Dictionary:
	var parsed_args := parse_string_args(command_string)
	var messages = validate(parsed_args)
	
	if not messages.empty():
		return messages
	
	function.call_funcv([parsed_args])
	return {}


func parse_string_args(text: String) -> Dictionary:
	var args = {}
	
	text = text.lstrip(id)
	
	var state := "Searching Key"
	var current_key := ""
	var is_string_value := false
	var current_value := ""
	
	var i := 0
	while i < text.length():
		var c = text[i]
		match state:
			"Searching Key":
				if c != " ":
					i -= 1
					state = "Building Key"
		
			"Building Key":
				if text.substr(i, 1) == "=":
					state = "Building Value"
					if text.substr(i, 2) == "=\"":
						i += 1
						is_string_value = true
				elif text.substr(i, 1) == " ":
					args[current_key] = ""
					current_key = ""
					state = "Searching Key"
				elif i == text.length() - 1:
					current_key += c
					args[current_key] = ""
				else:
					current_key += c
		
			"Building Value":
				if (is_string_value and c == "\"") or (not is_string_value and c == " ") or (i == text.length() - 1):
					if i == text.length() - 1 and c != "\"":
						current_value += c
					args[current_key] = current_value
					current_key = ""
					current_value = ""
					is_string_value = false
					state = "Searching Key"
				else:
					current_value += c
		
		i += 1
	
	return args

func validate(passed_args: Dictionary) -> Dictionary:
	var messages = {}
	for passed_arg_key in passed_args:
		var argument = get_argument(passed_arg_key)
		if not argument:
			continue
		var validator_messages = argument.validate(passed_args[passed_arg_key])
		if not validator_messages.empty():
			messages[passed_arg_key] = validator_messages
	
	return messages


func add_argument(argument: Arg) -> void:
	if argument.id in arguments:
		return
	
	arguments.push_back(argument)


func get_argument(id: String) -> Arg:
	for argument in arguments:
		if argument.id == id:
			return argument
	
	return null
