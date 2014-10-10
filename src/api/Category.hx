package api;
import openfl.display.Sprite;
import openfl.geom.Rectangle;
import openfl.text.TextField;
import game.Fonts;

/**
 * ...
 * @author Colour Multimedia Enterprises
 */
class Category extends Sprite
{
	private var _field:TextField;
	public var Text(get, set):String;
	
	public function new(text:String, source:Rectangle) 
	{
		super();
		_field = new TextField();
		_field.width = source.width;
		_field.height = source.height;
		_field.defaultTextFormat = Fonts.GetFormat("main-bold", 15, 0xB52D00, false);
		
		
		graphics.beginFill(0xFF9700, 1);
		graphics.drawRect(0, 0, 1, 1);
		
		x = source.x;
		y = source.y;
		
		this.Text = text;
		
	}
	
	function get_Text() 
	{
		return _field.text;
	}
	
	function set_Text(value)
	{
		return _field.text = value;
	}
	
}