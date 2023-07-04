package inspector.ui.components;

import flixel.addons.ui.FlxUIGroup;
import flixel.util.FlxColor;
import flixel.addons.ui.FlxInputText;
import inspector.ui.components.ClickArea;

/**
 * ...
 * @author Harpwood Studio
 * https://harpwood.itch.io/
 */

class TextInput extends FlxUIGroup 
{

	public var inputText:FlxInputText;
	var focus:ClickArea;
	
	public function new(X:Float=0, Y:Float=0, Width:Int = 120, Height:Int = 30, CustomFilterPattern:EReg = null, Callback:(String, String)->Void, Text:String = "", ?FocusLost:Void->Void,size:Int = 12,TextColor:FlxColor = FlxColor.BLACK, BackgroundColor:FlxColor = FlxColor.WHITE) 
	{
		super(X, Y);
		
		inputText = new FlxInputText(X, Y, Width, Text, size, TextColor, BackgroundColor);
		inputText.borderColor = FlxColor.BLACK;
		inputText.customFilterPattern = CustomFilterPattern;
		if (CustomFilterPattern != null)
			inputText.filterMode = FlxInputText.CUSTOM_FILTER;
		inputText.callback = Callback;
		inputText.focusLost = FocusLost;
		focus = new ClickArea(X, Y, Width, Height-10, ()->{ inputText.hasFocus = true; });
		
		add(inputText);
		add(focus);
		
	}
	
}