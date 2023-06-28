package helpers ;

/**
 * ...
 * @author Harpwood Studio
 * https://harpwood.itch.io/
 */
class FlxSpriteInpsector extends FlxSpriteInpsectorBase
{
	public function new() {super();}

	/**
	 * It initializes and sets up the state's objects and variables.
	 */
	override public function create():Void
	{
		/**
		 * !!!IMPORTANT!!!
		 * Create a new instance of the FlxSprite based class and assign it to the 'sprite' variable.
		 * Replace 'DinoSprite' with the name of your custom FlxSprite class.
		 */
		sprite = new DinoSprite();

		super.create();
	}

}