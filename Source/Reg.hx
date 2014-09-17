package;

import game.Passage;
import haxe.Json;
import openfl.Assets;
import openfl.errors.Error;

class Reg
{
	public static inline var GET_PASSAGE:Int = 1;
	public static inline var MODIFY_VARIABLE:Int = 2;
	public static inline var PLAY_SOUND:Int = 3;
	public static inline var STOP_CHANNEL:Int = 4;
	public static inline var MODIFY_CHANNEL:Int = 5;

	private static var _passages:Array<Passage> = [];

	public static function init():Void
	{
		var passageString:String = Assets.getText("a/info/passages.json");
		var passageJSON:Dynamic = Json.parse(passageString);

		for (i in 0...passageJSON.passages.length)
		{
			var p:Passage = new Passage();
			p.id = passageJSON.passages[i].id;
			p.title = passageJSON.passages[i].title;
			p.text = passageJSON.passages[i].text;
			p.backImage = passageJSON.passages[i].backImage;
			p.character = passageJSON.passages[i].character;

			_passages.push(p);
		}
	}

	public static function getPassage(id:Int):Passage
	{
		for (i in 0..._passages.length) if (_passages[i].id == id) return _passages[i];
		
		throw new Error("Passage " + id + " doesn't exist");

		return new Passage();
	}
}