package game;

/**
 * ...
 * @author Colour Multimedia Enterprises
 */
class GameEvent
{
	
	public static var _gameEvents:Array<GameEvent> = [];
	public static var _queuedEvents:Array<GameEvent> = [];

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
			
			_gameEvents.push(e);
		}
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