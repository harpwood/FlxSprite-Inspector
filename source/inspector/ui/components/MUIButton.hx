package inspector.ui.components;

import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUIButton;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

/**
 * ...
 * @author Harpwood Studio
 * https://harpwood.itch.io/
 */

 /**
  * Customized FlxUIButton class
  */
class MUIButton extends FlxUIButton 
{

	public function new(X:Float=0, Y:Float=0, Width:Int = 80, Height:Int = 20, ?Label:String, ?OnClick:Void->Void, ?LoadDefaultGraphics:Bool=true, ?LoadBlank:Bool=false, ?Color:FlxColor=FlxColor.WHITE) 
	{
		super(X, Y, Label, OnClick, LoadDefaultGraphics, LoadBlank, Color);
		
		if (LoadDefaultGraphics) this.loadGraphicSlice9(null, Width, Height, null, FlxUI9SliceSprite.TILE_NONE, -1, true);
		this.setLabelFormat(null, 12, FlxColor.WHITE, "center");
		
		this.getLabel().pixelPerfectRender = true;
		this.getLabel().scrollFactor.set(1, 1);
		
	}
	
	public function setLabelOffsets(offsets:FlxPoint):Void
	{
		for (i in 0...this.labelOffsets.length)
		{
			this.labelOffsets[i].x += offsets.x;
			this.labelOffsets[i].y += offsets.y;
		}
	}
}