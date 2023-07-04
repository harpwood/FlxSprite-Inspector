package demo;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUIButton;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import inspector.ui.components.MUIButton;
import inspector.ui.components.UIWidget;
import flixel.addons.display.FlxBackdrop;

/**
 * ...
 * @author Harpwood Studio
 * https://harpwood.itch.io/
 */
class DemoMenu extends FlxState
{

	var bd:FlxBackdrop;
	var angle:Float = 1;
	
	override public function create():Void
	{
		super.create();
		
		FlxG.camera.pixelPerfectRender = true;
		
		bd = new FlxBackdrop("assets/inspector/blue_dot.png");
		add(bd);
		
		var banner:FlxSprite = new FlxSprite();
		banner.loadGraphic("assets/inspector/demobanner.png");
		banner.screenCenter();
		banner.y = 10;
		add(banner);

		var w = 300;
		var h = 125;
		var widget:UIWidget = new UIWidget(FlxG.width * .5 - w * .5, FlxG.height * .5 - h * .5, w, h);
		widget.setLabelText("Menu");
		add(widget);

		var sIB:MUIButton = new MUIButton(10, 40, w - 20, 30, "FlxSprite Inspector (with skew)", sI, true, false, 0xff728da3);
		sIB.setLabelOffsets(new FlxPoint(0, 10));
		widget.add(sIB);
		widget.components.push(sIB);

		var cmfIB:MUIButton = new MUIButton(10, 80, w - 20, 30, "Color Matrix Filter Inspector", cmfI, true, false, 0xff728da3);
		cmfIB.setLabelOffsets(new FlxPoint(0, 5));
		widget.add(cmfIB);
		widget.components.push(cmfIB);

	}

	function sI():Void
	{
		FlxG.switchState(new FlxSkewedSpriteInspectorDEMO());
	}

	function cmfI():Void
	{
		FlxG.switchState(new ColorMatrixFilterInspectorDEMO());
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		angle += .001;
		bd.x += Math.cos(angle) * 80 * elapsed;
		bd.y += Math.sin(angle) * 80 * elapsed;
	}

}