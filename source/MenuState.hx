package;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.FlxG;
import openfl.Assets;
import flixel.group.FlxTypedGroup;
import flixel.system.debug.FlxDebugger;
import flixel.util.FlxColor;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	private var spriteBG : FlxSprite;
	private var spriteLogo : FlxSprite;
	private var startText :FlxText;
	private var start : FlxButton;
	private var lvlButtonGroup : FlxTypedGroup<FlxButton>;


	/**
	 * Function that is called up when to state is created to set it up.
	 */
	override public function create():Void
	{
		super.create();

		#if mobile
		Registre.mobileZoom = 2;
		#else
		Registre.mobileZoom = 1;
		#end

		FlxG.debugger.visible = true;

		Registre.lockedLevels = [false,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true];

		FlxG.camera.antialiasing = true;

		Registre.CoefScale = new FlxPoint(FlxG.width / 1920, FlxG.height / 1080);

		spriteBG = new FlxSprite(0, 0);
		spriteBG.loadGraphic('assets/images/BG.png');
		spriteBG.scale.x = Registre.CoefScale.x;
		spriteBG.scale.y = Registre.CoefScale.y;
		spriteBG.updateHitbox();

		spriteLogo = new FlxSprite(0, 0);
		spriteLogo.loadGraphic('assets/images/logo.png');
		spriteLogo.scale.y = spriteLogo.scale.x = Registre.CoefScale.x;
		spriteLogo.x = 85 * Registre.CoefScale.x;
		spriteLogo.y = 110 * Registre.CoefScale.y;
		spriteLogo.alpha = .6;
		spriteLogo.updateHitbox();

		start = new FlxButton(120 * Registre.CoefScale.x, 835 * Registre.CoefScale.x,null,gotoPlay);
		start.width = 480 * Registre.CoefScale.x*Registre.mobileZoom;
		start.height = 60 * Registre.CoefScale.x*Registre.mobileZoom;
		start.alpha = 0;
		start.kill();

		startText = new FlxText(120 * Registre.CoefScale.x, 835 * Registre.CoefScale.x, 480 * Registre.CoefScale.x,"START"); // x, y, width
		startText.setFormat("assets/data/zoinks.ttf", Std.int(60 * Registre.CoefScale.x), 0x000000, "center");
		startText.alpha = .6;
		startText.kill();

		add(spriteBG);
		add(spriteLogo);
		add(start);
		add(startText);

		lvlButtonGroup = new FlxTypedGroup();
		for (i in 0...24)
		{
			var bt = new FlxButton((120+i%6*80)* Registre.CoefScale.x,(450+Math.floor(i/6)*80)* Registre.CoefScale.x,null,onBtClick.bind(i));
			bt.loadGraphic('assets/images/button.png');
			bt.scale.x = bt.scale.y = Registre.CoefScale.x;
			bt.updateHitbox();

			if (Registre.lockedLevels[i]) bt.alpha = .3;
			else bt.alpha = .6;

			lvlButtonGroup.add(bt);
		}

		add(lvlButtonGroup);
		Registre.level = 1;
	}


	override public function destroy():Void
	{
		spriteBG.destroy();
		spriteBG = null;

		spriteLogo.destroy();
		spriteLogo = null;

		start.destroy();
		start = null;

		startText.destroy();
		startText = null;

		for (i in lvlButtonGroup)
		{
			i.destroy();
			i = null;
		}

		super.destroy();
	}


	private function onBtClick(i:Int):Void
	{
		Registre.level = i + 1;

		for (j in 0...lvlButtonGroup.members.length)
		{
			if (j == i) lvlButtonGroup.members[j].loadGraphic('assets/images/button02.png');
			else lvlButtonGroup.members[j].loadGraphic('assets/images/button.png');
		}
		if (Assets.exists("assets/data/lvl" + Registre.level + "zlib.tmx"))
		{
			start.revive();
			startText.revive();
			startText.text = "START";
		}

		else
		{
			start.kill();
			startText.revive();
			startText.text = "LOCKED";
		}
	}

	private function gotoPlay():Void
	{
		FlxG.switchState(new PlayState());
	}
}
