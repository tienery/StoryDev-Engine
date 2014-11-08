package ;

import openfl.display.InteractiveObject;
import openfl.events.Event;

class Anchor
{
	public static inline var NONE = 0;
	public static inline var TOP = 1;
	public static inline var LEFT = 2;
	public static inline var RIGHT = 4;
	public static inline var BOTTOM = 8;
}

class ExtendedObject extends InteractiveObject
{

	public function new() 
	{
		super();
		
		stage.addEventListener(Event.RESIZE, onStageResize);
	}
	
	public var anchor(get, set):Int;
	
	function get_anchor() return anchor;
	function set_anchor(value) return anchor = value;
	
	private var rightDiff(get, null):Int;
	private var bottomDiff(get, null):Int;
	
	function get_rightDiff() return stage.stageWidth - (this.width + this.x);
	function get_bottomDiff() return stage.stageHeight - (this.height + this.y);
	
	public function onStageResize(e:Event):Void
	{
		if (this.anchor == (Anchor.RIGHT & Anchor.LEFT) || this.anchor == (Anchor.BOTTOM & Anchor.TOP))
			return;
		else if (this.anchor == (Anchor.TOP)) 
		{
			if (this.x > rightDiff)
				this.x = rightDiff;
		}
		else if (this.anchor == (Anchor.BOTTOM)) 
		{
			this.y = bottomDiff;
			if (this.x > rightDiff)
				this.x = rightDiff;
		}
		else if (this.anchor == (Anchor.LEFT)) 
		{
			if (this.y > bottomDiff)
				this.y = bottomDiff;
		}
		else if (this.anchor == (Anchor.RIGHT))
		{
			this.x = rightDiff;
			if (this.y > bottomDiff)
				this.y = bottomDiff;
		}
		else if (this.anchor == (Anchor.TOP & Anchor.LEFT))
		{
			
		}
	}
	
}