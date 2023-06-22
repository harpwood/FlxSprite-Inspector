package;

import flixel.FlxGame;
import openfl.display.Sprite;
import helpers.FlxSpriteInpsector;
import com.spikything.utils.MouseWheelTrap;

class Main extends Sprite
{
	public function new()
	{
		super();
		trace("Hello from openfl!");

		// Prevent the web page from being scrolled by the mouse wheel within the application frame
		#if html5
		MouseWheelTrap.setup(stage);
		#end

		/**
		 * Add the following code snippet to your project to use the FlxSprite Inspector.
		 *
		 * @param launchInspector Set to `true` to launch the FlxSprite Inspector, or `false` to launch your game.
		 */
		var launchInspector:Bool = true;

		if (launchInspector)
		{
			addChild(new FlxGame(1024, 748, FlxSpriteInpsector));
			return;
		}
		// End of code snippet

		addChild(new FlxGame(0, 0, PlayState));
	}
}
