package helpers;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import helpers.graphics.DebugPoint;

using flixel.util.FlxSpriteUtil;

/**
 *----------------------------------------------------------------------------------------
 * Helper class for inspecting and manipulating properties of a sprite in HaxeFlixel.
 *----------------------------------------------------------------------------------------
 * @author Harpwood Studio
 * https://harpwood.itch.io/
 *----------------------------------------------------------------------------------------
 * Instructions:
 * 1. In the constructor, below the 'super.create();' line, replace 'DinoSprite' with the 
 * 	  name of your custom FlxSprite class.
 * 2. Determine the desired values for offset, origin, and angle for your sprite.
 * 3. Implement these values in your sprite within your game.
 *----------------------------------------------------------------------------------------
 * Controls:
 * H						  : Toggle help visibility on/off
 * Mouse Wheel                : Zoom in/out.
 * Arrow Keys                 : Move the offset of the sprite by one pixel.
 * Shift + Arrow Keys         : Move the offset of the sprite by multiple pixels.
 *                              The amount will vary based on the zoom level.
 * Alt + Arrow Keys           : Move the origin of the sprite by one pixel.
 * Alt + Shift + Arrow Keys   : Move the origin of the sprite by multiple pixels.
 *                              The amount will vary based on the zoom level.
 * Ctrl + Arrow Keys          : Adjust the size of the sprite's hitbox by one pixel.
 * Ctrl + Shift + Arrow Keys  : Adjust the size of the sprite's hitbox by multiple pixels.
 *                              The amount will vary based on the zoom level.
 * Space                      : Resets all changes.
 * R                          : Toggle sprite rotation on/off.
 * A                          : Show and play previous animation.
 * D                          : Show and play next animation.
 * B                          : Darken the background.
 * Shift + B                  : Lighten the background.
 *----------------------------------------------------------------------------------------
 */

class FlxSpriteInpsector extends FlxState
{

	// Camera variables
	var uiCamera:FlxCamera;
	var gCamera:FlxCamera;

	// Text elements
	var statusText:FlxText;
	var offsetText:FlxText;
	var originText:FlxText;
	var widthText:FlxText;
	var heightText:FlxText;
	var helpText:FlxText;

	// Color variables
	var offsetColor:FlxColor;
	var originColor:FlxColor;
	var hitBoxColor:FlxColor;

	// layers
	var bgLayer:FlxSprite;
	var hitBoxLayer:FlxSprite;
	var helpScreen:FlxGroup;

	// debug points
	var offsetPoint:DebugPoint;
	var originPoint:DebugPoint;
	var posPoint:DebugPoint;

	// timer vars
	var keyTimer:Float;
	var keyTimerDelay:Float;

	// modifiers
	final invert:Int = -1;
	var transformModifier:Float;
	var canRotate:Bool;

	// animation vars
	var animNames:Array<String>;
	var animIndex:Int;

	/**
	* The sprite to be inspected. It represents the object being inspected and
	* can be an instance of a class that extends FlxSprite or a vanilla FlxSprite.
	*/
	var sprite = null; // Dynamic

	/**
	* It initializes and sets up the state's objects and variables.
	*/
	override public function create():Void
	{
		trace("Hello from FlxSprite Inspector!");
		
		super.create();

		/**
		* Create a new instance of the FlxSprite based class and assign it to the 'sprite' variable.
		* Replace 'DinoSprite' with the name of your custom FlxSprite class.
		*/
		sprite = new DinoSprite();

		bgColor = FlxColor.WHITE;
		offsetColor = FlxColor.GREEN;
		originColor = FlxColor.BLUE;
		hitBoxColor = FlxColor.RED;

		// Initialize the cameras
		initCameras();

		FlxG.cameras.setDefaultDrawTarget(gCamera, false);
		FlxG.cameras.setDefaultDrawTarget(uiCamera, true);

		// create the elements of the inspector
		bgLayer = new FlxSprite();
		bgLayer.makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
		bgLayer.setPosition( -FlxG.width, -FlxG.height);
		bgLayer.alpha = .1;
		add(bgLayer);

		statusText = new FlxText(0, 0, FlxG.width, "Hello from HaxeFlixel", 25);
		statusText.color = FlxColor.PURPLE;
		statusText.alignment = "center";
		statusText.cameras = [uiCamera];
		add(statusText);

		var bottomTextOffset = 35;
		offsetText = new FlxText(0, FlxG.height - bottomTextOffset, FlxG.width * .2, "offset:[0000, 0000]", 20);
		offsetText.color = offsetColor;
		offsetText.alignment = "center";
		offsetText.cameras = [uiCamera];
		add(offsetText);

		originText = new FlxText(FlxG.width * .2, FlxG.height - bottomTextOffset, FlxG.width * .2, "origin:[0000, 0000]", 20);
		originText.color = originColor;
		originText.alignment = "center";
		originText.cameras = [uiCamera];
		add(originText);

		helpText = new FlxText(FlxG.width * .4, FlxG.height - bottomTextOffset, FlxG.width * .2, "Press H for help", 15);
		helpText.color = FlxColor.BROWN;
		helpText.alignment = "center";
		helpText.cameras = [uiCamera];
		add(helpText);

		widthText = new FlxText(FlxG.width * .6, FlxG.height - bottomTextOffset, FlxG.width * .2, "width : 0000", 20);
		widthText.color = FlxColor.GREEN;
		widthText.alignment = "center";
		widthText.cameras = [uiCamera];
		add(widthText);

		heightText = new FlxText(FlxG.width * .8, FlxG.height - bottomTextOffset, FlxG.width * .2, "height : 0000", 20);
		heightText.color = FlxColor.GREEN;
		heightText.alignment = "center";
		heightText.cameras = [uiCamera];
		add(heightText);

		helpScreen = new FlxGroup();
		helpScreen.cameras = [uiCamera];
		add(helpScreen);

		helpScreen.visible = false;

		var helpBg:FlxSprite = new FlxSprite();
		helpBg.makeGraphic(FlxG.width, FlxG.height, 0x77000000);
		helpScreen.add(helpBg);

		var helpText:FlxText = new FlxText( 10, 100, 800, "Controls: \n \n H : Toggle help visibility on/off \n  \n Mouse Wheel: Zoom in/out. \n  \n Arrow Keys: Move the offset of the sprite by one pixel. \n Shift + Arrow Keys: Move the offset of the sprite by *multiple pixels. \n \n Alt + Arrow Keys: Move the origin of the sprite by one pixel. \n Alt + Shift + Arrow Keys : Move the origin of the sprite by *multiple pixels. \n \n Ctrl + Arrow Keys: Adjust the size of the sprite's hitbox by one pixel. \n Ctrl + Shift + Arrow Keys  : Adjust the size of the sprite's hitbox by *multiple pixels. \n \n Space: Resets all changes. \n \n R: Toggle sprite rotation on/off. \n \n A: Show and play previous animation. \n D: Show and play next animation. \n \n B: Darken the background. \n Shift + B: Lighten the background.\n \n \n *The amount will vary based on the zoom level.", 15);
		helpText.color = FlxColor.WHITE;
		helpScreen.add(helpText);

		FlxG.cameras.setDefaultDrawTarget(gCamera, true);
		FlxG.cameras.setDefaultDrawTarget(uiCamera, false);

		hitBoxLayer = new FlxSprite();
		hitBoxLayer.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);
		add(hitBoxLayer);

		sprite.screenCenter();
		add(sprite);

		offsetPoint = new DebugPoint(offsetColor);
		add(offsetPoint);

		originPoint = new DebugPoint(originColor);
		add(originPoint);

		// initialize variables
		keyTimer = 0;
		keyTimerDelay = .12;
		transformModifier = 1;
		canRotate = false;

		// check for existing animations
		animNames = sprite.animation.getNameList();
		animIndex = 0;

		if (animNames.length > 0)
		{
			sprite.animation.play(animNames[0]);
			statusText.text = "The sprite has " + Std.string(animNames.length) + (animNames.length == 1 ? " animation : '" : " animations. Current : '") + sprite.animation.name + "'";
		}
		else statusText.text = "The sprite does not have any animation.";

		// set the initial zoom
		gCamera.zoom = FlxG.width >= FlxG.height ? (FlxG.width / sprite.width) * .4: (FlxG.height / sprite.height) * .4;

	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// draw the inpected sprite properties
		hitBoxLayer.fill(FlxColor.TRANSPARENT);
		hitBoxLayer.drawRect(sprite.x, sprite.y, sprite.width, sprite.height, FlxColor.TRANSPARENT, {color: hitBoxColor});
		originPoint.drawCross(sprite.x + sprite.origin.x, sprite.y + sprite.origin.y, 5);
		offsetPoint.drawCross(sprite.x + sprite.offset.x, sprite.y + sprite.offset.y, 5);

		// Press 'H' to toggle the visibility of the help screen
		if (FlxG.keys.justPressed.H)
		{
			helpScreen.visible = !helpScreen.visible;
		}

		// Use mouse wheel to zoom
		if (FlxG.mouse.wheel != 0)
		{
			gCamera.zoom += (FlxG.mouse.wheel);

			// Limit the zoom within a certain range
			if (gCamera.zoom < 0) gCamera.zoom = 0;
			var maxZoom = FlxG.width >= FlxG.height ? (FlxG.width / sprite.width) * .8 : (FlxG.height / sprite.height) * .8;
			if (gCamera.zoom > maxZoom) gCamera.zoom = maxZoom;

			statusText.text = "Adjusting zoom";
		}

		// Press SPACE to reset the changes
		if (FlxG.keys.justPressed.SPACE)
		{
			sprite.angle = 0;
			canRotate = false;
			sprite.updateHitbox();

			statusText.text = "Changes have been reset";
		}

		// Press B/Shift+B to adjust the background lightness
		if (FlxG.keys.justPressed.B)
		{
			if (FlxG.keys.pressed.SHIFT) bgLayer.alpha = Math.max(0, bgLayer.alpha - 0.1);
			else bgLayer.alpha = Math.min(1, bgLayer.alpha + 0.1);

			statusText.text = "Adjusting background lightness";
		}

		// Press A to play previous animation
		if (FlxG.keys.justPressed.A)
		{
			animIndex--;

			if (animIndex < 0) animIndex = animNames.length - 1;
			sprite.animation.play(animNames[animIndex]);
			statusText.text = "Playing animation : '" + sprite.animation.name + "'";
		}

		// Press D to play next animation
		if (FlxG.keys.justPressed.D)
		{
			animIndex++;

			if (animIndex >= animNames.length) animIndex = 0;
			sprite.animation.play(animNames[animIndex]);
			statusText.text = "Playing animation : '" + sprite.animation.name + "'";
		}

		// Press R to enable/disable sprite rotation
		if (FlxG.keys.justPressed.R)
		{
			// Press Shift+R to disable and reset rotation
			if (FlxG.keys.pressed.SHIFT)
			{
				sprite.angle = 0;
				if (canRotate) canRotate = false;

				statusText.text = "Rotation has been reset.";
			}
			else
			{
				canRotate = !canRotate;
				statusText.text = canRotate ? "Rotation enabled" : "Rotation disabled";
			}
		}

		if (canRotate) sprite.angle++;

		// Listen for short press on arrow keys
		var jLeft:Int = FlxG.keys.justPressed.LEFT ? -1 : 0;
		var jRight:Int = FlxG.keys.justPressed.RIGHT ? 1 : 0;
		var jUp:Int = FlxG.keys.justPressed.UP ? -1 : 0;
		var jDown:Int = FlxG.keys.justPressed.DOWN ? 1 : 0;

		// Listen for long press on arrow keys
		var pLeft:Int = FlxG.keys.pressed.LEFT ? -1 : 0;
		var pRight:Int = FlxG.keys.pressed.RIGHT ? 1 : 0;
		var pUp:Int = FlxG.keys.pressed.UP ? -1 : 0;
		var pDown:Int = FlxG.keys.pressed.DOWN ? 1 : 0;

		// Hold SHIFT to apply the transform modifier
		transformModifier = FlxG.keys.pressed.SHIFT ? Math.round(10 / (FlxG.camera.zoom * .25)) : 1;

		// Check if either the LEFT or RIGHT arrow key has been pressed
		if (jLeft + jRight != 0)
		{
			// Reset the timer of long press
			keyTimer = 0;

			// If ALT key is pressed, adjust the sprite's origin
			if (FlxG.keys.pressed.ALT)
			{
				sprite.origin.x += (jLeft + jRight) * transformModifier * invert;
				statusText.text = "Adjusting origin.";
			}
			// If CONTROL key is pressed, adjust the sprite's width
			else if (FlxG.keys.pressed.CONTROL)
			{
				sprite.width = Math.max(0, sprite.width + (jLeft + jRight) * transformModifier);
				statusText.text = "Adjusting width.";
			}
			// If neither ALT nor CONTROL is pressed, adjust the sprite's offset
			else
			{
				sprite.offset.x += (jLeft + jRight) * transformModifier * invert;
				statusText.text = "Adjusting offset.";
			}
		}

		// Check if either the LEFT or RIGHT arrow key is being held down
		if (pLeft + pRight != 0)
		{
			// keep track of the time the key is held down
			keyTimer += elapsed;

			// Check if enough time has passed while the key is held down
			if (keyTimer < keyTimerDelay) return;

			// Use a differnt different modifier in this case
			transformModifier = FlxG.keys.pressed.SHIFT ? Math.round(10 / (FlxG.camera.zoom * .5)) : 1;

			// If ALT key is pressed, adjust the sprite's origin
			if (FlxG.keys.pressed.ALT)
			{
				sprite.origin.x += (pLeft + pRight) * transformModifier * invert;
				statusText.text = "Adjusting origin.";
			}
			// If CONTROL key is pressed, adjust the sprite's width
			else if (FlxG.keys.pressed.CONTROL)
			{
				sprite.width = Math.max(0, sprite.width + (pLeft + pRight) * transformModifier);
				statusText.text = "Adjusting width.";
			}
			// If neither ALT nor CONTROL is pressed, adjust the sprite's offset
			else
			{
				sprite.offset.x += (pLeft + pRight) * transformModifier * invert;
				statusText.text = "Adjusting offset.";
			}
		}

		// Check if either the UP or DOWN arrow key has been pressed
		if (jUp + jDown != 0)
		{
			// Reset the timer of long press
			keyTimer = 0;

			// If ALT key is pressed, adjust the sprite's origin
			if (FlxG.keys.pressed.ALT)
			{
				sprite.origin.y += (jUp + jDown) * transformModifier * invert;
				statusText.text = "Adjusting origin.";
			}
			// If CONTROL key is pressed, adjust the sprite's width
			else if (FlxG.keys.pressed.CONTROL)
			{
				sprite.height = Math.max(0, sprite.height + (jUp + jDown) * transformModifier);
				statusText.text = "Adjusting height.";
			}
			// If neither ALT nor CONTROL is pressed, adjust the sprite's offset
			else
			{
				sprite.offset.y += (jUp + jDown) * transformModifier * invert;
				statusText.text = "Adjusting offset.";
			}
		}

		// Check if either the UP or DOWN arrow key is being held down
		if (pUp + pDown != 0)
		{
			// keep track of the time the key is held down
			keyTimer += elapsed;

			// Check if enough time has passed while the key is held down
			if (keyTimer < keyTimerDelay) return;

			// Use a differnt different modifier in this case
			transformModifier = FlxG.keys.pressed.SHIFT ? Math.round(10 / (FlxG.camera.zoom * .5)) : 1;

			// If ALT key is pressed, adjust the sprite's origin
			if (FlxG.keys.pressed.ALT)
			{
				sprite.origin.y += (pUp + pDown) * transformModifier * invert;
				statusText.text = "Adjusting origin.";
			}
			// If CONTROL key is pressed, adjust the sprite's width
			else if (FlxG.keys.pressed.CONTROL)
			{
				sprite.height = Math.max(0, sprite.height + (pUp + pDown) * transformModifier);
				statusText.text = "Adjusting height.";
			}
			// If neither ALT nor CONTROL is pressed, adjust the sprite's offset
			else
			{
				sprite.offset.y += (pUp + pDown) * transformModifier * invert;
				statusText.text = "Adjusting offset.";
			}
		}

		// Update the text fields with the current sprite properties: offset, origin, width, and height.
		offsetText.text = "offset : [" + Std.string(sprite.offset.x) + ", " + Std.string(sprite.offset.y) + "]";
		originText.text = "origin : [" + Std.string(sprite.origin.x) + ", " + Std.string(sprite.origin.y) + "]";
		widthText.text = "width : " + Std.string(sprite.width);
		heightText.text = "height : " + Std.string(sprite.height);
	}

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
	}

}