package inspector ;

import flixel.FlxState;

/**
 * ...
 * @author Harpwood Studio
 * https://harpwood.itch.io/
 */
class Sprite extends FlxState 
{

	/**
	 * The sprite to be inspected. It represents the object being inspected and
	 * can be an instance of a class that extends FlxSprite or a vanilla FlxSprite.
	 */
	var sprite = null; // Dynamic
	
	override public function create():Void
	{
		super.create();
		
		initSprite();
		
	}
	
	function initSprite():Void
	{
		/**
		 * !!!IMPORTANT!!!
		 * Create a new instance of the FlxSprite based class and assign it to the 'sprite' variable.
		 * Replace 'DinoSprite' with the name of your custom FlxSprite class.
		 */
		//sprite = new DinoSpriteSkewed();
		
		sprite = new AdventurerSkewed(); //another cool sprite to test
		
		add(sprite);
		sprite.screenCenter();
	}
	
}