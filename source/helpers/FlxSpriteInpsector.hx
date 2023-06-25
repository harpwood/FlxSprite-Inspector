package helpers;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxAngle;

import flixel.group.FlxGroup;

import flixel.text.FlxText;
import flixel.util.FlxColor;
import helpers.graphics.DebugPoint;

import flixel.FlxState;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.addons.ui.StrNameLabel;
import flixel.addons.ui.FlxUIGroup;

import openfl.geom.Rectangle;

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
	* @Deprecated Controls:
	* H						  	 : Toggle help visibility on/off
	* Mouse Wheel                : Zoom in/out.
	* Arrow Keys                 : Move the offset of the sprite by one pixel.
	* Shift + Arrow Keys         : Move the offset of the sprite by multiple pixels.
	*                              The amount will vary based on the zoom level.
	* Alt + Arrow Keys           : Move the origin of the sprite by one pixel.
	* Alt + Shift + Arrow Keys   : Move the origin of the sprite by multiple pixels.
	*                              The amount will vary based on the zoom level.
	* Ctrl + Arrow Keys          : Adjust the size of the sprite's hitbox by one pixel.
	* Ctrl + Shift + Arrow Keys  : Adjust the size of the sprite's hitbox by multiple pixels.
	* IJKL                       : Skew the sprite by one degree.
	* Shift + IJKL               : Skew the sprite by multiple degrees.
	* R                          : Toggle sprite rotation on/off.
	* Space                      : Resets all changes.
	* A                          : Show and play previous animation.
	* D                          : Show and play next animation.
	* B                          : Darken the background.
	* Shift + B                  : Lighten the background.
	* *The amount will vary based on the zoom level.
	*----------------------------------------------------------------------------------------
 */
class FlxSpriteInpsector extends FlxState
{
	// Camera variables
	var uiCamera:FlxCamera;
	var gCamera:FlxCamera;

	var ui:FlxUIGroup;

	// Buttons
	var offsetBtn:FlxUIButton;
	var originBtn:FlxUIButton;
	var hitboxBtn:FlxUIButton;
	var skewBtn:FlxUIButton;
	var angleBtn:FlxUIButton;
	var autoRotateBtn:FlxUIButton;
	var resetAngleBtn:FlxUIButton;
	var prevAnimBtn:FlxUIButton;
	var nextAnimBtn:FlxUIButton;
	var resetAllBtn:FlxUIButton;

	// Check box
	var showRadsCheckBox:FlxUICheckBox;
	var showRadsCheck:Bool;

	// Text elements
	var statusText:FlxText;
	var offsetText:FlxText;
	var originText:FlxText;
	var widthText:FlxText;
	var heightText:FlxText;
	var angleText:FlxText;
	var skewText:FlxText;
	var helpText:FlxText;
	var taskLabel:FlxText;
	var angleLabel:FlxText;
	var animationLabel:FlxText;

	// Color variables
	var offsetColor:FlxColor;
	var originColor:FlxColor;

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
	var invert:Int = 1;
	var transformModifier:Float;
	var canRotate:Bool;

	// Task vars
	var currentTask:Int;
	final OFFSET_TASK:Int = 0;
	final ORIGIN_TASK:Int = 1;
	final HITBOX_TASK:Int = 2;
	final SKEW_TASK:Int = 3;
	final ROTATE_TASK:Int = 4;

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
		
		//TODO FlxSkewedSprite

		/**
		 * !!!IMPORTANT!!!
		 * Create a new instance of the FlxSprite based class and assign it to the 'sprite' variable.
		 * Replace 'DinoSprite' with the name of your custom FlxSprite class.
		 */
		sprite = new DinoSprite();

		// Initialize the cameras
		initCameras();

		FlxG.cameras.setDefaultDrawTarget(gCamera, false);
		FlxG.cameras.setDefaultDrawTarget(uiCamera, true);

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
		createUIAreas();
		createUITexts();
		createUIIntreactiveItems();
		createHelpScreen();

		FlxG.cameras.setDefaultDrawTarget(gCamera, true);
		FlxG.cameras.setDefaultDrawTarget(uiCamera, false);

		// The layer on which the hitbox will be drawn
		hitBoxLayer = new FlxSprite();
		hitBoxLayer.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);
		add(hitBoxLayer);

		/**
		 * The sprite to be inspected.
		 * See under the 'super.create();' for details
		 */
		sprite.screenCenter();
		add(sprite);

		// Debug points that can be represented visually
		offsetPoint = new DebugPoint(offsetText.color);
		add(offsetPoint);

		originPoint = new DebugPoint(originText.color);
		add(originPoint);

		// check for existing animations
		animNames = sprite.animation.getNameList();
		animIndex = 0;

		if (animNames.length > 0)
		{
			sprite.animation.play(animNames[0]);
			statusText.text = "The sprite has "
			+ Std.string(animNames.length)
			+ (animNames.length == 1 ? " animation : '" : " animations. Current : '")
			+ sprite.animation.name
			+ "'";
		}
		else
			statusText.text = "The sprite does not have any animation.";

		// Set the initial zoom
		gCamera.zoom = FlxG.width >= FlxG.height ? (FlxG.width / sprite.width) * .4 : (FlxG.height / sprite.height) * .4;

		// Initialize variables
		currentTask = OFFSET_TASK;
		showRadsCheck = false;
		showRadsCheckBox.checked = showRadsCheck;
		keyTimer = 0;
		keyTimerDelay = .12;
		transformModifier = 1;
		canRotate = false;
	}

	/**
	* Handles sprite property changes and user input.
	*
	* @param elapsed The elapsed time since the last update.
	*/
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// update auto rotation if is enabled
		if (canRotate)
			sprite.angle++;

		/*********************************************************************************
		 * draw the inpected sprite properties
		 */
		hitBoxLayer.fill(FlxColor.TRANSPARENT);
		hitBoxLayer.drawRect(sprite.x, sprite.y, sprite.width, sprite.height, FlxColor.TRANSPARENT, {color: widthText.color});
		originPoint.drawCross(sprite.x + sprite.origin.x, sprite.y + sprite.origin.y, 5);
		offsetPoint.drawCross(sprite.x + sprite.offset.x, sprite.y + sprite.offset.y, 5);

		/*********************************************************************************
		 * User Input
		 */
		// Press 'H' to toggle the visibility of the help screen
		if (FlxG.keys.justPressed.H)
		{
			//helpScreen.visible = !helpScreen.visible;
			statusText.text = "The help section will be available in a future update.";
		}

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
		}

		// Press SPACE to reset the changes
		if (FlxG.keys.justPressed.SPACE) resetChanges();

		// Press B/Shift+B to adjust the background lightness
		if (FlxG.keys.justPressed.B)
		{
			if (FlxG.keys.pressed.SHIFT)
				bgLayer.alpha = Math.max(0, bgLayer.alpha - 0.1);
			else
				bgLayer.alpha = Math.min(1, bgLayer.alpha + 0.1);

			statusText.text = "Adjusting background lightness";
		}

		// Press A to play previous animation
		if (FlxG.keys.justPressed.A) previousAnimation();

		// Press D to play next animation
		if (FlxG.keys.justPressed.D) nextAnimation();

		// Press R to enable/disable sprite rotation
		if (FlxG.keys.justPressed.R)
		{
			// Press Shift+R to disable and reset rotation
			if (FlxG.keys.pressed.SHIFT) resetAngle();
			else toggleRotation();
		}

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
		transformModifier = FlxG.keys.pressed.SHIFT ? Math.max(Math.round(10 / (FlxG.camera.zoom * .25)), 5) : 1;

		// Hold CTRL to apply invertion
		invert = FlxG.keys.pressed.CONTROL ? -1 : 1;

		// Check if either the LEFT or RIGHT arrow key has been pressed
		if (jLeft + jRight != 0)
		{
			// Reset the timer of long press
			keyTimer = 0;

			switch (currentTask)
			{
				case 0:	//OFFSET_TASK
					sprite.offset.x += (jLeft + jRight) * transformModifier * invert;
					statusText.text = "Adjusting offset";

				case 1: //ORIGIN_TASK
					sprite.origin.x += (jLeft + jRight) * transformModifier  * invert;
					statusText.text = "Adjusting origin";

				case 2: //HITBOX_TASK
					sprite.width = Math.max(0, sprite.width + (jLeft + jRight) * transformModifier) * invert;
					statusText.text = "Adjusting width";

				case 3: //SKEW_TASK
					statusText.text = "Skew not available";
					//sprite.skew.x += (jLeft + jRight) * transformModifier * invert;
					//statusText.text = "Adjusting skew";

				case 4: //ROTATE_TASK
					if (canRotate)
					{
						canRotate = false;
						autoRotateBtn.toggled = false;
					}
					transformModifier = FlxG.keys.pressed.SHIFT ? 5 : 1;
					sprite.angle += (jLeft + jRight) * transformModifier * invert;
					statusText.text = "Adjusting angle";
			}

			statusText.text += FlxG.keys.pressed.CONTROL ? " (inverted)." : ".";
		}

		// Check if either the LEFT or RIGHT arrow key is being held down
		if (pLeft + pRight != 0)
		{
			// keep track of the time the key is held down
			keyTimer += elapsed;

			// Check if enough time has passed while the key is held down
			if (keyTimer < keyTimerDelay)
				return;

			// Use a differnt different modifier in this case
			transformModifier = FlxG.keys.pressed.SHIFT ? Math.max(Math.round(10 / (FlxG.camera.zoom * .5)), 2) : 1;

			switch (currentTask)
			{
				case 0:	//OFFSET_TASK
					sprite.offset.x += (pLeft + pRight) * transformModifier * invert;
					statusText.text = "Adjusting offset";

				case 1: //ORIGIN_TASK
					sprite.origin.x += (pLeft + pRight) * transformModifier * invert;
					statusText.text = "Adjusting origin";

				case 2: //HITBOX_TASK
					sprite.width = Math.max(0, sprite.width + (pLeft + pRight) * transformModifier) * invert;
					statusText.text = "Adjusting width";

				case 3: //SKEW_TASK
					statusText.text = "Skew not available";
					//sprite.skew.x += (pLeft + pRight) * transformModifier * invert;
					//statusText.text = "Adjusting skew";

				case 4: //ROTATE_TASK
					if (canRotate)
					{
						canRotate = false;
						autoRotateBtn.toggled = false;
					}
					transformModifier = FlxG.keys.pressed.SHIFT ? 5 : 1;
					sprite.angle += (pLeft + pRight) * transformModifier * invert;
					statusText.text = "Adjusting angle";
			}

			statusText.text += FlxG.keys.pressed.CONTROL ? " (inverted)." : ".";
		}

		// Check if either the UP or DOWN arrow key has been pressed
		if (jUp + jDown != 0)
		{
			// Reset the timer of long press
			keyTimer = 0;

			// Apply the action based on the active task
			switch (currentTask)
			{
				case 0:	//OFFSET_TASK
					sprite.offset.y += (jUp + jDown) * transformModifier * invert;
					statusText.text = "Adjusting offset.";

				case 1: //ORIGIN_TASK
					sprite.origin.y += (jUp + jDown) * transformModifier * invert;
					statusText.text = "Adjusting origin.";

				case 2: //HITBOX_TASK
					sprite.height = Math.max(0, sprite.height + (jUp + jDown) * transformModifier) * invert;
					statusText.text = "Adjusting height.";

				case 3: //SKEW_TASK
					statusText.text = "Skew not available";
					//sprite.skew.y += (jUp + jDown) * transformModifier * invert;
					//statusText.text = "Adjusting skew.";

				case 4: //ROTATE_TASK
					sprite.angle += (jUp + jDown) * transformModifier * invert;
					statusText.text = "Adjusting angle.";
			}

			statusText.text += FlxG.keys.pressed.CONTROL ? " (inverted)." : ".";
		}

		// Check if either the UP or DOWN arrow key is being held down
		if (pUp + pDown != 0)
		{
			// keep track of the time the key is held down
			keyTimer += elapsed;

			// Check if enough time has passed while the key is held down
			if (keyTimer < keyTimerDelay)
				return;

			// Use a differnt different modifier in this case
			transformModifier = FlxG.keys.pressed.SHIFT ? Math.max(Math.round(10 / (FlxG.camera.zoom * .5)), 2) : 1;
			switch (currentTask)
			{
				case 0:	//OFFSET_TASK
					sprite.offset.y += (pUp + pDown) * transformModifier * invert;
					statusText.text = "Adjusting offset";

				case 1: //ORIGIN_TASK
					sprite.origin.y += (pUp + pDown) * transformModifier * invert;
					statusText.text = "Adjusting origin";

				case 2: //HITBOX_TASK
					sprite.height = Math.max(0, sprite.height + (pUp + pDown) * transformModifier) * invert;
					statusText.text = "Adjusting height";

				case 3: //SKEW_TASK
					statusText.text = "Skew not available";
					//sprite.skew.y += (pUp + pDown) * transformModifier * invert;
					//statusText.text = "Adjusting skew";

				case 4: //ROTATE_TASK
					sprite.angle += (pUp + pDown) * transformModifier * invert;
					statusText.text = "Adjusting angle";
			}

			statusText.text += FlxG.keys.pressed.CONTROL ? " (inverted)." : ".";
		}

		/*********************************************************************************
		 * Update the text fields with the current sprite properties:
		 * offset, origin, width height, angle and skew.
		 */
		widthText.text = 'width : [${sprite.width}]';
		heightText.text = 'height : [${sprite.height}]';
		offsetText.text = 'offset : [${sprite.offset.x}, ${sprite.offset.y}]';
		originText.text = 'origin : [${sprite.origin.x}, ${sprite.origin.y}]';
		var angle:String = showRadsCheck ? Std.string(sprite.angle * FlxAngle.TO_RAD).substring(0, 6) : Std.string(sprite.angle);
		angleText.text = 'angle : ' + angle;
		//skewText.text = 'skew: [${(Std.string(sprite.skew.x)).substring(0, 6)}, ${(Std.string(sprite.skew.y)).substring(0, 6)}]';
		skewText.text = 'skew: n/a';
	}

	/****************************************************
	 * 					UI LOGIC
	 */

	/**
	* Toggles the buttons based on the given task, ensuring that only the active task button is toggled.
	*
	* @param task - The task identifier.
	*/
	function toggleButtons(task:Int):Void
	{
		currentTask = task;

		offsetBtn.toggled = currentTask == OFFSET_TASK;
		originBtn.toggled = currentTask == ORIGIN_TASK;
		hitboxBtn.toggled = currentTask == HITBOX_TASK;
		skewBtn.toggled   = currentTask == SKEW_TASK;
		angleBtn.toggled = currentTask == ROTATE_TASK;
	}

	/**
	* Toggles the rotation functionality. Enables rotation if it was disabled, and disables it if it was enabled.
	*/
	function toggleRotation():Void
	{

		canRotate = !canRotate;
		autoRotateBtn.toggled = canRotate;
		statusText.text = canRotate ? "Rotation enabled" : "Rotation disabled";
	}

	/**
	* Resets the angle of the sprite to 0 degrees and disables any ongoing rotation.
	*/
	function resetAngle():Void
	{
		sprite.angle = 0;
		resetAngleBtn.toggled = false;
		autoRotateBtn.toggled = false;
		if (canRotate)
			canRotate = false;
		statusText.text = "Rotation has been reset.";
	}

	/**
	* Toggles the display of angles between radians and degrees based on the state of the checkbox.
	*/
	function toggleShowRadians():Void
	{
		showRadsCheck = showRadsCheckBox.checked;

		statusText.text = showRadsCheck ? "Angle in radians." : "Angle in degrees.";
	}

	/**
	* Plays the previous animation in the animation list of the sprite.
	* If there are no animations, the function returns early.
	*/
	function previousAnimation():Void
	{
		prevAnimBtn.toggled = false;

		if (sprite.animation.getNameList().length == 0) return;

		animIndex--;
		if (animIndex < 0)
			animIndex = animNames.length - 1;
		sprite.animation.play(animNames[animIndex]);
		statusText.text = "Playing animation : '" + sprite.animation.name + "'";
	}

	/**
	* Plays the next animation in the animation list of the sprite.
	* If there are no animations, the function returns early.
	*/
	function nextAnimation():Void
	{
		nextAnimBtn.toggled = false;

		if (sprite.animation.getNameList().length == 0) return;

		animIndex++;
		if (animIndex >= animNames.length)
			animIndex = 0;
		sprite.animation.play(animNames[animIndex]);
		statusText.text = "Playing animation : '" + sprite.animation.name + "'";
	}

	/**
	* Resets all changes made to the sprite's properties, including angle, rotation, skew, and hitbox.
	*/
	function resetChanges():Void
	{
		resetAllBtn.toggled = false;
		sprite.angle = 0;
		canRotate = false;
		//sprite.skew.set(0, 0);
		sprite.updateHitbox();

		statusText.text = "Changes have been reset";
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
	}

	/****************************************************
	 * 					UI ELEMENTS
	 */

	/**
	* Creates UI areas for the status, bottom text, and buttons.
	*/
	function createUIAreas():Void
	{
		var uiAreasColor:FlxColor = 0xffa0c4e4;
		var statusArea:FlxUI9SliceSprite = new FlxUI9SliceSprite(0, 0, null, new Rectangle(0, 0, FlxG.width, 50));
		statusArea.color = uiAreasColor;
		ui.add(statusArea);

		var bottomTextArea:FlxUI9SliceSprite = new FlxUI9SliceSprite(0, FlxG.height - 50, null, new Rectangle(0, 0, FlxG.width, 50));
		bottomTextArea.color = uiAreasColor;
		ui.add(bottomTextArea);

		var buttonsArea:FlxUI9SliceSprite = new FlxUI9SliceSprite(10, 100, null, new Rectangle(0, 0, 150, 450));
		buttonsArea.color = uiAreasColor;
		ui.add(buttonsArea);
	}

	/**
	* Creates UI texts for displaying status, help, and various properties.
	*/
	function createUITexts():Void
	{
		// Texts
		statusText = new FlxText(0, 5, FlxG.width, "Hello from HaxeFlixel", 15);
		statusText.color = FlxColor.WHITE;
		statusText.alignment = "center";
		ui.add(statusText);

		helpText = new FlxText(FlxG.width * .4, 5 + statusText.height, FlxG.width * .2, "Press H for help", 12);
		helpText.color = FlxColor.WHITE;
		helpText.alpha = 0.7;
		helpText.alignment = "center";
		ui.add(helpText);

		var bottomTextOffset:Int = 35;
		var textSize:Int = 16;
		var spc:Int = Math.round((FlxG.width - 50) / 6);
		widthText = new FlxText(25, FlxG.height - bottomTextOffset, spc, "width : 0000", textSize);
		widthText.color = FlxColor.RED;
		widthText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.WHITE, 1);
		widthText.alignment = "left";
		ui.add(widthText);

		heightText = new FlxText(25 + spc, FlxG.height - bottomTextOffset, spc, "height : 0000", textSize);
		heightText.color = FlxColor.RED;
		heightText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.WHITE, 1);
		heightText.alignment = "left";
		ui.add(heightText);

		offsetText = new FlxText(25 + spc * 2, FlxG.height - bottomTextOffset, spc, "offset:[0000, 0000]", textSize);
		offsetText.color = FlxColor.GREEN;
		offsetText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.WHITE, 1);
		offsetText.alignment = "left";
		ui.add(offsetText);

		originText = new FlxText(25 + spc * 3, FlxG.height - bottomTextOffset, spc, "origin:[0000, 0000]", textSize);
		originText.color = FlxColor.BLUE;
		originText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.WHITE, 1);
		originText.alignment = "left";
		ui.add(originText);

		angleText = new FlxText(50 + spc * 4, FlxG.height - bottomTextOffset, spc - 10, "angle:[0.000, 0.000]", textSize);
		angleText.color = FlxColor.PURPLE;
		angleText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.WHITE, 1);
		angleText.alignment = "left";
		ui.add(angleText);

		skewText = new FlxText(25 + spc * 5, FlxG.height - bottomTextOffset, spc, "skew:[0.000, 0.000]", textSize);
		skewText.color = FlxColor.BROWN;
		skewText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.WHITE, 1);
		skewText.alignment = "left";
		ui.add(skewText);
	}

	/**
	* Creates UI interactive items for tasks, angle control, animation control, and reset functionality.
	*/
	function createUIIntreactiveItems():Void
	{
		var btnColor:FlxColor = 0xff728da3;
		var uiY:Int = 110;
		var stepY:Int = 35;

		taskLabel = new FlxText(10, uiY, 150, "TASKS", 12);
		taskLabel.color = FlxColor.WHITE;
		taskLabel.alignment = "center";
		ui.add(taskLabel);

		uiY += 20;
		offsetBtn = new FlxUIButton(20, uiY, "offset", function () {toggleButtons(OFFSET_TASK);}, true, false, btnColor);
		offsetBtn.cameras = [uiCamera];
		offsetBtn.loadGraphicSlice9(null, 130, 30, null, FlxUI9SliceSprite.TILE_NONE, -1, true);
		offsetBtn.setLabelFormat(null, 14, FlxColor.WHITE, "center");
		ui.add(offsetBtn);
		offsetBtn.toggled = true;

		uiY += stepY;
		originBtn = new FlxUIButton(20, uiY, "origin", function () {toggleButtons(ORIGIN_TASK);}, true, false, btnColor);
		originBtn.cameras = [uiCamera];
		originBtn.loadGraphicSlice9(null, 130, 30, null, FlxUI9SliceSprite.TILE_NONE, -1, true);
		originBtn.setLabelFormat(null, 14, FlxColor.WHITE, "center");
		ui.add(originBtn);

		uiY += stepY;
		hitboxBtn = new FlxUIButton(20, uiY, "hitbox", function () {toggleButtons(HITBOX_TASK);}, true, false, btnColor);
		hitboxBtn.cameras = [uiCamera];
		hitboxBtn.loadGraphicSlice9(null, 130, 30, null, FlxUI9SliceSprite.TILE_NONE, -1, true);
		hitboxBtn.setLabelFormat(null, 14, FlxColor.WHITE, "center");
		ui.add(hitboxBtn);

		uiY += stepY;
		angleBtn = new FlxUIButton(20, uiY, "angle", function () {toggleButtons(ROTATE_TASK);}, true, false, btnColor);
		angleBtn.cameras = [uiCamera];
		angleBtn.loadGraphicSlice9(null, 130, 30, null, FlxUI9SliceSprite.TILE_NONE, -1, true);
		angleBtn.setLabelFormat(null, 14, FlxColor.WHITE, "center");
		ui.add(angleBtn);

		uiY += stepY;
		skewBtn = new FlxUIButton(20, uiY, "skew", function () {toggleButtons(SKEW_TASK);}, true, false, btnColor);
		skewBtn.cameras = [uiCamera];
		skewBtn.loadGraphicSlice9(null, 130, 30, null, FlxUI9SliceSprite.TILE_NONE, -1, true);
		skewBtn.setLabelFormat(null, 14, FlxColor.WHITE, "center");
		ui.add(skewBtn);

		uiY += stepY + 5;
		angleLabel = new FlxText(10, uiY, 150, "ANGLE", 12);
		angleLabel.color = FlxColor.WHITE;
		angleLabel.alignment = "center";
		ui.add(angleLabel);

		uiY += stepY - 15;
		autoRotateBtn = new FlxUIButton(20, uiY, "auto rotate", toggleRotation, true, false, btnColor);
		autoRotateBtn.cameras = [uiCamera];
		autoRotateBtn.loadGraphicSlice9(null, 130, 30, null, FlxUI9SliceSprite.TILE_NONE, -1, true);
		autoRotateBtn.setLabelFormat(null, 14, FlxColor.WHITE, "center");
		ui.add(autoRotateBtn);

		uiY += stepY;
		resetAngleBtn = new FlxUIButton(20, uiY, "reset angle", resetAngle, true, false, btnColor);
		resetAngleBtn.cameras = [uiCamera];
		resetAngleBtn.loadGraphicSlice9(null, 130, 30, null, FlxUI9SliceSprite.TILE_NONE, -1, true);
		resetAngleBtn.setLabelFormat(null, 14, FlxColor.WHITE, "center");
		ui.add(resetAngleBtn);

		uiY += stepY;
		showRadsCheckBox = new FlxUICheckBox(20, uiY, null, null, "show radians", 130, null, toggleShowRadians);
		showRadsCheckBox.cameras = [uiCamera];
		showRadsCheckBox.button.setLabelFormat(null, 12, FlxColor.WHITE, "center");
		showRadsCheckBox.button.x -= 7;
		showRadsCheckBox.button.y -= 4;
		ui.add(showRadsCheckBox);

		uiY += stepY - 10;
		animationLabel = new FlxText(10, uiY, 150, "ANIMATION", 12);
		animationLabel.color = FlxColor.WHITE;
		animationLabel.alignment = "center";
		ui.add(animationLabel);

		uiY += stepY - 15;
		prevAnimBtn = new FlxUIButton(20, uiY, "prev", previousAnimation, true, false, btnColor);
		prevAnimBtn.cameras = [uiCamera];
		prevAnimBtn.loadGraphicSlice9(null, 60, 30, null, FlxUI9SliceSprite.TILE_NONE, -1, true);
		prevAnimBtn.setLabelFormat(null, 14, FlxColor.WHITE, "center");
		ui.add(prevAnimBtn);
		nextAnimBtn = new FlxUIButton(90, uiY, "next", nextAnimation, true, false, btnColor);
		nextAnimBtn.cameras = [uiCamera];
		nextAnimBtn.loadGraphicSlice9(null, 60, 30, null, FlxUI9SliceSprite.TILE_NONE, -1, true);
		nextAnimBtn.setLabelFormat(null, 14, FlxColor.WHITE, "center");
		ui.add(nextAnimBtn);

		uiY += stepY + 10;
		resetAllBtn = new FlxUIButton(20, uiY, "reset all changes", resetChanges, true, false, btnColor);
		resetAllBtn.cameras = [uiCamera];
		resetAllBtn.loadGraphicSlice9(null, 130, 40, null, FlxUI9SliceSprite.TILE_NONE, -1, true);
		resetAllBtn.setLabelFormat(null, 14, FlxColor.WHITE, "center");
		ui.add(resetAllBtn);
	}

	/****************************************************
	 * 					HELP SCREEN
	 */

	/**
	* Creates a help screen with a background and text.
	*/
	function createHelpScreen():Void
	{
		helpScreen = new FlxGroup();
		helpScreen.cameras = [uiCamera];
		add(helpScreen);

		helpScreen.visible = false;

		var helpBg:FlxSprite = new FlxSprite();
		helpBg.makeGraphic(FlxG.width, FlxG.height, 0x77000000);
		helpScreen.add(helpBg);

		var helpText:FlxText = new FlxText(10, 100, 800, "The help section is in work in progress state.", 15);
		helpText.color = FlxColor.WHITE;
		helpScreen.add(helpText);
	}
}