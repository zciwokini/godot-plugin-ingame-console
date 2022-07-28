extends Node


##############
# Constants #
##############

const LEVEL_WARNING := "warning"
const LEVEL_ERROR := "error"


##############
# Properties #
##############

var is_logging := true
var pause_on_error := false
var log_format := "{date} {time} [color={category_color}]{category_name}[/color] {text}"
var log_categories := {}

var commands := {}
var command_ids := []


func _ready() -> void:
	add_category("info")
	add_category("warning", "WARNING", "#fa0")
	add_category("error", "ERROR", "#f00")
	
	add_command(Command.new("clear", funcref(self, "clear_console"), [], """Clears the console."""))
	add_command(
		Command.new(
			"quit",
			funcref(get_tree(), "quit"),
			[
				Arg.new(
					"code",
					[
						RegexValidator.new("\\d", "The value must be a number")
					],
					"""Exit code to return with."""
				)
			],
			"""Terminates the application."""
		)
	)
	add_command(
		Command.new(
			# Command's name(id)
			"help",
			# Command's function(callback)
			funcref(self, "help"),
			# Command's arguments
			[
				Arg.new(
					# Argument's name(id)
					"command",
					# Argument's validators
					[
						StringsValidator.new(command_ids, """[u]{value}[/u] is not an existing command.""")
					],
					# Argument's short description
					"""Lists information about a given command and it's usage. I.e.: [u]help command=clear[/u]"""
				),
				Arg.new(
					"commands",
					[],
					"""Lists out the available commands"""
				),
			],
			# Command's short description
			"""Lists out useful information about the usage of the console.""",
			# Command's long description
			"""Pass in one of the following arguments after the help command to get info about a specific topic.
For example, type: [u]help commands[/u] to list all the available commands."""
		)
	)


####################
# Category methods #
####################

func add_category(id: String, name: String = "", color = "") -> void:
	if name == "":
		name = id.to_upper()
	
	log_categories[id] = {
		"category_name": name,
		"category_color": color
	}


func remove_category(id: String) -> void:
	log_categories.erase(id)


###################
# Command methods #
###################

func add_command(command: Command) -> void:
	commands[command.id] = command
	command_ids.push_back(command.id)


func remove_command(id: String) -> void:
	commands.erase(id)
	command_ids.remove(command_ids.find(id))


func process_command(text: String):
	var command_root: String = text.split(" ", false, 1)[0]
	if not command_root in commands:
		warning("Unknown command: %s\n" % command_root)
		return
	
	var command: Command = commands[command_root]
	var args: Dictionary = {}
	
	var messages = command.run(text)
	for arg in messages:
		warning("Validation error(s) for [u]%s[/u] argument:" % arg)
		for message in messages[arg]:
			write_line("[indent]%s[/indent]" % message)
	
	write_line("")


####################
# Printing methods #
####################

func log(category_id: String, text, level: String = "") -> void:
	if not category_id in log_categories:
		warning("Passed category ID(%s) does not exist" % category_id)
		return
	
	var format_values := {
		"text": text,
		"date": Time.get_date_string_from_system(),
		"time": Time.get_time_string_from_system()
	}
	format_values.merge(log_categories[category_id])
	
	write_line(log_format.format(format_values), level)


func info(text) -> void:
	self.log("info", text)


func warning(text) -> void:
	self.log("warning", text, LEVEL_WARNING)


func error(text) -> void:
	self.log("error", text, LEVEL_ERROR)


func write(text, level: String = "") -> void:
	get_tree().call_group(
		"DebugConsole", "write",
		text,
		is_logging,
		level
	)


func write_line(text, level: String = "") -> void:
	get_tree().call_group(
		"DebugConsole", "write_line",
		text,
		is_logging,
		level
	)


##########################
# Helper command methods #
##########################

func help(args):
	if "commands" in args:
		list_commands()
	elif "command" in args:
		list_command_info(args["command"])
	else:
		list_command_info("help")


func list_commands():
	var table = "[indent][table=2]"
	command_ids.sort()
	for command_id in command_ids:
		var command: Command = commands[command_id]
		table += "[cell]%s[/cell][cell]%s[/cell]\n" % [command.id, command.short_description]
	table += "[/table][/indent]"
	write_line(table)


func list_command_info(command_id):
	if not command_id in commands:
		return
	
	var command: Command = commands[command_id]
	
	write_line("\nInformation about the following command: [u]%s[/u]\n" % command_id)
	
	write_line("[fill]%s[/fill]\n" % command.short_description)
	
	if command.long_description:
		write_line("Description:")
		write_line("[indent][fill]%s[/fill][/indent]\n" % command.long_description)
	
	if not command.arguments.empty():
		write("Argument(s):")
		var table = "[indent][table=2]"
		for argument in command.arguments:
			table += "[cell]%s[/cell][cell]%s[/cell]" % [argument.id, argument.description]
		table += "[/table][/indent]"
		write_line(table)


func clear_console(args):
	get_tree().call_group("DebugConsole", "clear")
