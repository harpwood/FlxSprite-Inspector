package demo;

import flixel.FlxG;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUIButton;
import flixel.util.FlxColor;
import inspector.ui.components.MUIButton;
import inspector.ui.components.UIWidget;
import inspector.core.ColorMatrixFilterInspector;
import flixel.math.FlxPoint;

/**
 * ...
 * @author Harpwood Studio
 */
class ColorMatrixFilterInspectorDEMO extends ColorMatrixFilterInspector 
{

	override public function create():Void
	{
		super.create();
		
		var w = 180;
		var h = 120;
		var widget:UIWidget = new UIWidget(FlxG.width - (w + 10),  FlxG.height - (h + 70), w, h);
		widget.setLabelText("Menu");
		ui.add(widget);
		
		var odB:MUIButton = new MUIButton(10, 40, w - 20, 30, "Go to other demo", od, true, false, 0xff728da3);
		odB.setLabelOffsets(new FlxPoint(0, 7));
		widget.add(odB);
		widget.components.push(odB);
		
		var mnB:MUIButton = new MUIButton(10, 80, w - 20, 30, "back to menu", mn, true, false, 0xff728da3);
		mnB.setLabelOffsets(new FlxPoint(0, 3));
		widget.add(mnB);
		widget.components.push(mnB);
	
		FlxG.camera = uiCamera;
	}
	
	function od():Void
	{
		FlxG.switchState(new FlxSkewedSpriteInspectorDEMO());
	}
	
	function mn():Void
	{
		FlxG.switchState(new DemoMenu());
	}
	
}