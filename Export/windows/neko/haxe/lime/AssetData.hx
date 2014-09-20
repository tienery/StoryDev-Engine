package lime;


import lime.utils.Assets;


class AssetData {

	private static var initialized:Bool = false;
	
	public static var library = new #if haxe3 Map <String, #else Hash <#end LibraryType> ();
	public static var path = new #if haxe3 Map <String, #else Hash <#end String> ();
	public static var type = new #if haxe3 Map <String, #else Hash <#end AssetType> ();	
	
	public static function initialize():Void {
		
		if (!initialized) {
			
			path.set ("a/font/main.ttf", "a/font/main.ttf");
			type.set ("a/font/main.ttf", Reflect.field (AssetType, "font".toUpperCase ()));
			path.set ("a/img/bg0.png", "a/img/bg0.png");
			type.set ("a/img/bg0.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("a/img/char0.png", "a/img/char0.png");
			type.set ("a/img/char0.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("a/info/commands.txt", "a/info/commands.txt");
			type.set ("a/info/commands.txt", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("a/info/passages.json", "a/info/passages.json");
			type.set ("a/info/passages.json", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("a/sound/test.mp3", "a/sound/test.mp3");
			type.set ("a/sound/test.mp3", Reflect.field (AssetType, "music".toUpperCase ()));
			path.set ("main", "Assets/font/main.ttf");
			type.set ("main", Reflect.field (AssetType, "font".toUpperCase ()));
			
			
			initialized = true;
			
		} //!initialized
		
	} //initialize
	
	
} //AssetData
