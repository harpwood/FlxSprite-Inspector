package;

import flixel.FlxState;

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
