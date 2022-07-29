Get Started - Documentation
---------------------------

Try out the demo
----------------
If you want to check how it works/looks like, download this project and start the `demo.tscn` scene.
(You can press **F5**, it is the default scene)
The demo scene just has an `IngameConsole` set to Full Rect layout.
You can edit the `test.gd` script, that contains a hello world code to try it out.

Setup GUI
---------
Add an `IngameConsole` node to your scene.
By default the `Generate GUI On Ready` is enabled. This will generate the console content and input for you.

If you want to create your own console, then first you have to disable `Generate GUI On Ready` on your `IngameConsole` node.
Then add a [RichTextLabel][RichTextLabel] named **Content** and a [LineEdit][LineEdit] named **Input** node under it.
Enable the `BBCode > Enabled` property on the [RichTextLabel][RichTextLabel].

> ! The content and input nodes do not have to be direct children of the `IngameConsole` node.

> ! You can change based on what names it should look for the content and input nodes in the IngameConsole node's properties. The default values are **Content** and **Input**.

Code examples
-----
To print out simple information:
```swift
Console.info("Hello world")
```

To print out warning information:
```swift
Console.warning("Might cause issues")
```

To print out error information:
```swift
Console.error("Something really bad happened")
```
> ! `Console.error()` by default pauses the application.

Command line interface
--------
You can also interact with it using the input field (by default positioned on the bottom).
First try typing in the following command, it will print out information about it's usage and the available arguments.
```
help
```

Next type in the following command to print out the available commands.
```
help commands
```

To get more information about a given command type in the following:
```
help command=quit
```

To clear the console, type in the following:
```
clear
```

Lastly, to quit from the application, type in the following:
```
quit
```



[Singleton]: https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html "Singleton (AutoLoad) - Godot Engine Documentation"
[RichTextLabel]: https://docs.godotengine.org/en/stable/classes/class_richtextlabel.html "RichTextLabel - Godot Engine Documentation"
[LineEdit]: https://docs.godotengine.org/en/stable/classes/class_lineedit.html "LineEdit - Godot Engine Documentation"
