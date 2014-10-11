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

		//addChild(new MainMenu()); //Used to test the new main menu, the eventual replacement of Main.hx
		addChild(new GameState());
	}
}