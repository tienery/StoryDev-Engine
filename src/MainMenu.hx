package ;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.text.TextField;
import game.Fonts;
import openfl.text.TextFormatAlign;
import openfl.display.StageScaleMode;

/**
 * ...
 * @author Colour Multimedia Enterprises
 */
class MainMenu extends Sprite
{
	private var _btnOpenEditor:TextField;
	private var _btnOpenEditorGraphics:Sprite;
	private var _btnLoadGame:TextField;
	private var _btnLoadGameGraphics:Sprite;
	private var _background:Sprite;
	
	public function new() 
	{
		super();
		
		addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	private function init(e:Event):Void
	{
		removeEventListener(Event.ADDED_TO_STAGE, init);
		stage.scaleMode = StageScaleMode.EXACT_FIT;
		
		Fonts.RegisterFonts();
		
		_btnOpenEditor = new TextField();
		_btnOpenEditor.text = "Open Editor";
		_btnOpenEditor.defaultTextFormat = Fonts.GetFormat("main-bold", 16, 0x000000, false, TextFormatAlign.CENTER);
		_btnOpenEditor.height = 30;
		_btnOpenEditor.width = 250;
		_btnOpenEditor.selectable = false;
		
		_background = new Sprite();
		_background.graphics.beginFill(0x00CCFF, 1);
		_background.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
		_background.graphics.lineStyle(1, 0x004499);
		_background.graphics.moveTo(stage.stageWidth / 2, stage.stageHeight * .2);
		_background.graphics.lineTo(stage.stageWidth / 2, stage.stageHeight * .8);
		_background.x = 0;
		_background.y = 0;
		_background.width = stage.stageWidth;
		_background.height = stage.stageHeight;
		
		addChild(_background);
		addChild(_btnOpenEditor);
	}
	
}