package game;

import haxe.Json;
import openfl.text.TextFormat;
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
import openfl.net.SharedObject;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.display.StageScaleMode;
import openfl.display.StageQuality;
import openfl.display.StageAlign;
import openfl.text.Font;

#if js
@:font("a/font/main.ttf") class DefaultFont extends Font { }
@:font("a/font/main-bold.ttf") class BoldFont extends Font { }
@:font("a/font/main-bolditalic.ttf") class BoldItalicFont extends Font { }
@:font("a/font/main-italic.ttf") class ItalicFont extends Font { }
#end

class GameState extends Sprite
{
	private var _storyText:TextField;
	private var _storyBG:Sprite;
	private var _storyString:String;
	private var _menuText:TextField;
	private var _menuBG:Sprite;
	private var _textureQualityText:TextField;
	private var _musicVolumeText:TextField;
	private var _sfxVolumeText:TextField;
	private var _vocalVolumeText:TextField;
	private var _saveText:TextField;
	private var _loadText:TextField;
	private var _returnHomeText:TextField;
	private var _helpOptionsText:TextField;
	private var _fullscreenText:TextField;
	private var _no:TextField;
	private var _yes:TextField;
	private var _confirm:TextField;
	private var _defaultFont:Font = Assets.getFont("a/font/main.ttf");
	private var _boldFont:Font = Assets.getFont("a/font/main-bold.ttf");
	private var _boldItalicFont:Font = Assets.getFont("a/font/main-bolditalic.ttf");
	private var _italicFont:Font = Assets.getFont("a/font/main-italic.ttf");
	private var _defaultFormat:TextFormat;
	private var _boldFormat:TextFormat;
	private var _boldItalicFormat:TextFormat;
	private var _italicFormat:TextFormat;
	
	private var _textureQuality:Int;
	private var _musicVolume:Int;
	private var _sfxVolume:Int;
	private var _vocalVolume:Int;
	private var _videoVolume:Int;
	private var _fullscreen:Bool;

	private var _charImage:Bitmap;
	private var _bgImage:Bitmap;
	private var _storyTextDims:Point;
	private var _charImageDefaults:LocationSize;
	private var _charImageChanges:LocationSize;
	private var _storyTextDimsChanges:LocationSize;
	
	private var _parser:Parser;
	private var _interp:Interp;

	private var _currentPassage:Int = -1;
	private var _lastPassage:Int = -1;

	private var _startingKeys:Array<Dynamic> = [];
	
	public function new ()
	{
		super();

		addEventListener(Event.ADDED_TO_STAGE, init);
	}

	public function init(e:Event):Void
	{
		removeEventListener(Event.ADDED_TO_STAGE, init);
		stage.addEventListener(Event.RESIZE, onStageResize);

		_textureQuality = 2;
		_musicVolume = 50;
		_sfxVolume = 50;
		_vocalVolume = 50;
		_videoVolume = 50;
		
		#if js
		_defaultFormat = new TextFormat("main");
		_boldFormat = new TextFormat("main-bold");
		_boldItalicFormat = new TextFormat("main-bolditalic");
		_italicFormat = new TextFormat("main-italic");
		#else
		_defaultFormat = new TextFormat(_defaultFont.fontName);
		_boldFormat = new TextFormat(_boldFont.fontName);
		_boldItalicFormat = new TextFormat(_boldItalicFont.fontName);
		_italicFormat = new TextFormat(_italicFont.fontName);
		#end
		
		stage.quality = StageQuality.HIGH;
		#if js
		Font.registerFont(DefaultFont);
		Font.registerFont(BoldFont);
		Font.registerFont(BoldItalicFont);
		Font.registerFont(ItalicFont);
		#end
		
		setupMainText();
		setupEvents();
		setupHScript();
		GameEvent.initEvents();
		setupPauseMenu();

		gotoPassage();
	}
	
	private function onStageResize(e:Event):Void
	{
		stage.scaleMode = StageScaleMode.EXACT_FIT;
	}
	
	private function setupPauseMenu():Void
	{
		
		_menuText = new TextField();
		_menuText.width = 55;
		_menuText.height = 20;
		_menuText.x = 0;
		_menuText.y = 0;
		_menuText.selectable = false;
		_menuText.defaultTextFormat = _defaultFormat;
		_menuText.defaultTextFormat.size = 16;
		_menuText.text = "MENU";
		_menuText.embedFonts = true;
		_menuText.addEventListener(MouseEvent.CLICK, showPauseMenu);
		
		_menuBG = new Sprite();
		_menuBG.graphics.beginFill(0, .6);
		_menuBG.graphics.drawRect(0, 0, 1, 1);
		_menuBG.x = 0;
		_menuBG.y = 0;
		_menuBG.width = stage.stageWidth;
		_menuBG.height = stage.stageHeight;
		
		_helpOptionsText = new TextField();
		_helpOptionsText.width = 500;
		_helpOptionsText.height = 25;
		_helpOptionsText.x = stage.stageWidth / 2 - _helpOptionsText.width / 2;
		_helpOptionsText.y = 25;
		_helpOptionsText.textColor = 0xFFFFFF;
		_helpOptionsText.embedFonts = true;
		_helpOptionsText.defaultTextFormat = _defaultFormat;
		_helpOptionsText.defaultTextFormat.size = 14;
		_helpOptionsText.text = "Hover over an item to display help options.";
		_helpOptionsText.selectable = false;
		
		_textureQualityText = new TextField();
		_textureQualityText.height = 30;
		_textureQualityText.width = 300;
		_textureQualityText.x = stage.stageWidth / 2 - _textureQualityText.width / 2;
		_textureQualityText.y = 50;
		_textureQualityText.textColor = 0xFFFFFF;
		_textureQualityText.defaultTextFormat = _defaultFormat;
		_textureQualityText.defaultTextFormat.size = 20;
		_textureQualityText.text = "Display Quality: " + getQualityInfo();
		_textureQualityText.embedFonts = true;
		_textureQualityText.selectable = false;
		_textureQualityText.addEventListener(MouseEvent.MOUSE_WHEEL, setQuality);
		_textureQualityText.addEventListener(MouseEvent.MOUSE_OVER, onTextureHover);
		
		_musicVolumeText = new TextField();
		_musicVolumeText.height = 30;
		_musicVolumeText.width = 300;
		_musicVolumeText.x = stage.stageWidth / 2 - _musicVolumeText.width / 2;
		_musicVolumeText.y = 85;
		_musicVolumeText.textColor = 0xFFFFFF;
		_musicVolumeText.defaultTextFormat = _defaultFormat;
		_musicVolumeText.defaultTextFormat.size = 20;
		_musicVolumeText.selectable = false;
		_musicVolumeText.embedFonts = true;
		_musicVolumeText.text = "Music Volume: " + _musicVolume + "%";
		_musicVolumeText.addEventListener(MouseEvent.MOUSE_WHEEL, setMusicVolume);
		_musicVolumeText.addEventListener(MouseEvent.MOUSE_OVER, onVolumeHover);
		
		_sfxVolumeText = new TextField();
		_sfxVolumeText.height = 30;
		_sfxVolumeText.width = 300;
		_sfxVolumeText.x = stage.stageWidth / 2 - _sfxVolumeText.width / 2;
		_sfxVolumeText.y = 120;
		_sfxVolumeText.textColor = 0xFFFFFF;
		_sfxVolumeText.defaultTextFormat = _defaultFormat;
		_sfxVolumeText.defaultTextFormat.size = 20;
		_sfxVolumeText.selectable = false;
		_sfxVolumeText.embedFonts = true;
		_sfxVolumeText.text = "SFX Volume: " + _sfxVolume + "%";
		_sfxVolumeText.addEventListener(MouseEvent.MOUSE_WHEEL, setSFXVolume);
		_sfxVolumeText.addEventListener(MouseEvent.MOUSE_OVER, onVolumeHover);
		
		_vocalVolumeText = new TextField();
		_vocalVolumeText.height = 30;
		_vocalVolumeText.width = 300;
		_vocalVolumeText.x = stage.stageWidth / 2 - _vocalVolumeText.width / 2;
		_vocalVolumeText.y = 155;
		_vocalVolumeText.textColor = 0xFFFFFF;
		_vocalVolumeText.defaultTextFormat = _defaultFormat;
		_vocalVolumeText.defaultTextFormat.size = 20;
		_vocalVolumeText.selectable = false;
		_vocalVolumeText.embedFonts = true;
		_vocalVolumeText.text = "Vocal Volume: " + _vocalVolume + "%";
		_vocalVolumeText.addEventListener(MouseEvent.MOUSE_WHEEL, setVocalVolume);
		_vocalVolumeText.addEventListener(MouseEvent.MOUSE_OVER, onVolumeHover);
		
		_saveText = new TextField();
		_saveText.height = 30;
		_saveText.width = 300;
		_saveText.x = stage.stageWidth / 2 - _saveText.width / 2;
		_saveText.y = 190;
		_saveText.textColor = 0xFFFFFF;
		_saveText.defaultTextFormat = _defaultFormat;
		_saveText.defaultTextFormat.size = 20;
		_saveText.selectable = false;
		_saveText.embedFonts = true;
		_saveText.text = "Save Game";
		_saveText.addEventListener(MouseEvent.CLICK, saveGame); 
		_saveText.addEventListener(MouseEvent.MOUSE_OVER, onSaveHover);
		
		_loadText = new TextField();
		_loadText.height = 30;
		_loadText.width = 300;
		_loadText.x = stage.stageWidth / 2 - _loadText.width / 2;
		_loadText.y = 225;
		_loadText.textColor = 0xFFFFFF;
		_loadText.defaultTextFormat = _defaultFormat;
		_loadText.defaultTextFormat.size = 20;
		_loadText.selectable = false;
		_loadText.embedFonts = true;
		_loadText.text = "Load Game";
		_loadText.addEventListener(MouseEvent.CLICK, loadGame);
		_loadText.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent) { _helpOptionsText.text = "Load a previously saved game."; } );
		
		_returnHomeText = new TextField();
		_returnHomeText.height = 30;
		_returnHomeText.width = 300;
		_returnHomeText.x = stage.stageWidth / 2 - _returnHomeText.width / 2;
		_returnHomeText.y = 260;
		_returnHomeText.textColor = 0xFFFFFF;
		_returnHomeText.defaultTextFormat = _defaultFormat;
		_returnHomeText.defaultTextFormat.size = 20;
		_returnHomeText.embedFonts = true;
		_returnHomeText.selectable = false;
		_returnHomeText.text = "Return to Home";
		_returnHomeText.addEventListener(MouseEvent.CLICK, function(e:MouseEvent) { gotoPassage(1); } );
		_returnHomeText.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent) { _helpOptionsText.text = "Return to the Home passage. Does not reset data."; } );
		
		addChild(_menuText);
	}
	
	private function loadGame(e:MouseEvent):Void
	{
		load();
	}
	
	private function saveGame(e:MouseEvent):Void 
	{
		removeMenu();
		_confirm = new TextField();
		_confirm.width = 370;
		_confirm.height = 25;
		_confirm.embedFonts = true;
		_confirm.defaultTextFormat = _defaultFormat;
		_confirm.defaultTextFormat.size = 15;
		_confirm.selectable = false;
		_confirm.text = "Are you sure you wish to overwrite existing data and save?";
		
		_yes = new TextField();
		_yes.width = 45;
		_yes.height = 30;
		_yes.selectable = false;
		_yes.embedFonts = true;
		_yes.defaultTextFormat = _defaultFormat;
		_yes.defaultTextFormat.size = 15;
		_yes.text = "Yes";
		_yes.addEventListener(MouseEvent.CLICK, onYesClicked);
		
		_no = new TextField();
		_no.width = 45;
		_no.height = 30;
		_no.selectable = false;
		_no.embedFonts = true;
		_no.defaultTextFormat = _defaultFormat;
		_no.defaultTextFormat.size = 15;
		_no.text = "No";
		_no.addEventListener(MouseEvent.CLICK, onNoClicked);
		
		addChild(_confirm);
		_confirm.textColor = 0xFFFFFF;
		addChild(_yes);
		_yes.textColor = 0xFFFFFF;
		addChild(_no);
		_no.textColor = 0xFFFFFF;
		
		_confirm.x = stage.stageWidth / 2 - _confirm.width / 2;
		_confirm.y = stage.stageHeight / 2 - _confirm.height / 2;
		_yes.y = _confirm.y + 35;
		_yes.x = (stage.stageWidth / 2 - _yes.width / 2) - 50;
		_no.y = _confirm.y + 35;
		_no.x = (stage.stageWidth / 2 - _no.width / 2) + 50;
	}
	
	private function onNoClicked(e:MouseEvent):Void
	{
		removeChild(_confirm);
		removeChild(_yes);
		removeChild(_no);
		openMenu();
	}
	
	private function onYesClicked(e:MouseEvent):Void
	{
		save();
		removeChild(_confirm);
		removeChild(_yes);
		removeChild(_no);
		openMenu();
	}
	
	private function getQualityInfo():String
	{
		if (_textureQuality == 3) return "Highest";
		else if (_textureQuality == 2) return "High";
		else if (_textureQuality == 1) return "Moderate";
		else if (_textureQuality == 0) return "Low";
		else return "";
	}
	
	private function onTextureHover(e:MouseEvent):Void
	{
		_helpOptionsText.text = "Adjusts the quality of text and sprites. Scroll to change.";
	}
	
	private function onVolumeHover(e:MouseEvent):Void
	{
		_helpOptionsText.text = "Changes the volume of the given channel. Scroll to change.";
	}
	
	private function onSaveHover(e:MouseEvent):Void
	{
		_helpOptionsText.text = "Save the game. This will overwrite any existing data. Click to save.";
	}
	
	private function setVocalVolume(e:MouseEvent):Void
	{
		if (e.delta > 0) _vocalVolume += 5;
		else _vocalVolume -= 5;
		
		if (_vocalVolume > 100) _vocalVolume = 100;
		if (_vocalVolume < 0) _vocalVolume = 0;
		
		Sm.modifyChannel(Sm.VOCAL_CHANNEL, _vocalVolume, 50);
		
		_vocalVolumeText.text = "Vocal Volume: " + _vocalVolume + "%";
	}
	
	private function setSFXVolume(e:MouseEvent):Void
	{
		if (e.delta > 0) _sfxVolume += 5;
		else _sfxVolume -= 5;
		
		if (_sfxVolume > 100) _sfxVolume = 100;
		if (_sfxVolume < 0) _sfxVolume = 0;
		
		Sm.modifyChannel(Sm.SFX_CHANNEL, _sfxVolume, 50);
		
		_sfxVolumeText.text = "SFX Volume: " + _sfxVolume + "%";
	}
	
	private function setMusicVolume(e:MouseEvent):Void
	{
		if (e.delta > 0) _musicVolume += 5;
		else _musicVolume -= 5;
		
		if (_musicVolume > 100) _musicVolume = 100;
		if (_musicVolume < 0) _musicVolume = 0;
		
		Sm.modifyChannel(Sm.MUSIC_CHANNEL, _musicVolume, 50);
		
		_musicVolumeText.text = "Music Volume: " + _musicVolume + "%";
	}
	
	private function setQuality(e:MouseEvent):Void
	{
		if (e.delta > 0) _textureQuality++;
		else _textureQuality--;
		
		if (_textureQuality > 3) _textureQuality = 3;
		if (_textureQuality < 0) _textureQuality = 0;
		
		switch(_textureQuality) 
		{
			case 0:
				stage.quality = StageQuality.LOW;
			case 1:
				stage.quality = StageQuality.MEDIUM;
			case 2:
				stage.quality = StageQuality.HIGH;
			case 3:
				#if flash
				stage.quality = StageQuality.HIGH_16X16;
				#end
		}
		
		_textureQualityText.text = "Display Quality: " + getQualityInfo();
	}
	
	private function showPauseMenu(e:MouseEvent):Void 
	{
		if (_menuText.text == "MENU") {
			addChildAt(_menuBG, getChildIndex(_menuText) - 1);
			openMenu();
			_menuText.textColor = 0xFFFFFF;
			_menuText.text = "CLOSE";
		}
		else {
			removeChild(_menuBG);
			removeMenu();
			_menuText.textColor = 0x000000;
			_menuText.text = "MENU";
		}
	}
	
	private function removeMenu():Void
	{
		removeChild(_helpOptionsText);
		removeChild(_textureQualityText);
		removeChild(_musicVolumeText);
		removeChild(_sfxVolumeText);
		removeChild(_vocalVolumeText);
		removeChild(_saveText);
		removeChild(_loadText);
		removeChild(_returnHomeText);
	}
	
	private function openMenu():Void
	{
		addChildAt(_helpOptionsText, getChildIndex(_menuText));
		_helpOptionsText.textColor = 0xFFFFFF;
		addChildAt(_textureQualityText, getChildIndex(_menuText));
		_textureQualityText.textColor = 0xFFFFFF;
		addChildAt(_musicVolumeText, getChildIndex(_menuText));
		_musicVolumeText.textColor = 0xFFFFFF;
		addChildAt(_sfxVolumeText, getChildIndex(_menuText));
		_sfxVolumeText.textColor = 0xFFFFFF;
		addChildAt(_vocalVolumeText, getChildIndex(_menuText));
		_vocalVolumeText.textColor = 0xFFFFFF;
		addChildAt(_saveText, getChildIndex(_menuText));
		_saveText.textColor = 0xFFFFFF;
		addChildAt(_loadText, getChildIndex(_menuText));
		_loadText.textColor = 0xFFFFFF;
		addChildAt(_returnHomeText, getChildIndex(_menuText));
		_returnHomeText.textColor = 0xFFFFFF;
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
		_storyText.embedFonts = true;
		_storyText.defaultTextFormat = _defaultFormat;
		_storyText.defaultTextFormat.size = 14;
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

		_interp.variables.set("show", show);
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
		_interp.variables.set("goBack", goBack);
		_interp.variables.set("parseJson", Json.parse);
		_interp.variables.set("stringifyJson", Json.stringify);
		_interp.variables.set("startEvent", GameEvent.startEvent);
		_interp.variables.set("stopEvent", GameEvent.stopEvent);
		_interp.variables.set("callEvent", callEvent);
		_interp.variables.set("transCharImage", transitionCharImage);
		_interp.variables.set("transPassage", transitionPassage);
		_interp.variables.set("__stageWidth", stage.stageWidth);
		_interp.variables.set("__stageHeight", stage.stageHeight);

		for (i in _interp.variables.keys())
		{
			_startingKeys.push(i);
		}
	}

	private function setupEvents():Void
	{
		stage.addEventListener(MouseEvent.MOUSE_WHEEL, onScroll);
	}

	private function gotoPassage(id:Int = 0):Void
	{
		if (_currentPassage != id) _lastPassage = _currentPassage; //Prevents refreshing wiping the _lastPassage
		_currentPassage = id;
		
		var passage:Passage = Reg.getPassage(id);
		
		if (passage.htmlText != null) show(passage.htmlText);
		runCode(passage.text);
		callEvents();
	}

	private function runCode(s:String):Void
	{
		try {
			var prog = _parser.parseString(s);
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

	private function refreshPassage():Void { _storyText.htmlText = _storyString; }

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
		_storyString += "<a href=\'event:" + l + "\'>" + s + "</a>";
		refreshPassage();
	}
	
	private function traceText(t:String):Void
	{
		trace(t);
	}

	private function showCharImage(id:String, ignorePassageTransition:Bool = false):Void
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

		if (!ignorePassageTransition)
			transitionPassage(((stage.stageWidth + _charImage.x + _charImage.width) / 2) - storyWidth / 2, _storyText.y, storyWidth, _storyText.height, .5);
		Actuate.tween(_charImage, .5, { alpha: 1 } );
	}

	private function removeCharImage(ignorePassageTransition:Bool = false):Void
	{
		if (!ignorePassageTransition) 
		{
			Actuate.tween(_storyText, .5, { width: _storyTextDims.x, x: stage.stageWidth / 2 - _storyTextDims.x / 2 } );
			Actuate.tween(_storyBG, .5, { width: _storyTextDims.x, x: stage.stageWidth / 2 - _storyTextDims.x / 2 } );
		}
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

	private function goBack():Void
	{
		gotoPassage(_lastPassage);
		_lastPassage = -1;
	}

	private function save():Void
	{
		_interp.variables.set("__currentPassage", _currentPassage);
		_interp.variables.set("__lastPassage", _lastPassage);

		var saveString:String = "";
		for (i in _interp.variables.keys())
		{
			if (_startingKeys.indexOf(i) == -1)
			{
				saveString += i + ":" + Std.string(_interp.variables.get(i)) + "|";
			}
		}

		saveString = saveString.substr(0, saveString.length - 1);

		var so:SharedObject = SharedObject.getLocal(Reg.title);

		so.data.save = saveString;
		so.flush();
	}

	private function load():Void
	{
		var so:SharedObject = SharedObject.getLocal(Reg.title);

		var loadString:String = so.data.save;

		if (loadString == null || loadString == "")
		{
			_interp.variables.set("__currentPassage", 0);
			_interp.variables.set("__lastPassage", -1);
			save();
		}

		var strings:Array<String> = loadString.split("|");

		for (i in strings)
		{
			var action:Array<String> = i.split(":");
			if (Std.parseFloat(action[1]) != Math.NaN) _interp.variables.set(action[0], Std.parseFloat(action[1])) else _interp.variables.set(action[0], action[1]);
		}

		gotoPassage(_interp.variables.get("__currentPassage"));
	}
	
	private function callEvent(id:Int):Void
	{
		for (i in 0...GameEvent.gameEvents.length)
		{
			if (GameEvent.gameEvents[i].id == id)
			{
				runCode(GameEvent.gameEvents[i].code);
				break;
			}
		}
	}
	
	private function callEvents():Void
	{
		for (i in 0...GameEvent.queuedEvents.length)
		{
			runCode(GameEvent.queuedEvents[i].code);
		}
	}
	
	private function transitionCharImage(x:Float, y:Float, width:Float, height:Float, time:Float):Void 
	{		
		Actuate.tween(_charImage, time, { x:x > 0 ? x : _charImageChanges.x, y:y > 0 ? y : _charImageChanges.y, 
		width:width > 0 ? width : _charImageChanges.width, height:height > 0 ? height : _charImageChanges.height } );
		
		if (x > 0) _charImageChanges.x = x;
		if (y > 0) _charImageChanges.y = y;
		if (width > 0) _charImageChanges.width = width;
		if (height > 0) _charImageChanges.height = height;
	}
	
	private function transitionPassage(x:Float, y:Float, width:Float, height:Float, time:Float):Void 
	{
		Actuate.tween(_storyText, time, { x:x, y:y, width:width, height:height} );
		Actuate.tween(_storyBG, time, { x:x, y:y, width:width, height:height } );
	}
	
}