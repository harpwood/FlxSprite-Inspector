package inspector.ui;

import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUIGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import inspector.ui.components.UIWidget;
import flixel.addons.ui.FlxInputText;
import inspector.ui.components.TextInput;
import inspector.core.ColorMatrixFilterInspector;

/**
 * ...
 * @author Harpwood Studio
 * https://harpwood.itch.io/
 */

class ColorMatrixFilterUI extends FlxUIGroup
{

	public var colorMatrixFilter: Array<Float>;
	
	var widget:UIWidget;
	var inspector:ColorMatrixFilterInspector;
	
	// Red Channel TextInputs
	var tRR:TextInput;
	var tRG:TextInput;
	var tRB:TextInput;
	var tRA:TextInput;
	var tRO:TextInput;

	// Green Channel TextInputs
	var tGR:TextInput;
	var tGG:TextInput;
	var tGB:TextInput;
	var tGA:TextInput;
	var tGO:TextInput;

	// Blue Channel TextInputs
	var tBR:TextInput;
	var tBG:TextInput;
	var tBB:TextInput;
	var tBA:TextInput;
	var tBO:TextInput;

	// Alpha Channel TextInputs
	var tAR:TextInput;
	var tAG:TextInput;
	var tAB:TextInput;
	var tAA:TextInput;
	var tAO:TextInput;

	// Red Channel values
	var vRR:Float = 1.0;
	var vRG:Float = 0.0;
	var vRB:Float = 0.0;
	var vRA:Float = 0.0;
	var vRO:Float = 0.0;

	// Green Channel values
	var vGR:Float = 0.0;
	var vGG:Float = 1.0;
	var vGB:Float = 0.0;
	var vGA:Float = 0.0;
	var vGO:Float = 0.0;

	// Blue Channel values
	var vBR:Float = 0.0;
	var vBG:Float = 0.0;
	var vBB:Float = 1.0;
	var vBA:Float = 0.0;
	var vBO:Float = 0.0;

	// Alpha Channel values
	var vAR:Float = 0.0;
	var vAG:Float = 0.0;
	var vAB:Float = 0.0;
	var vAA:Float = 1.0;
	var vAO:Float = 0.0;

	// Buttons
	var resetBtn:FlxUIButton;
	var resetAndApplyBtn:FlxUIButton;
	var applyBtn:FlxUIButton;


	public function new(inspector:ColorMatrixFilterInspector, X:Float=0, Y:Float=0)
	{
		super(X, Y);
		
		this.inspector = inspector;
		
		widget = new UIWidget(0, 0, 300, 220);
		widget.setLabelText("Color Matrix Filter");
		add(widget);

		addCMFLabels();
		addCMFTextInputs();
		addCMFButtons();
	}
	
	/*************************************************************************************
	 * 									LABELS
	 */
	
	function addCMFLabels():Void
	{
		var uiX = 45;
		var uiY = 35;

		var labels:Array<String> = ["R", "G", "B", "A", "O"];

		for (i in 0...labels.length)
		{
			var label:FlxText = new FlxText(uiX, uiY, 30, labels[i], 15);
			label.alignment = "center";
			widget.add(label);
			widget.components.push(label);
			uiX += 48 + i;
		}

		uiX = 9;
		for (i in 0...labels.length - 1)
		{
			uiY += 28;
			var label:FlxText = new FlxText(uiX, uiY, 15, labels[i], 15);
			label.alignment = "center";
			widget.add(label);
			widget.components.push(label);
		}
	}

	
	/*************************************************************************************
	 * 									TEXT INPUTS
	 */

	function addCMFTextInputs():Void
	{
		/*********************************************************************************
		 * 								RED CHANNEL
		 */

		var uiX = 17;
		var uiY = 32;

		// RED CHANNEL: RED
		tRR = new TextInput(uiX, uiY, 46, 30, ~/[^0-9.-]*/g, (input:String, key:String) ->
		{
			input = sanitizeInput(input, tRR);

			if (key == FlxInputText.ENTER_ACTION)
			{
				tRR.inputText.text = Std.string(vRR);
				tRR.inputText.hasFocus = false;
			}

			vRR = (input == "" || input == "-") ? 0 : Std.parseFloat(input);

			if (vRR < -255)
			{
				vRR = -255;
				tRR.inputText.text = "-255";
			}
			if (vRR > 255)
			{
				vRR = 255;
				tRR.inputText.text = "255";
			}
		}, '${vRR}', () -> { tRR.inputText.text = Std.string(vRR); });
		widget.add(tRR);
		widget.components.push(tRR);

		uiX += 25;

		// RED CHANNEL: GREEN
		tRG = new TextInput(uiX, uiY, 46, 30, ~/[^0-9.-]*/g, (input:String, key:String) ->
		{
			input = sanitizeInput(input, tRG);

			if (key == FlxInputText.ENTER_ACTION)
			{
				tRG.inputText.text = Std.string(vRG);
				tRG.inputText.hasFocus = false;
			}

			vRG = (input == "" || input == "-") ? 0 : Std.parseFloat(input);

			if (vRG < -255)
			{
				vRG = -255;
				tRG.inputText.text = "-255";
			}
			if (vRG > 255)
			{
				vRG = 255;
				tRG.inputText.text = "255";
			}
		}, '${vRG}', () -> { tRG.inputText.text = Std.string(vRG); });
		widget.add(tRG);
		widget.components.push(tRG);

		uiX += 25;

		// RED CHANNEL: BLUE
		tRB = new TextInput(uiX, uiY, 46, 30, ~/[^0-9.-]*/g, (input:String, key:String) ->
		{
			input = sanitizeInput(input, tRB);

			if (key == FlxInputText.ENTER_ACTION)
			{
				tRB.inputText.text = Std.string(vRB);
				tRB.inputText.hasFocus = false;
			}

			vRB = (input == "" || input == "-") ? 0 : Std.parseFloat(input);

			if (vRB < -255)
			{
				vRB = -255;
				tRB.inputText.text = "-255";
			}
			if (vRB > 255)
			{
				vRB = 255;
				tRB.inputText.text = "255";
			}
		}, '${vRB}', () -> { tRB.inputText.text = Std.string(vRB); });
		widget.add(tRB);
		widget.components.push(tRB);

		uiX += 25;

		// RED CHANNEL: ALPHA
		tRA = new TextInput(uiX, uiY, 46, 30, ~/[^0-9.-]*/g, (input:String, key:String) ->
		{
			input = sanitizeInput(input, tRA);

			if (key == FlxInputText.ENTER_ACTION)
			{
				tRA.inputText.text = Std.string(vRA);
				tRA.inputText.hasFocus = false;
			}

			vRA = (input == "" || input == "-") ? 0 : Std.parseFloat(input);

			if (vRA < -255)
			{
				vRA = -255;
				tRA.inputText.text = "-255";
			}
			if (vRA > 255)
			{
				vRA = 255;
				tRA.inputText.text = "255";
			}
		}, '${vRA}', () -> { tRA.inputText.text = Std.string(vRA); });
		widget.add(tRA);
		widget.components.push(tRA);

		uiX += 25;

		// RED CHANNEL: OFFSET
		tRO = new TextInput(uiX, uiY, 46, 30, ~/[^0-9.-]*/g, (input:String, key:String) ->
		{
			input = sanitizeInput(input, tRO);

			if (key == FlxInputText.ENTER_ACTION)
			{
				tRO.inputText.text = Std.string(vRO);
				tRO.inputText.hasFocus = false;
			}
			
			vRO = (input == "" || input == "-") ? 0 : Std.parseFloat(input);

			if (vRO < -255)
			{
				vRO = -255;
				tRO.inputText.text = "-255";
			}
			if (vRO > 255)
			{
				vRO = 255;
				tRO.inputText.text = "255";
			}
		}, '${vRO}', () -> { tRO.inputText.text = Std.string(vRO); });
		widget.add(tRO);
		widget.components.push(tRO);

		uiX += 25;

		/*********************************************************************************
		 * 								GREEN CHANNEL
		 */

		uiX = 17;
		uiY += 14;

		// GREEN CHANNEL: RED
		tGR = new TextInput(uiX, uiY, 46, 30, ~/[^0-9.-]*/g, (input:String, key:String) ->
		{
			input = sanitizeInput(input, tGR);

			if (key == FlxInputText.ENTER_ACTION)
			{
				tGR.inputText.text = Std.string(vGR);
				tGR.inputText.hasFocus = false;
			}

			vGR = (input == "" || input == "-") ? 0 : Std.parseFloat(input);

			if (vGR < -255)
			{
				vGR = -255;
				tGR.inputText.text = "-255";
			}
			if (vGR > 255)
			{
				vGR = 255;
				tGR.inputText.text = "255";
			}
		}, '${vGR}', () -> { tGR.inputText.text = Std.string(vGR); });
		widget.add(tGR);
		widget.components.push(tGR);

		uiX += 25;

		// GREEN CHANNEL: GREEN
		tGG = new TextInput(uiX, uiY, 46, 30, ~/[^0-9.-]*/g, (input:String, key:String) ->
		{
			input = sanitizeInput(input, tGG);

			if (key == FlxInputText.ENTER_ACTION)
			{
				tGG.inputText.text = Std.string(vGG);
				tGG.inputText.hasFocus = false;
			}
			
			vGG = (input == "" || input == "-") ? 0 : Std.parseFloat(input);

			if (vGG < -255)
			{
				vGG = -255;
				tGG.inputText.text = "-255";
			}
			if (vGG > 255)
			{
				vGG = 255;
				tGG.inputText.text = "255";
			}
		}, '${vGG}', () -> { tGG.inputText.text = Std.string(vGG); });
		widget.add(tGG);
		widget.components.push(tGG);

		uiX += 25;

		// GREEN CHANNEL: BLUE
		tGB = new TextInput(uiX, uiY, 46, 30, ~/[^0-9.-]*/g, (input:String, key:String) ->
		{
			input = sanitizeInput(input, tGB);

			if (key == FlxInputText.ENTER_ACTION)
			{
				tGB.inputText.text = Std.string(vGB);
				tGB.inputText.hasFocus = false;
			}

			vGB = (input == "" || input == "-") ? 0 : Std.parseFloat(input);

			if (vGB < -255)
			{
				vGB = -255;
				tGB.inputText.text = "-255";
			}
			if (vGB > 255)
			{
				vGB = 255;
				tGB.inputText.text = "255";
			}
		}, '${vGB}', () -> { tGB.inputText.text = Std.string(vGB); });
		widget.add(tGB);
		widget.components.push(tGB);

		uiX += 25;

		// GREEN CHANNEL: ALPHA
		tGA = new TextInput(uiX, uiY, 46, 30, ~/[^0-9.-]*/g, (input:String, key:String) ->
		{
			input = sanitizeInput(input, tGA);

			if (key == FlxInputText.ENTER_ACTION)
			{
				tGA.inputText.text = Std.string(vGA);
				tGA.inputText.hasFocus = false;
			}
			
			vGA = (input == "" || input == "-") ? 0 : Std.parseFloat(input);

			if (vGA < -255)
			{
				vGA = -255;
				tGA.inputText.text = "-255";
			}
			if (vGA > 255)
			{
				vGA = 255;
				tGA.inputText.text = "255";
			}
		}, '${vGA}', () -> { tGA.inputText.text = Std.string(vGA); });
		widget.add(tGA);
		widget.components.push(tGA);

		uiX += 25;

		// GREEN CHANNEL: OFFSET
		tGO = new TextInput(uiX, uiY, 46, 30, ~/[^0-9.-]*/g, (input:String, key:String) ->
		{
			input = sanitizeInput(input, tGO);

			if (key == FlxInputText.ENTER_ACTION)
			{
				tGO.inputText.text = Std.string(vGO);
				tGO.inputText.hasFocus = false;
			}
			
			vGO = (input == "" || input == "-") ? 0 : Std.parseFloat(input);

			if (vGO < -255)
			{
				vGO = -255;
				tGO.inputText.text = "-255";
			}
			if (vGO > 255)
			{
				vGO = 255;
				tGO.inputText.text = "255";
			}
		}, '${vGO}', () -> { tGO.inputText.text = Std.string(vGO); });
		widget.add(tGO);
		widget.components.push(tGO);

		uiX += 25;

		/*********************************************************************************
		 * 								BLUE CHANNEL
		 */

		uiX = 17;
		uiY += 14;

		// BLUE CHANNEL: RED
		tBR = new TextInput(uiX, uiY, 46, 30, ~/[^0-9.-]*/g, (input:String, key:String) ->
		{
			input = sanitizeInput(input, tBR);

			if (key == FlxInputText.ENTER_ACTION)
			{
				tBR.inputText.text = Std.string(vBR);
				tBR.inputText.hasFocus = false;
			}
			
			vBR = (input == "" || input == "-") ? 0 : Std.parseFloat(input);

			if (vBR < -255)
			{
				vBR = -255;
				tBR.inputText.text = "-255";
			}
			if (vBR > 255)
			{
				vBR = 255;
				tBR.inputText.text = "255";
			}
		}, '${vBR}', () -> { tBR.inputText.text = Std.string(vBR); });
		widget.add(tBR);
		widget.components.push(tBR);

		uiX += 25;

		// BLUE CHANNEL: GREEN
		tBG = new TextInput(uiX, uiY, 46, 30, ~/[^0-9.-]*/g, (input:String, key:String) ->
		{
			input = sanitizeInput(input, tBG);

			if (key == FlxInputText.ENTER_ACTION)
			{
				tBG.inputText.text = Std.string(vBG);
				tBG.inputText.hasFocus = false;
			}
			
			vBG = (input == "" || input == "-") ? 0 : Std.parseFloat(input);

			if (vBG < -255)
			{
				vBG = -255;
				tBG.inputText.text = "-255";
			}
			if (vBG > 255)
			{
				vBG = 255;
				tBG.inputText.text = "255";
			}
		}, '${vBG}', () -> { tBG.inputText.text = Std.string(vBG); });
		widget.add(tBG);
		widget.components.push(tBG);

		uiX += 25;

		// BLUE CHANNEL: BLUE
		tBB = new TextInput(uiX, uiY, 46, 30, ~/[^0-9.-]*/g, (input:String, key:String) ->
		{
			input = sanitizeInput(input, tBB);

			if (key == FlxInputText.ENTER_ACTION)
			{
				tBB.inputText.text = Std.string(vBB);
				tBB.inputText.hasFocus = false;
			}

			vBB = (input == "" || input == "-") ? 0 : Std.parseFloat(input);

			if (vBB < -255)
			{
				vBB = -255;
				tBB.inputText.text = "-255";
			}
			if (vBB > 255)
			{
				vBB = 255;
				tBB.inputText.text = "255";
			}
		}, '${vBB}', () -> { tBB.inputText.text = Std.string(vBB); });
		widget.add(tBB);
		widget.components.push(tBB);

		uiX += 25;

		// BLUE CHANNEL: ALPHA
		tBA = new TextInput(uiX, uiY, 46, 30, ~/[^0-9.-]*/g, (input:String, key:String) ->
		{
			input = sanitizeInput(input, tBA);

			if (key == FlxInputText.ENTER_ACTION)
			{
				tBA.inputText.text = Std.string(vBA);
				tBA.inputText.hasFocus = false;
			}
			
			vBA = (input == "" || input == "-") ? 0 : Std.parseFloat(input);

			if (vBA < -255)
			{
				vBA = -255;
				tBA.inputText.text = "-255";
			}
			if (vBA > 255)
			{
				vBA = 255;
				tBA.inputText.text = "255";
			}
		}, '${vBA}', () -> { tBA.inputText.text = Std.string(vBA); });
		widget.add(tBA);
		widget.components.push(tBA);

		uiX += 25;

		// BLUE CHANNEL: OFFSET
		tBO = new TextInput(uiX, uiY, 46, 30, ~/[^0-9.-]*/g, (input:String, key:String) ->
		{
			input = sanitizeInput(input, tBO);

			if (key == FlxInputText.ENTER_ACTION)
			{
				tBO.inputText.text = Std.string(vBO);
				tBO.inputText.hasFocus = false;
			}
			
			vBO = (input == "" || input == "-") ? 0 : Std.parseFloat(input);

			if (vBO < -255)
			{
				vBO = -255;
				tBO.inputText.text = "-255";
			}
			if (vBO > 255)
			{
				vBO = 255;
				tBO.inputText.text = "255";
			}
		}, '${vBO}', () -> { tBO.inputText.text = Std.string(vBO); });
		widget.add(tBO);
		widget.components.push(tBO);

		uiX += 25;

		/*********************************************************************************
		 * 								ALPHA CHANNEL
		 */

		uiX = 17;
		uiY += 14;

		// ALPHA CHANNEL: RED
		tAR = new TextInput(uiX, uiY, 46, 30, ~/[^0-9.-]*/g, (input:String, key:String) ->
		{
			input = sanitizeInput(input, tAR);

			if (key == FlxInputText.ENTER_ACTION)
			{
				tAR.inputText.text = Std.string(vAR);
				tAR.inputText.hasFocus = false;
			}
			
			vAR = (input == "" || input == "-") ? 0 : Std.parseFloat(input);

			if (vAR < -255)
			{
				vAR = -255;
				tAR.inputText.text = "-255";
			}
			if (vAR > 255)
			{
				vAR = 255;
				tAR.inputText.text = "255";
			}
		}, '${vAR}', () -> { tAR.inputText.text = Std.string(vAR); });
		widget.add(tAR);
		widget.components.push(tAR);

		uiX += 25;

		// ALPHA CHANNEL: GREEN
		tAG = new TextInput(uiX, uiY, 46, 30, ~/[^0-9.-]*/g, (input:String, key:String) ->
		{
			input = sanitizeInput(input, tAG);
			
			if (key == FlxInputText.ENTER_ACTION)
			{
				tAG.inputText.text = Std.string(vAG);
				tAG.inputText.hasFocus = false;
			}

			vAG = (input == "" || input == "-") ? 0 : Std.parseFloat(input);

			if (vAG < -255)
			{
				vAG = -255;
				tAG.inputText.text = "-255";
			}
			if (vAG > 255)
			{
				vAG = 255;
				tAG.inputText.text = "255";
			}
		}, '${vAG}', () -> { tAG.inputText.text = Std.string(vAG); });
		widget.add(tAG);
		widget.components.push(tAG);

		uiX += 25;

		// ALPHA CHANNEL: BLUE
		tAB = new TextInput(uiX, uiY, 46, 30, ~/[^0-9.-]*/g, (input:String, key:String) ->
		{
			input = sanitizeInput(input, tAB);

			if (key == FlxInputText.ENTER_ACTION)
			{
				tAB.inputText.text = Std.string(vAB);
				tAB.inputText.hasFocus = false;
			}
			
			vAB = (input == "" || input == "-") ? 0 : Std.parseFloat(input);

			if (vAB < -255)
			{
				vAB = -255;
				tAB.inputText.text = "-255";
			}
			if (vAB > 255)
			{
				vAB = 255;
				tAB.inputText.text = "255";
			}
		}, '${vAB}', () -> { tAB.inputText.text = Std.string(vAB); });
		widget.add(tAB);
		widget.components.push(tAB);

		uiX += 25;

		// ALPHA CHANNEL: ALPHA
		tAA = new TextInput(uiX, uiY, 46, 30, ~/[^0-9.-]*/g, (input:String, key:String) ->
		{
			input = sanitizeInput(input, tAA);

			if (key == FlxInputText.ENTER_ACTION)
			{
				tAA.inputText.text = Std.string(vAA);
				tAA.inputText.hasFocus = false;
			}
			
			vAA = (input == "" || input == "-") ? 0 : Std.parseFloat(input);

			if (vAA < -255)
			{
				vAA = -255;
				tAA.inputText.text = "-255";
			}
			if (vAA > 255)
			{
				vAA = 255;
				tAA.inputText.text = "255";
			}
		}, '${vAA}', () -> { tAA.inputText.text = Std.string(vAA); });
		widget.add(tAA);
		widget.components.push(tAA);

		uiX += 25;

		// ALPHA CHANNEL: OFFSET
		tAO = new TextInput(uiX, uiY, 46, 30, ~/[^0-9.-]*/g, (input:String, key:String) ->
		{
			input = sanitizeInput(input, tAO);

			if (key == FlxInputText.ENTER_ACTION)
			{
				tAO.inputText.text = Std.string(vAO);
				tAO.inputText.hasFocus = false;
			}
			
			vAO = (input == "" || input == "-") ? 0 : Std.parseFloat(input);

			if (vAO < -255)
			{
				vAO = -255;
				tAO.inputText.text = "-255";
			}
			if (vAO > 255)
			{
				vAO = 255;
				tAO.inputText.text = "255";
			}
		}, '${vAO}', () -> { tAO.inputText.text = Std.string(vAO); });
		widget.add(tAO);
		widget.components.push(tAO);
	}
	
	function sanitizeInput(input:String, ti:TextInput):String
	{
		if (input.length > 1 && input.charAt(0) == "0")
		{
			input = input.substring(1, input.length);
			ti.inputText.text = input;
			ti.inputText.caretIndex--;
			return input;
		}
		
		var countDots:Int = 0;
		for (j in 0...input.length)
		{
			if (input.charAt(j) == ".") countDots++;
			if (countDots > 1)
			{
				input = input.substring(0, j);
				ti.inputText.text = input;
				ti.inputText.caretIndex--;
				return input;
			}

			if (input.charAt(j) == "-" && j != 0)
			{
				input = input.substring(0, j);
				ti.inputText.text = input;
				ti.inputText.caretIndex--;
				return input;
			}
		}
		return input;
	}
	
	/*************************************************************************************
	 * 									BUTTONS
	 */

	function addCMFButtons():Void
	{
		var uiY = 180;

		resetBtn = new FlxUIButton(20, uiY, "reset", resetCMF, true, false, 0xff728da3);
		resetBtn.loadGraphicSlice9(null, 60, 30, null, FlxUI9SliceSprite.TILE_NONE, -1, true);
		resetBtn.setLabelFormat(null, 14, FlxColor.WHITE, "center");
		widget.add(resetBtn);
		widget.components.push(resetBtn);
		
		resetAndApplyBtn = new FlxUIButton(85, uiY, "reset & apply", resetAndApplyCMF, true, false, 0xff728da3);
		resetAndApplyBtn.loadGraphicSlice9(null, 130, 30, null, FlxUI9SliceSprite.TILE_NONE, -1, true);
		resetAndApplyBtn.setLabelFormat(null, 14, FlxColor.WHITE, "center");
		widget.add(resetAndApplyBtn);
		widget.components.push(resetAndApplyBtn);

		applyBtn = new FlxUIButton(220, uiY, "apply", applyCMF, true, false, 0xff728da3);
		applyBtn.loadGraphicSlice9(null, 60, 30, null, FlxUI9SliceSprite.TILE_NONE, -1, true);
		applyBtn.setLabelFormat(null, 14, FlxColor.WHITE, "center");
		widget.add(applyBtn);
		widget.components.push(applyBtn);
	}

	function resetCMF():Void
	{
		
		resetBtn.toggled = false;

		// Red Channel values
		vRR = 1.0;
		vRG = 0.0;
		vRB = 0.0;
		vRA = 0.0;
		vRO = 0.0;

		// Green Channel values
		vGR = 0.0;
		vGG = 1.0;
		vGB = 0.0;
		vGA = 0.0;
		vGO = 0.0;

		// Blue Channel values
		vBR = 0.0;
		vBG = 0.0;
		vBB = 1.0;
		vBA = 0.0;
		vBO = 0.0;

		// Alpha Channel values
		vAR = 0.0;
		vAG = 0.0;
		vAB = 0.0;
		vAA = 1.0;
		vAO = 0.0;

		// Red Channel TextInputs
		tRR.inputText.text = Std.string(vRR);
		tRG.inputText.text = Std.string(vRG);
		tRB.inputText.text = Std.string(vRB);
		tRA.inputText.text = Std.string(vRA);
		tRO.inputText.text = Std.string(vRO);

		// Green Channel TextInputs
		tGR.inputText.text = Std.string(vGR);
		tGG.inputText.text = Std.string(vGG);
		tGB.inputText.text = Std.string(vGB);
		tGA.inputText.text = Std.string(vGA);
		tGO.inputText.text = Std.string(vGO);

		// Blue Channel TextInputs
		tBR.inputText.text = Std.string(vBR);
		tBG.inputText.text = Std.string(vBG);
		tBB.inputText.text = Std.string(vBB);
		tBA.inputText.text = Std.string(vBA);
		tBO.inputText.text = Std.string(vBO);

		// Alpha Channel TextInputs
		tAR.inputText.text = Std.string(vAR);
		tAG.inputText.text = Std.string(vAG);
		tAB.inputText.text = Std.string(vAB);
		tAA.inputText.text = Std.string(vAA);
		tAO.inputText.text = Std.string(vAO);
		
		inspector.reset();
	}
	
	function applyCMF():Void
	{
		
		applyBtn.toggled = false;
		
		colorMatrixFilter = [
								vRR, vRG, vRB, vRA, vRO,
								vGR, vGG, vGB, vGA, vGO,
								vBR, vBG, vBB, vBA, vBO,
								vAR, vAG, vAB, vAA, vAO
							];
							
		inspector.updateColorMatrixFilter(colorMatrixFilter);
	}
	function resetAndApplyCMF():Void
	{
		resetAndApplyBtn.toggled = false;
		inspector.reset();
		applyCMF();
	}

}
