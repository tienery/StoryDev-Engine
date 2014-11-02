package game;

import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.text.Font;
import openfl.Assets;

#if js
@:font("a/font/main.ttf") class DefaultFont extends Font { }
@:font("a/font/main-bold.ttf") class BoldFont extends Font { }
@:font("a/font/main-bolditalic.ttf") class BoldItalicFont extends Font { }
@:font("a/font/main-italic.ttf") class ItalicFont extends Font { }
#end

class Fonts
{
	private static var _defaultFont:Font = Assets.getFont("a/font/main.ttf");
	private static var _boldFont:Font = Assets.getFont("a/font/main-bold.ttf");
	private static var _boldItalicFont:Font = Assets.getFont("a/font/main-bolditalic.ttf");
	private static var _italicFont:Font = Assets.getFont("a/font/main-italic.ttf");

	public function new() 
	{
		
	}
	
	public static function RegisterFonts():Void
	{
		#if js
		Font.registerFont(DefaultFont);
		Font.registerFont(BoldFont);
		Font.registerFont(BoldItalicFont);
		Font.registerFont(ItalicFont);
		#end
	}
	
	#if flash
	public static function GetFormat(?title:String, ?size:Float, ?color:UInt, ?underline:Bool, ?align:TextFormatAlign):TextFormat
	{
		var format:TextFormat = null;
		switch(title) 
		{
			case "main":
				format = new TextFormat(_defaultFont.fontName, size, color, null, null, underline, null, null, align);
			case "main-bold":
				format = new TextFormat(_boldFont.fontName, size, color, null, null, underline, null, null, align);
			case "main-bolditalic":
				format = new TextFormat(_boldItalicFont.fontName, size, color, null, null, underline, null, null, align);
			case "main-italic":
				format = new TextFormat(_italicFont.fontName, size, color, null, null, underline, null, null, align);
		}
		return format;
	}
	#else if windows | linux | mac
	public static function GetFormat(?title:String, ?size:Float, ?color:UInt, ?underline:Bool, ?align:String):TextFormat
	{
		var format:TextFormat = null;
		switch(title) 
		{
			case "main":
				format = new TextFormat(_defaultFont.fontName, size, color, null, null, underline, null, null, align);
			case "main-bold":
				format = new TextFormat(_boldFont.fontName, size, color, null, null, underline, null, null, align);
			case "main-bolditalic":
				format = new TextFormat(_boldItalicFont.fontName, size, color, null, null, underline, null, null, align);
			case "main-italic":
				format = new TextFormat(_italicFont.fontName, size, color, null, null, underline, null, null, align);
		}
		return format;
	}
	#else if js
	public static function GetFormat(?title:String, ?size:Float, ?color:UInt, ?underline:Bool, ?align:TextFormatAlign):TextFormat
	{
		var format:TextFormat = null;
		format = new TextFormat(title, size, color, null, null, underline, null, null, align);
		return format;
	}
	#end
	
}