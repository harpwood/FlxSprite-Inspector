package ;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Harpwood Studio
 * https://harpwood.itch.io/
 * 
 * Sprite by rvros
 * Animated Pixel Adventurer Character on itch.io : https://rvros.itch.io/animated-pixel-hero
 * 
 * This sprite is provided for demonstration reasons.
 * You may delete this class and its assets and provide
 * to FlxSprite inspector your own sprites.
 */

class Adventurer extends FlxSprite 
{

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		
		loadGraphic("assets/images/adventurer.png", true, 50, 37);
		
		/** 
		 * The following code created automatically with an Aseprite lua script
		 * 
		 * For more information:
		 * https://twitter.com/harpwood_studio/status/1676859442971791365
		 * 
		 * Get the lua script:
		 * https://gist.github.com/harpwood/4f21293f497fd103b44734d8501085ab
		 */
		animation.add("idle", [0, 1, 2, 3], 7);
		animation.add("crouch", [4, 5, 6, 7], 7);
		animation.add("run", [8, 9, 10, 11, 12, 13], 7);
		animation.add("jump", [14, 15, 16, 17], 7);
		animation.add("smrslt", [18, 19, 20, 21], 7);
		animation.add("fall", [22, 23], 7);
		animation.add("slide", [24, 25], 7);
		animation.add("stand", [26, 27, 28], 7);
		animation.add("crnr-grb", [29, 30, 31, 32], 7);
		animation.add("crnr-clmb", [33, 34, 35, 36, 37], 7);
		animation.add("idle-2", [38, 39, 40, 41], 7);
		animation.add("attack1", [42, 43, 44, 45, 46], 7);
		animation.add("attack2", [47, 48, 49, 50, 51, 52], 7);
		animation.add("attack3", [53, 54, 55, 56, 57, 58], 7);
		animation.add("hurt", [59, 60, 61], 7);
		animation.add("die", [62, 63, 64, 65, 66, 67, 68], 7);
		animation.add("swrd-drw", [69, 70, 71, 72], 7);
		animation.add("swrd-shte", [73, 74, 75, 76], 7);
		animation.add("crnr-jmp", [77, 78], 7);
		animation.add("wall-slide", [79, 80], 7);
		animation.add("ladder-climb", [81, 82, 83, 84], 7);
		animation.add("cast", [85, 86, 87, 88], 7);
		animation.add("cast-loop", [89, 90, 91, 92], 7);
		animation.add("items", [93, 94, 95], 7);
		animation.add("air-attack1", [96, 97, 98, 99], 7);
		animation.add("air-attack2", [100, 101, 102], 7);
		animation.add("air-attack3-rdy", [103], 7);
		animation.add("air-attack3-loop", [104, 105], 7);
		animation.add("air-attack-3-end", [106, 107, 108], 7);
		animation.add("punch", [109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121], 7);
		animation.add("run-punch", [122, 123, 124, 125, 126, 127, 128], 7);
		animation.add("kick", [129, 130, 131, 132, 133, 134, 135, 136], 7);
		animation.add("drop-kick", [137, 138, 139, 140], 7);
		animation.add("knock-dwn", [141, 142, 143, 144, 145, 146, 147], 7);
		animation.add("get-up", [148, 149, 150, 151, 152, 153, 154], 7);
		animation.add("walk", [155, 156, 157, 158, 159, 160], 7);
		animation.add("crouch-walk", [161, 162, 163, 164, 165, 166], 7);
		animation.add("run2", [167, 168, 169, 170, 171, 172], 7);
		animation.add("wall-run", [173, 174, 175, 176, 177, 178], 7);
		
	}
	
}