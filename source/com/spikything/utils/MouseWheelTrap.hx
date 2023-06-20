package com.spikything.utils;
import openfl.display.Stage;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.external.ExternalInterface;
import openfl.errors.IllegalOperationError;

/**
* MouseWheelTrap - stops simultaneous browser/Flash mousewheel scrolling
* @author Liam O'Donnell
* @version 1.0
* @usage Simply call the static method MouseWheelTrap.setup(stage);
* @see http://www.spikything.com/blog/?s=mousewheeltrap for info/updates
* This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
* © 2009 spikything.com
*
* Ported to OpenFL by Harpwood Studio
* https://harpwood.itch.io/
 */

class MouseWheelTrap
{
	static var JAVASCRIPT :String = "var browserScrolling;function allowBrowserScroll(value){browserScrolling=value;}function handle(delta){if(!browserScrolling){return false;}return true;}function wheel(event){var delta=0;if(!event){event=window.event;}if(event.wheelDelta){delta=event.wheelDelta/120;if(window.opera){delta=-delta;}}else if(event.detail){delta=-event.detail/3;}if(delta){handle(delta);}if(!browserScrolling){if(event.preventDefault){event.preventDefault();}event.returnValue=false;}}if(window.addEventListener){window.addEventListener('DOMMouseScroll',wheel,{passive:false});}window.onmousewheel=document.onmousewheel=wheel;allowBrowserScroll(true);";
	static var  JS_METHOD :String = "allowBrowserScroll";
	static var _browserScrollEnabled :Bool = true;
	static var _mouseWheelTrapped :Bool = false;
	final INSTANTIATION_ERROR :String = "Don't instantiate com.spikything.utils.MouseWheelTrap directly. Just call MouseWheelTrap.setup(stage);";
	
	public function new():Void
	{
		throw new IllegalOperationError(INSTANTIATION_ERROR);
	}

	static public function setup(stage:Stage):Void 
	{
		stage.addEventListener(MouseEvent.MOUSE_MOVE, function(e:Event = null):Void { allowBrowserScroll(false); } );
		stage.addEventListener(Event.MOUSE_LEAVE, function(e:Event = null):Void { allowBrowserScroll(true); } );
	}
	
	static private function allowBrowserScroll(allow:Bool):Void
	{
		createMouseWheelTrap();
		
		if (allow == _browserScrollEnabled)
			return;
		_browserScrollEnabled = allow;
		
		if (ExternalInterface.available) {
			ExternalInterface.call(JS_METHOD, _browserScrollEnabled);
			return;
		}
	}
	
	static private function createMouseWheelTrap():Void
		{
			if (_mouseWheelTrapped) 
				return;
			_mouseWheelTrapped = true;
			
			if (ExternalInterface.available) {
				ExternalInterface.call("eval", JAVASCRIPT);
				return;
			}
		}
}