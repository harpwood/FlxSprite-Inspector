package inspector.core;
import inspector.core.FlxSpriteInpsector;

/**
 * ...
 * @author Harpwood Studio
 * https://harpwood.itch.io/
 */

class FlxSkewedSpriteInspector extends FlxSpriteInpsector
{
	public function new(){super();}
	
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
		sprite = new DinoSpriteSkewed();

		super.create();
	}
	
	override function resetChanges():Void
	{
		super.resetChanges();
		
		sprite.skew.set(0, 0);
	}
	
	override function updateHSkewText(left:Int, right:Int)
	{
		sprite.skew.x += (left + right) * transformModifier * invert;
		statusText.text = "Adjusting skew";
	}
	
	override function updateVSkewText(up:Int, down:Int):Void
	{
		sprite.skew.y += (up + down) * transformModifier * invert;
		statusText.text = "Adjusting skew.";
	}
	
	override function updateSkewText():Void
	{
		skewText.text = 'skew: [${(Std.string(sprite.skew.x)).substring(0, 6)}, ${(Std.string(sprite.skew.y)).substring(0, 6)}]';
	}
}