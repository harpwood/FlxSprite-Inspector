package;

import flixel.FlxG;
import flixel.FlxState;
import helpers.FlxSpriteInpsector;

class PlayState extends FlxState
{
	override public function create()
	{
		super.create();
		trace("Hello from flixel!");
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

	}
}
