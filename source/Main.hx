package;

import flixel.FlxGame;
import openfl.display.Sprite;
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
			/**
			 * Launches the FlxSprite Inspector with skew capabilities or the default inspector.
			 * Leave only one `addChild` uncommented based on your desired inspector.
			 */

			// Launches the default inspector.
			//addChild(new FlxGame(1024, 748, helpers.FlxSpriteInpsector));

			// Launches the Skew-capable inspector. 
			addChild(new FlxGame(1024, 748, helpers.FlxSkewedSpriteInspector));

			return;
		}
		// End of code snippet

		// You game starts from here
		addChild(new FlxGame(0, 0, PlayState));
	}
}
