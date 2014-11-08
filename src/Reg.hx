package;

import game.Passage;
import haxe.Json;
import openfl.Assets;
import openfl.errors.Error;

class Reg
{

	public static var title:String;
	
	private static var _passages:Array<Passage> = [];

	public static function init():Void
	{
		var passageString:String = Assets.getText("a/info/passages.json");
		var passageJSON:Dynamic = Json.parse(passageString);

		for (i in 0...passageJSON.length)
		{
			if (i == 0)
				title = passageJSON[i].title;
			var p:Passage = new Passage();
			p.id = passageJSON[i].id;
			p.text = passageJSON[i].text;
			p.htmlText = passageJSON[i].htmlText;

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