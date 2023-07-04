package inspector.ui.components;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUIGroup;
import flixel.input.mouse.FlxMouseEvent;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.geom.Rectangle;

/**
 * ...
 * @author Harpwood Studio
 * https://harpwood.itch.io/
 */

class UIWidget extends FlxUIGroup
{

	var area:FlxUI9SliceSprite;
	var areaWidth:Int;
	var areaHeight:Int;
	var areaMinimizedHeight:Int = 36;
	var label:FlxText;
	var canMove:Bool = false;
	var dragArea:FlxSprite;
	var minBtn:FlxUIButton;
	var dragOffsetX:Float = 0;
	var dragOffsetY:Float = 0;
	var isMinimized:Bool = false;

	public var components:Array<FlxBasic>;

	public function new(X:Float=0, Y:Float=0, Width:Int = 200, Height:Int = 200)
	{
		super(X, Y);

		x = X;
		y = Y;
		areaWidth = Width;
		areaHeight = Height;

		area = new FlxUI9SliceSprite(0, 0, null, new Rectangle(0, 0, Width, Height));
		area.color = 0xffa0c4e4;
		add(area);

		dragArea = new FlxSprite();
		dragArea.makeGraphic(Width - 45, 25, 0xff586c7d);
		dragArea.setPosition(5, 5);
		add(dragArea);

		FlxMouseEvent.add(dragArea, onMouseDown);

		minBtn = new FlxUIButton(Width - 37, 6, "-", minBtnClicked, false, false);
		minBtn.loadGraphic("assets/inspector/minbtn.png", true, 30, 24);
		add(minBtn);

		label = new FlxText(0, 7, Width - 35, "UI Object", 15);
		label.color = FlxColor.WHITE;
		label.alignment = "center";
		add(label);

		components = [];
	}

	function onMouseDown(o:FlxObject):Void
	{
		canMove = true;
		dragOffsetX = x - FlxG.mouse.x;
		dragOffsetY = y - FlxG.mouse.y;
	}

	function minBtnClicked():Void
	{

		minBtn.toggled = false;
		isMinimized = !isMinimized;

		area.resize(areaWidth, isMinimized ? areaMinimizedHeight : areaHeight);

		for (i in 0...components.length)
		{
			components[i].visible = !isMinimized;
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.mouse.pressed && canMove)
		{
			try
			{
				x = FlxG.mouse.x + dragOffsetX;
				y = FlxG.mouse.y + dragOffsetY;
			}
			catch (e) {trace(e + "update"); };
		}

		if (FlxG.mouse.released && canMove)
		{
			canMove = false;
		}
	}

	public function setLabelText(text:String):Void
	{
		label.text = text;
	}

}