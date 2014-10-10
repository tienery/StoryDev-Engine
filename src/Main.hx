package;

import game.GameState;
import openfl.Assets;
import openfl.display.Sprite;

class Main extends Sprite
{
	
	public function new ()
	{	
		super();

		Reg.init();

		addChild(new MainMenu());
	}
}