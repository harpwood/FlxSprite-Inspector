package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.addons.effects.FlxSkewedSprite;

/**
 * ...
 * @author Harpwood Studio
 * https://harpwood.itch.io/
 * 
 * Sprite by Arks
 * Twitter: https://twitter.com/ArksDigital
 * Dino Characters on itch.io : https://arks.itch.io/dino-characters
 */
class DinoSprite extends FlxSkewedSprite
{
	public function new(?X:Float = 0, ?Y:Float = 0, ?SimpleGraphic:FlxGraphicAsset)
	{
		super(X, Y, SimpleGraphic);

		loadGraphic("assets/images/dino.png", true, 24, 24);

		animation.add("idle", [0, 1, 2, 3], 7);
		animation.add("move", [4, 5, 6, 7, 8, 9], 7);
		animation.add("kick", [10, 11, 12], 7);
		animation.add("hurt", [13, 14, 15, 16], 7);
		animation.add("crouch", [17], 1);
		animation.add("sneak", [18, 19, 20, 21, 22, 23], 7);
	}
}
