extends Control


##############
# Properties #
##############

export var generate_gui_on_ready := true
export var console_content_node_name := "Content"
export var console_input_node_name := "Input"

var console_content: RichTextLabel
var console_input: LineEdit
var dummy_bbcode_parser: RichTextLabel

var _is_newline := false


############################
# Default method overrides #
############################

func _ready() -> void:
	add_to_group("DebugConsole")

	if generate_gui_on_ready:
		generate_gui()
	else:
		console_content = find_node(console_content_node_name, true, false)
		console_input = find_node(console_input_node_name, true, false)
	
	generate_dummy_parser()

	assert(console_content, "No content named %s found for console" % console_content_node_name)

	setup_events()



#################
# Event methods #
#################

func _on_text_entered(text: String) -> void:
	if text.empty():
		return
	
	console_input.clear()
	write_line("> %s" % text)
	Console.process_command(text)


###########
# Methods #
###########

func write(text: String, is_logging: bool = true, level: String = "") -> void:
	var output := ""
	
	if is_logging:
		dummy_bbcode_parser.parse_bbcode(text)
		if level == "warning":
			push_warning(dummy_bbcode_parser.text)
		elif level == "error":
			if Console.pause_on_error:
				assert(false, dummy_bbcode_parser.text)
			else:
				push_error(dummy_bbcode_parser.text)
		else:
			print(dummy_bbcode_parser.text)
	
	if _is_newline:
		output += "\n"
		_is_newline = false
	
	output += text
	
	console_content.bbcode_text += output


func write_line(text: String, is_logging: bool = true, level: String = "") -> void:
	write(text, is_logging, level)
	_is_newline = true


func clear() -> void:
	console_content.bbcode_text = ""
	_is_newline = false


#####################
# GUI setup methods #
#####################

func setup_events() -> void:
	if console_input:
		console_input.connect("text_entered", self, "_on_text_entered")


func generate_gui() -> void:
	var background = Panel.new()
	background.name = "Background"
	background.anchor_right = 1
	background.anchor_bottom = 1
	add_child(background)
	
	var container = VBoxContainer.new()
	container.name = "Container"
	container.anchor_right = 1
	container.anchor_bottom = 1
	background.add_child(container)
	
	console_content = RichTextLabel.new()
	console_content.name = console_content_node_name
	console_content.bbcode_enabled = true
	console_content.scroll_following = true
	console_content.size_flags_horizontal = SIZE_FILL + SIZE_EXPAND
	console_content.size_flags_vertical = SIZE_FILL + SIZE_EXPAND
	container.add_child(console_content)

	console_input = LineEdit.new()
	console_input.name = console_input_node_name
	console_input.size_flags_horizontal = SIZE_FILL + SIZE_EXPAND
	container.add_child(console_input)


func generate_dummy_parser() -> void:
	dummy_bbcode_parser = RichTextLabel.new()
	dummy_bbcode_parser.name = "DummyBBCodeParser"
	dummy_bbcode_parser.visible = false
	
	# Adding it to the scene, so it does not appear as an orphan node
	add_child(dummy_bbcode_parser)
