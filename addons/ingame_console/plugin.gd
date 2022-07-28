tool
extends EditorPlugin


func _enter_tree():
	add_custom_type(
		"DebugConsole", "Control",
		preload("res://addons/ingame_console/scripts/console_gui.gd"),
		preload("res://addons/ingame_console/images/console_icon.svg")
	)


func _exit_tree():
	remove_custom_type("DebugConsole")
