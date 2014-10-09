package game;

import haxe.Json;
import openfl.Assets;

/**
 * ...
 * @author Colour Multimedia Enterprises
 */
class GameEvent
{
	
	public static var gameEvents:Array<GameEvent> = [];
	public static var queuedEvents:Array<GameEvent> = [];
	
	public var id:Int;
	public var code:String;

	public function new() 
	{
		
	}
	
	public static function initEvents():Void 
	{
		var eventsString:Dynamic = Json.parse(Assets.getText("a/info/events.json"));
		for (i in 0...eventsString.events.length) 
		{
			var event:GameEvent = new GameEvent();
			event.id = eventsString.events[i].id;
			event.code = eventsString.events[i].code;
			gameEvents.push(event);
		}
	}
	
	public static function startEvent(id:Int):Void
	{
		for (i in 0...gameEvents.length) 
		{
			if (gameEvents[i].id == id) 
			{
				queuedEvents.push(gameEvents[i]);
				break;
			}
		}
	}
	
	public static function stopEvent(id:Int):Void 
	{
		for (i in 0...queuedEvents.length) 
		{
			if (queuedEvents[i].id == id) 
			{
				queuedEvents.splice(queuedEvents.indexOf(queuedEvents[i]), 1);
				break;
			}
		}
	}

}