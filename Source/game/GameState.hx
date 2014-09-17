package game;

import flash.text.TextFormat;
import hscript.Expr.Error;
import hscript.Interp;
import hscript.Parser;
import motion.Actuate;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.events.TextEvent;
import openfl.geom.Point;
import openfl.text.TextField;
import openfl.text.TextFormat;

class GameState extends Sprite
{
	private var _storyText:TextField;
	private var _storyBG:Sprite;
	private var _storyString:String;

	private var _charImage:Bitmap;
	private var _bgImage:Bitmap;
	private var _storyTextDims:Point;

	private var _parser:Parser;
	private var _interp:Interp;
	
	public function new ()
	{
		super();

		addEventListener(Event.ADDED_TO_STAGE, init);
	}

	public function init(e:Event):Void
	{
		removeEventListener(Event.ADDED_TO_STAGE, init);

		setupMainText();
		setupEvents();
		setupHScript();

		gotoPassage();
	}

	private function setupMainText():Void
	{
		_storyText = new TextField();
		_storyText.width = stage.stageWidth * .9;
		_storyText.height = stage.stageHeight * .9;
		_storyText.border = true;
		_storyText.wordWrap = true;
		_storyText.x = stage.stageWidth / 2 - _storyText.width / 2;
		_storyText.y = stage.stageHeight / 2 - _storyText.height / 2;
		_storyText.defaultTextFormat = new TextFormat("main", 20);
		_storyText.addEventListener(TextEvent.LINK, linkClicked);
		_storyText.selectable = false;

		_storyBG = new Sprite();
		_storyBG.graphics.beginFill(0, .3);
		_storyBG.graphics.drawRect(0, 0, 1, 1);
		_storyBG.x = _storyText.x;
		_storyBG.y = _storyText.y;
		_storyBG.width = _storyText.width;
		_storyBG.height = _storyText.height;

		addChild(_storyBG);
		addChild(_storyText);

		_storyTextDims = new Point(_storyText.width, _storyText.height);
	}

	private function setupHScript():Void
	{
		_parser = new Parser();
		_interp = new Interp();

		_interp.variables.set("appendShow", appendShow);
		_interp.variables.set("gotoPassage", gotoPassage);
		_interp.variables.set("appendLink", appendLink);
		_interp.variables.set("string", Std.string);
		_interp.variables.set("trace", traceText);
		_interp.variables.set("Math", Math);
		_interp.variables.set("playSound", Sm.playSound);
		_interp.variables.set("modifyChannel", Sm.modifyChannel);
		_interp.variables.set("stopChannel", Sm.stopChannel);
		_interp.variables.set("showCharImage", showCharImage);
		_interp.variables.set("removeCharImage", removeCharImage);
		_interp.variables.set("showBGImage", showBGImage);
		_interp.variables.set("removeBGImage", removeBGImage);
	}

	private function setupEvents():Void
	{
		stage.addEventListener(MouseEvent.MOUSE_WHEEL, onScroll);
	}

	private function gotoPassage(id:Int = 1):Void
	{
		var passage:Passage = Reg.getPassage(id);
		runCode(passage.text);
	}

	private function runCode(s:String):Void
	{
		try {
			var prog = _parser.parseString(s);
			_interp.variables.set("show", show);
			_interp.execute(prog);
		} catch (e:Error) {
			trace("ERROR: " + e.getName());
		}
	}

	private function linkClicked(e:TextEvent):Void
	{
		runCode(e.text);
	}

	private function onScroll(e:MouseEvent):Void
	{
     	if (e.delta < 0) _storyText.scrollV++
     	else if (e.delta > 0) _storyText.scrollV--;
	}

	private function refreshPassage():Void { _storyText.htmlText = _storyString;}

	private function show(s:String):Void
	{
		if (_charImage != null) removeCharImage();

		_storyString = s;
		refreshPassage();
	}
	
	private function appendShow(s:String):Void
	{
		_storyString += s;
		refreshPassage();
	}

	private function appendLink(s:String, l:String):Void
	{
		_storyString += "<a href=\'event:" + l + "\'>" + s + "";
		refreshPassage();
	}
	
	private function traceText(t:String):Void
	{
		trace(t);
	}

	private function showCharImage(id:String):Void
	{
		if (_charImage != null)
		{
			removeChild(_charImage);
			_charImage = null;
		}

		_charImage = new Bitmap(Assets.getBitmapData("a/img/" + id + ".png"));

		_charImage.x = 30;
		_charImage.y = 30;
		_charImage.alpha = 0;

		addChild(_charImage);

		var storyWidth:Float = _storyTextDims.x - (_charImage.x + _charImage.width);

		Actuate.tween(_storyText, .5, { width: storyWidth, x: ((stage.stageWidth + _charImage.x + _charImage.width) / 2) - storyWidth / 2 } );
		Actuate.tween(_storyBG, .5, { width: storyWidth, x: ((stage.stageWidth + _charImage.x + _charImage.width) / 2) - storyWidth / 2 } );
		Actuate.tween(_charImage, .5, { alpha: 1 } );
	}

	private function removeCharImage():Void
	{
		Actuate.tween(_storyText, .5, { width: _storyTextDims.x, x: stage.stageWidth / 2 - _storyTextDims.x / 2 } );
		Actuate.tween(_storyBG, .5, { width: _storyTextDims.x, x: stage.stageWidth / 2 - _storyTextDims.x / 2 } );
		Actuate.tween(_charImage, .5, { alpha: 0 } );

		_charImage = null;
	}

	private function showBGImage(id:String):Void
	{
		if (_bgImage != null)
		{
			removeChild(_bgImage);
			_bgImage = null;
		}

		_bgImage = new Bitmap(Assets.getBitmapData("a/img/" + id + ".png"));

		_bgImage.alpha = 0;

		addChildAt(_bgImage, 0);
		
		Actuate.tween(_bgImage, 2, { alpha: 1 } );
	}

	private function removeBGImage():Void
	{
		Actuate.tween(_bgImage, 1, { alpha: 0 } );

		_bgImage = null;
	}
}