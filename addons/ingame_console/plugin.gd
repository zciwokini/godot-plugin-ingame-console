tool
extends EditorPlugin


func _enter_tree():
	add_custom_type(
		"IngameConsole", "Control",
		preload("res://addons/ingame_console/scripts/console_gui.gd"),
		preload("res://addons/ingame_console/images/console_icon.svg")
	)
	add_autoload_singleton("Console", "res://addons/ingame_console/scripts/console_global.gd")


func _exit_tree():
	remove_custom_type("IngameConsole")
	remove_autoload_singleton("Console")
