package;

import game.Passage;
import haxe.Json;
import openfl.Assets;
import openfl.errors.Error;
import game.GameEvent;

class Reg
{

	public static var title:String;

	private static var _passages:Array<Passage> = [];

	public static function init():Void
	{
		var passageString:String = Assets.getText("a/info/passages.json");
		var passageJSON:Dynamic = Json.parse(passageString);

		title = passageJSON.title.split(" ").join("");

		for (i in 0...passageJSON.passages.length)
		{
			var p:Passage = new Passage();
			p.id = passageJSON.passages[i].id;
			p.title = passageJSON.passages[i].title;
			p.text = passageJSON.passages[i].text;

			_passages.push(p);
		}
		
	}

	public static function getPassage(id:Int):Passage
	{
		for (i in 0..._passages.length) if (_passages[i].id == id) return _passages[i];
		
		throw new Error("Passage " + id + " does not exist");

		return new Passage();
	}

	
}