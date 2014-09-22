package game;

import openfl.Assets;
import openfl.errors.Error;
import haxe.Json;

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
	
	public function new() {
		
	}
	
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
		for (i in gameEvents) if (i.id == id) queuedEvents.push(i);
		else trace("Game Event " + id + " does not exist");
	}
	
	public static function stopEvent(id:Int):Void {
		for (i in queuedEvents) if (i.id == id) queuedEvents.splice(queuedEvents.indexOf(i), 1);
		else trace("Game Event " + id + "has already been stopped.");
	}
	
	
	
}