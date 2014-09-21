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
	public var title:String;
	public var triggerState:String;
	
	
	public static function initEvents() {
		var eventsString:String = Assets.getText("a/info/events.json");
		var eventsJSON:Dynamic = Json.parse(eventsString);

		for (i in 0...eventsJSON.events.length) {
			var e:GameEvent = new GameEvent();
			e.id = eventsJSON.events[i].id;
			e.title = eventsJSON.events[i].title;
			e.triggerState = eventsJSON.events[i].triggerState;
			
			gameEvents.push(e);
		}
	}
		
	public static function startEvent(id:Int):Void {
		for (i in 0...gameEvents.length) if (gameEvents[i].id == id) queuedEvents.push(gameEvents[i]);
		
		trace("Game Event " + id + " does not exist");
	}
	
	public static function stopEvent(id:Int):Void {
		for (i in 0...queuedEvents.length) if (queuedEvents[i].id == id) queuedEvents.splice(i, 1);

		trace("Game Event " + id + "has already been stopped.");
	}
	
	
	
}