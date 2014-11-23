package ;

import flixel.FlxCamera;
import flixel.group.FlxSpriteGroup;
import flixel.ui.FlxButton;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.util.FlxDestroyUtil;
import flixel.addons.ui.FlxSlider;

/**
 * ...
 * @author peripherique
 */
class LoseState extends FlxSubState
{
	// Some test sprite, showing that if the state is persistant (not destroyed after closing)
	// then it will save it's position (and all other properties)
	private var BGSprite:FlxSprite;
	private var loseSprite : FlxSprite;
	private var startBtn:FlxButton;

	// just a helper flag, showing if this substate is persistant or not
	public var isPersistant:Bool = false;

	override public function create():Void
	{
		super.create();
		trace('lose');
		startBtn = new FlxButton(500, 500, null, gotoMenu);
		startBtn.loadGraphic('assets/images/Home.png',false,120,44);
		startBtn.x = (FlxG.width-startBtn.width) / 2;
		startBtn.y = (FlxG.height - startBtn.height) / 2+150;
	
		loseSprite = new FlxSprite(0,0);
		loseSprite.loadGraphic('assets/images/YouLose.png');
		loseSprite.x = (FlxG.width-loseSprite.width) / 2;
		loseSprite.y = (FlxG.height - loseSprite.height) / 2;
		loseSprite.scale.set(.5,.5);
		loseSprite.scrollFactor.set();

		BGSprite = new FlxSprite(0, 0);
		BGSprite.makeGraphic(Std.int(3 / 4 * FlxG.width), Std.int(3 / 4 * FlxG.height), FlxColor.BLACK);
		BGSprite.x = (FlxG.width - BGSprite.width) / 2;
		BGSprite.y = (FlxG.height - BGSprite.height) / 2;
		BGSprite.alpha = 0.55;
		BGSprite.scrollFactor.set();

		add(BGSprite);
		add(startBtn);
		add(loseSprite);

	}

	private function gotoMenu():Void
	{
		FlxTimer.manager.active = true;
		FlxTween.manager.active = true;
		FlxG.switchState(new MenuState());
	}

	override public function destroy():Void
	{
		BGSprite = FlxDestroyUtil.destroy(BGSprite);
		BGSprite = null;

		startBtn = FlxDestroyUtil.destroy(startBtn);
		startBtn = null;
		
		super.destroy();
	}
}
