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
	public static var _gameEvents:Array<GameEvent> = [];
	public static var _queuedEvents:Array<GameEvent> = [];

	public static function init():Void
	{
		var passageString:String = Assets.getText("a/info/passages.json");
		var passageJSON:Dynamic = Json.parse(passageString);
		var eventsString:String = Assets.getText("a/info/events.json");
		var eventsJSON:Dynamic = Json.parse(eventsString);

		title = passageJSON.title.split(" ").join("");

		for (i in 0...passageJSON.passages.length)
		{
			var p:Passage = new Passage();
			p.id = passageJSON.passages[i].id;
			p.title = passageJSON.passages[i].title;
			p.text = passageJSON.passages[i].text;

			_passages.push(p);
		}
		for (i in 0...eventsJSON.events.length) {
			var e:GameEvent = new GameEvent();
			e.id = eventsJSON.events[i].id;
			e.title = eventsJSON.events[i].title;
			e.triggerState = eventsJSON.events[i].triggerState;
			
			_gameEvents.push(e);
		}
	}

	public static function getPassage(id:Int):Passage
	{
		for (i in 0..._passages.length) if (_passages[i].id == id) return _passages[i];
		
		throw new Error("Passage " + id + " does not exist");

		return new Passage();
	}
	
	public static function startEvent(id:Int):Void {
		for (i in 0..._gameEvents.length) if (_gameEvents[i].id == id) _queuedEvents.push(_gameEvents[i]);
		
		throw new Error("Game Event " + id + " does not exist");
	}
	
	public static function stopEvent(id:Int):Void {
		for (i in 0..._queuedEvents.length) if (_queuedEvents[i].id == id) _queuedEvents.slice(_queuedEvents[i], 1);
		
		throw new Error("Game Event " + id + "has already been stopped.");
	}
	
}