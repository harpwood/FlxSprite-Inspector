package inspector.graphics;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;

using flixel.util.FlxSpriteUtil;

/**
 * ------------------------------------
 * @author Harpwood Studio
 * https://harpwood.itch.io/
 * -----------------------------------------------------------
 * A helper class for drawing debug points on the screen.
 * Can draw dots, crosses, and X marks at specified positions.
 * -----------------------------------------------------------
 */
class DebugPoint extends FlxSprite
{
	var drawColor:FlxColor;
	
	public var erase(default, set):Bool;
	
	public function new(color:FlxColor):Void
	{
		super(0, 0, null);
		
		drawColor = color;
		
		makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);
		
		erase = false;
	}
	
	/**
     * Draws a dot at the specified position (X, Y).
     * If erase mode is enabled, clears the canvas before drawing.
	 * 
	 * @param X The x-coordinate of the dot.
     * @param Y The y-coordinate of the dot.
     */
	public function drawDot(X:Float, Y:Float):Void
	{
		if (erase) this.fill(FlxColor.TRANSPARENT);
		
		this.drawLine(X, Y, X, Y, {color: drawColor});
	}
	
	/**
     * Draws a cross at the specified position (X, Y) with the given size.
     * If erase mode is enabled, clears the canvas before drawing.
	 * 
	 * @param X    The x-coordinate of the cross.
     * @param Y    The y-coordinate of the cross.
     * @param size The size of the cross.
     */
	public function drawCross(X:Float, Y:Float, size:Int):Void
	{
		if (erase) this.fill(FlxColor.TRANSPARENT);
		
		this.drawLine(X - size * .5, Y, X + size * .5, Y, {color: drawColor});
		this.drawLine(X, Y - size * .5, X, Y + size * .5, {color: drawColor});
	}
	
	/**
     * Draws an X mark at the specified position (X, Y) with the given size.
     * If erase mode is enabled, clears the canvas before drawing.
	 * 
     * @param X    The x-coordinate of the X mark.
     * @param Y    The y-coordinate of the X mark.
     * @param size The size of the X mark.
     */
	public function drawXMark(X:Float, Y:Float, size:Int):Void
	{
		if (erase) this.fill(FlxColor.TRANSPARENT);
		
		this.drawLine(X - size * .5, Y - size * .5, X + size * .5, Y + size * .5, {color: drawColor});
		this.drawLine(X - size * .5, Y + size * .5, X + size * .5, Y - size * .5, {color: drawColor});
	}
	
	/**
     * Setter function for the erase property.
     * Allows enabling or disabling erase mode.
	 * 
	 * @param value The value to set for erase mode (true or false).
     */
	function set_erase(value:Bool):Bool
	{
		return erase = value;
	}
	
}
