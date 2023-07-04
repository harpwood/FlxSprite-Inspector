package inspector.core;

import flixel.FlxState;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUIGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import inspector.Sprite;
import openfl.filters.ColorMatrixFilter;
import openfl.geom.Point;


import openfl.geom.Rectangle;

/**
 * ...
 * @author Harpwood Studio
 * https://harpwood.itch.io/
 */

class SpriteViewer extends inspector.Sprite
{
	// Camera variables
	var uiCamera:FlxCamera;
	var gCamera:FlxCamera;
	
	var ui:FlxUIGroup;

	// layers
	var bgLayer:FlxSprite;
	var hitBoxLayer:FlxSprite;
	
	// Text elements
	public var statusText:FlxText;

	
	override public function create():Void
	{
		super.create();
		
		// Initialize the cameras
		initCameras();

		FlxG.cameras.setDefaultDrawTarget(gCamera, false);
		FlxG.cameras.setDefaultDrawTarget(uiCamera, true);

		//TODO add custom BG
		// The background layer filled with black color.
		// The alpha is adjastable with shortcut keys.
		bgLayer = new FlxSprite();
		bgLayer.makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
		bgLayer.setPosition(-FlxG.width, -FlxG.height);
		bgLayer.alpha = .1;
		add(bgLayer);
		
		// Create UI
		ui = new FlxUIGroup();
		ui.cameras = [uiCamera];
		add(ui);
		createStatusArea();


		FlxG.cameras.setDefaultDrawTarget(gCamera, true);
		FlxG.cameras.setDefaultDrawTarget(uiCamera, false);


		// Set the initial zoom
		gCamera.zoom = FlxG.width >= FlxG.height ? (FlxG.width / sprite.width) * .4 : (FlxG.height / sprite.height) * .4;
		
		FlxG.camera = uiCamera;
	}

	/**
	* Handles sprite property changes and user input.
	*
	* @param elapsed The elapsed time since the last update.
	*/
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// Use mouse wheel to zoom
		if (FlxG.mouse.wheel != 0)
		{
			// Constrain the wheel values
			var wheelValue:Int = FlxG.mouse.wheel;
			if (wheelValue < -6)
				wheelValue = -6;
			if (wheelValue > 6)
				wheelValue = 6;

			gCamera.zoom += (wheelValue);

			// Limit the zoom within a certain range
			if (gCamera.zoom < 0)
				gCamera.zoom = 0;
			var maxZoom:Float = FlxG.width >= FlxG.height ? (FlxG.width / sprite.width) * .8 : (FlxG.height / sprite.height) * .8;
			if (gCamera.zoom > maxZoom)
				gCamera.zoom = maxZoom;

			statusText.text = "Adjusting zoom";
			uiCamera.zoom = 1;
		}
		
	}
	
	function createStatusArea():Void
	{
		var uiAreasColor:FlxColor = 0xffa0c4e4;
		var statusArea:FlxUI9SliceSprite = new FlxUI9SliceSprite(0, 0, null, new Rectangle(0, 0, FlxG.width, 30));
		statusArea.color = uiAreasColor;
		ui.add(statusArea);
		
		statusText = new FlxText(0, 5, FlxG.width, "Welcome to FlxSprite Inspector!", 15);
		statusText.color = FlxColor.WHITE;
		statusText.alignment = "center";
		ui.add(statusText);
	}

	/****************************************************
		 * 					CAMERAS
		 */

	/**
	 * Initializes the cameras used in the inspector.
	 * Creates a UI camera and a graphics camera with the same dimensions as the screen.
	 * Sets the background color of the game camera to white and the UI camera to transparent.
	 * Adds the graphics camera as the active camera.
	 * Adds the UI camera and sets it as the non-active camera.
	 */
	function initCameras():Void
	{
		uiCamera = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		gCamera = new FlxCamera(0, 0, FlxG.width, FlxG.height);

		gCamera.bgColor = FlxColor.WHITE;
		uiCamera.bgColor = FlxColor.TRANSPARENT;

		FlxG.cameras.reset(gCamera);
		FlxG.cameras.add(uiCamera, false);
		
		uiCamera.pixelPerfectRender = true;
		gCamera.pixelPerfectRender = true;
	}
}