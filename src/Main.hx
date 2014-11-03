package;

import game.GameState;
import openfl.Assets;
import openfl.display.Sprite;
import haxe.Json;

class Main extends Sprite
{
	
	public function new ()
	{			
		super();
		
		Reg.init();

		addChild(new GameState());
	}
}