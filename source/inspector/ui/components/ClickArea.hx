package inspector.ui.components;

import flixel.addons.ui.FlxUIButton;

class ClickArea extends FlxUIButton 
{

	public var onClick : Void->Void;
	
	public function new(x: Float, y: Float, width: Float, height: Float, onClick: Void->Void = null)
	{
		super(x, y, null, false, true);
		this.width = width;
		this.height = height;
		this.onClick = onClick;
		immovable = true;
		scrollFactor.set();
		onUp.callback = function () { if (this.onClick != null) this.onClick(); };
		
	}
	
}