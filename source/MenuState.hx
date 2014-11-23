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

		FlxG.camera.antialiasing = true;

		Registre.CoefScale = new FlxPoint(FlxG.width / 1920, FlxG.height / 1080);

		//loading sounds to avoid slowdowd at first lvl
		FlxG.sound.load("assets/sound/musique_beat.ogg");
		FlxG.sound.load("assets/sound/musique_butterfly.ogg");
		FlxG.sound.load("assets/sound/musique_glass.ogg");
		FlxG.sound.load("assets/sound/musique_glassy.ogg");
		FlxG.sound.load("assets/sound/musique_tabular.ogg");
		FlxG.sound.load("assets/sound/musique_split_tabular.ogg");
		FlxG.sound.load("assets/sound/musique_harpolodic.ogg");

		spriteBG = new FlxSprite(0, 0);
		spriteBG.loadGraphic('assets/images/Menu.jpg');
		spriteBG.scale.x = Registre.CoefScale.x;
		spriteBG.scale.y = Registre.CoefScale.y;
		spriteBG.updateHitbox();

		add(spriteBG);

		//FlxTween.circularMotion(spSpaceship, spPlanet.x+spPlanet.width/2, spPlanet.y+spPlanet.height/2, 600, 90, true, 100, true, { type:FlxTween.LOOPING } );
		//FlxTween.angle(spSpaceship, 0, -1, 10, { type:FlxTween.LOOPING });
		//tw  = FlxTween.tween(spSpaceship, { x:600, y:800 }, 2, { type:FlxTween.circularMotion(spSpaceship, 0, 1080,500,0,true,1,true)});
		
		


		lvlButtonGroup = new FlxTypedGroup();
		
		// set lvl buttons
		var bt : FlxButton;
		bt = new FlxButton(800,500,onBtClick.bind(0));
		bt.loadGraphic('assets/images/Tutorial.png',false,150,44);
		//bt.scale.x = bt.scale.y = Registre.CoefScale.x;
		bt.updateHitbox();
		lvlButtonGroup.add(bt);
	
		bt = new FlxButton(1000,500,null,onBtClick.bind(1));
		bt.loadGraphic('assets/images/Challenge.png',false,190,60);
		//bt.scale.x = bt.scale.y = Registre.CoefScale.x;
		bt.updateHitbox();
		lvlButtonGroup.add(bt);

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
		gotoPlay();
	}

	private function gotoPlay():Void
	{
		FlxG.switchState(new PlayState());
	}
}
