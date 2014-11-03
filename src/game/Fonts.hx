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
	private static var _defaultFont(get, null):Font;
	private static var _boldFont(get, null):Font;
	private static var _boldItalicFont(get, null):Font;
	private static var _italicFont(get, null):Font;

	private static function get__defaultFont()
	{
		if (_defaultFont == null)
			_defaultFont = Assets.getFont("a/font/main.ttf");
			
		return _defaultFont;
	}
	
	private static function get__boldFont()
	{
		if (_boldFont == null)
			_boldFont = Assets.getFont("a/font/main-bold.ttf");
			
		return _boldFont;
	}
	
	private static function get__boldItalicFont()
	{
		if (_boldItalicFont == null)
			_boldItalicFont = Assets.getFont("a/font/main-bolditalic.ttf");
			
		return _boldItalicFont;
	}
	
	private static function get__italicFont()
	{
		if (_italicFont == null)
			_italicFont = Assets.getFont("a/font/main-bolditalic.ttf");
			
		return _italicFont;
	}
	
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
	
	public static function GetFormatName(title:String):String
	{
		var name = "";
		switch(title)
		{
			case "main": name = _defaultFont.fontName;
			case "main-bold": name = _boldFont.fontName;
			case "main-italic": name = _italicFont.fontName;
			case "main-bolditalic": name = _boldItalicFont.fontName;
		}
		return name;
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
	#elseif sys
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
	
	public static function AddFormat(type:String, format:TextFormat, ?value:Dynamic):TextFormat
	{
		switch (type)
		{
			case "bold": format.bold = true;
			case "italic": format.italic = true;
			case "underline": format.underline = true;
			case "color": format.color = value;
		}
		return format;
	}
	
	public static function RemoveFormat(type:String, format:TextFormat, ?value:Dynamic):TextFormat
	{
		switch (type)
		{
			case "bold": format.bold = false;
			case "italic": format.italic = false;
			case "underline": format.underline = false;
			case "color": format.color = 0x000000;
		}
		return format;
	}
	
}