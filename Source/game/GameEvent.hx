package game;

/**
 * ...
 * @author Colour Multimedia Enterprises
 */
class GameEvent
{
	
	public static var GameEvents:Array<GameEvent> = [];
	public static var QueuedEvents:Array<GameEvent> = [];

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
			
			GameEvents.push(e);
		}
	}
		
	public static function startEvent(id:Int):Void {
		for (i in 0...GameEvents.length) if (GameEvents[i].id == id) QueuedEvents.push(GameEvents[i]);
		
		throw new Error("Game Event " + id + " does not exist");
	}
	
	public static function stopEvent(id:Int):Void {
		for (i in 0...QueuedEvents.length) if (QueuedEvents[i].id == id) QueuedEvents.slice(QueuedEvents[i], 1);
		
		throw new Error("Game Event " + id + "has already been stopped.");
	}
	
	
	
}