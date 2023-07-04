package inspector.core;

import flixel.FlxSprite;
import inspector.core.SpriteViewer;
import inspector.ui.ColorMatrixFilterUI;

import openfl.filters.ColorMatrixFilter;
import openfl.geom.Point;
import flash.display.BitmapData;


/**
 * ...
 * @author Harpwood Studio
 */


class ColorMatrixFilterInspector extends SpriteViewer
{
	var cmfUI:ColorMatrixFilterUI;
	
	var bdata:BitmapData;
	
	var spr:DinoSprite;
	
	public function new() {super();}

	override public function create()
	{
		super.create();

		cmfUI = new ColorMatrixFilterUI(this, 0, 30);
		ui.add(cmfUI);
		
		statusText.text = "Welcome to Color Matrix Filter Inspector!";
	}
	
	
	public function updateColorMatrixFilter(filter:Array<Float>)
	{
		sprite.pixels.applyFilter(sprite.pixels, sprite.pixels.rect, new Point(), new ColorMatrixFilter(filter));
	}
	
	public function reset()
	{
		sprite.destroy();
		sprite = null;
		
		initSprite();
	}

}