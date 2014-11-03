StoryDev-Engine
===============
This is going to be an interactive story engine, written in Haxe on the OpenFL framework. It is designed to make writing interactive stories easier in a user-friendly way for both the author and the programmer. The engine part of this product is almost done; all that needs to be done is corrections with custom links and it will be optimised for Flash and C++ targets (the main aim of this project).

In addition, there will also be an editor. The editor is going to be designed for both the author and the programmer in mind; it will provide tools for the programmer to write code and express it in a way that is easy to read and use the in-built functions this engine comes with; in addition, it will also provide WYSIWYG interfaces for authors who do not know how to code to easily write stories without the hassle of coding.

If you wish to contribute to this project, please fork and add new features or you can complete some tasks on our TODO list below. When requesting a Pull, please make a link to a working copy of your part of the contribution so that it can be easily merged with the master branch without hassle to other coders. If it is a work-in-progress copy, make a pull request to the Dev branch, where most of the work-in-progress content resides.

TODO
====
* General code cleanup
* Add functionality for adding Bitmap images at any particular location and size, also allowing for events such as onClick, onMouseDown, onMouseUp, etc. to be called via Game Events.
* Add functionality for a selectable TextField that can be edited with the ability to call short-hand functions. For example, "-p 1" could be the shorthand version for "gotoPassage(1);". In addition, functions may be added/removed at the developer's leisure. This would use a separate JSON file, maybe "console.json"?
* Add more formatting options: Underline, Bulleted List, Size, Numbered List, maybe others?

EDITOR
======
The editor is going to be a separate project entirely, mainly so that game developers/writers can have the freedom to redistribute this source code and any compiled versions without also redistributing the editor as well.

CREDITS
=======
This engine uses the Open Sans font, using the [Apache License v2.0](http://www.apache.org/licenses/LICENSE-2.0.html), which means you can redistribute a copy of this engine as long as you make credit to the usage of this font. You may also compile this engine into bytecode or binary format, and if necessary, you may need to make a reference to the license of this font, or any other font you decide to use otherwise.

If you wish, you can copy the following text into a TXT file (replacing anything in square brackets where necessary):
`This game uses the Open Sans font, using the Apache License v2.0 found here: http://www.apache.org/licenses/LICENSE-2.0.html. This game does not use any other fonts than those otherwise noted in this document, and have the permission by all given licenses to redistribute this game for [commercial/non-commercial] purposes.`

Special Thanks to [Player-03](https://github.com/player-03) for his [Markdown Parser](https://github.com/player-03/MarkdownParser) which has helped solve the consist issues this project had with parsing and applying formatting to text and links.

Thank you [MintPaw](https://github.com/MintPaw) for his help starting the project.
