package;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxTween.TweenOptions;
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
	private var spPlanet : FlxSprite;
	private var spSpaceship : FlxSprite;
	private var tw : FlxTween;


	/**
	 * Function that is called up when to state is created to set it up.
	 */
	override public function create():Void
	{
		super.create();

		Registre.lockedLevels = [false,false];

		FlxG.camera.antialiasing = true;

		Registre.CoefScale = new FlxPoint(FlxG.width / 1920, FlxG.height / 1080);

		spriteBG = new FlxSprite(0, 0);
		spriteBG.loadGraphic('assets/images/BG.jpg');
		spriteBG.scale.x = Registre.CoefScale.x;
		spriteBG.scale.y = Registre.CoefScale.y;
		spriteBG.updateHitbox();
		
		spPlanet = new FlxSprite(-256, FlxG.height/4);
		spPlanet.loadGraphic('assets/images/PlaneteGazeuse.png');

		spSpaceship = new FlxSprite(0,200);
		spSpaceship.loadGraphic('assets/images/Spaceship.png', 128, 90);
		spSpaceship.scale.x = spSpaceship.scale.y = .5;
		

		/*spriteLogo = new FlxSprite(0, 0);
		spriteLogo.loadGraphic('assets/images/logo.png');
		spriteLogo.scale.y = spriteLogo.scale.x = Registre.CoefScale.x;
		spriteLogo.x = 85 * Registre.CoefScale.x;
		spriteLogo.y = 110 * Registre.CoefScale.y;
		spriteLogo.alpha = .6;
		spriteLogo.updateHitbox();*/

		add(spriteBG);
		add(spPlanet);
		//add(spSpaceship);
		//FlxTween.circularMotion(spSpaceship, spPlanet.x+spPlanet.width/2, spPlanet.y+spPlanet.height/2, 600, 90, true, 100, true, { type:FlxTween.LOOPING } );
		//FlxTween.angle(spSpaceship, 0, -1, 10, { type:FlxTween.LOOPING });
		//tw  = FlxTween.tween(spSpaceship, { x:600, y:800 }, 2, { type:FlxTween.circularMotion(spSpaceship, 0, 1080,500,0,true,1,true)});
		
		//add(spriteLogo);


		lvlButtonGroup = new FlxTypedGroup();
		for (i in 0...Registre.lockedLevels.length)
		{
			var bt = new FlxButton((1250+i%6*80)* Registre.CoefScale.x,(850+Math.floor(i/6)*80)* Registre.CoefScale.x,null,onBtClick.bind(i));
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

		/*spriteLogo.destroy();
		spriteLogo = null;*/


		for (i in lvlButtonGroup)
		{
			i.destroy();
			i = null;
		}

		super.destroy();
	}


	private function onBtClick(i:Int):Void
	{
		Registre.level = i;
		if (!Registre.lockedLevels[i])FlxG.switchState(new PlayState());
	}

	private function gotoPlay():Void
	{
		FlxG.switchState(new PlayState());
	}
}
