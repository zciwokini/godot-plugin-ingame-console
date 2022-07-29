extends Control


#############
# Constants #
#############

onready var CONSOLE_GLOBAL_SCRIPT = preload("res://addons/ingame_console/scripts/console_global.gd")
var CONSOLE_GLOBAL


##############
# Properties #
##############

export var generate_gui_on_ready := true
export var console_content_node_name := "Content"
export var console_input_node_name := "Input"

onready var console_content: RichTextLabel = find_node(console_content_node_name, true, false)
onready var console_input: LineEdit = find_node(console_input_node_name, true, false)
onready var dummy_parser := RichTextLabel.new()

var _is_newline := false


############################
# Default method overrides #
############################

func _ready() -> void:
	add_to_group("DebugConsole")
	
	for node in get_tree().root.get_children():
		if node.get_script() == CONSOLE_GLOBAL_SCRIPT:
			CONSOLE_GLOBAL = node
	
	if generate_gui_on_ready:
		generate_gui()
	
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
	CONSOLE_GLOBAL.process_command(text)


###########
# Methods #
###########

func write(text: String, is_logging: bool = true, level: String = "") -> void:
	var output := ""
	
	if is_logging:
		dummy_parser.parse_bbcode(text)
		if level == "warning":
			push_warning(dummy_parser.text)
		elif level == "error":
			if CONSOLE_GLOBAL.pause_on_error:
				assert(false, dummy_parser.text)
			else:
				push_error(dummy_parser.text)
		else:
			print(dummy_parser.text)
	
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
	console_content = RichTextLabel.new();
	console_content.bbcode_enabled = true
	console_content.scroll_following = true
	console_content.size_flags_horizontal = SIZE_FILL + SIZE_EXPAND
	console_content.size_flags_vertical = SIZE_FILL + SIZE_EXPAND
	console_content.name = console_content_node_name
	
	console_input = LineEdit.new();
	console_input.name = console_input_node_name
	console_input.size_flags_horizontal = SIZE_FILL + SIZE_EXPAND
	
	var container = VBoxContainer.new()
	container.anchor_right = 1
	container.anchor_bottom = 1
	container.add_child(console_content)
	container.add_child(console_input)
	
	var background = Panel.new()
	background.anchor_right = 1
	background.anchor_bottom = 1
	background.add_child(container)
	
	add_child(background)
