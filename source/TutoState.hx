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
class TutoState extends FlxSubState
{
	// Some test sprite, showing that if the state is persistant (not destroyed after closing)
	// then it will save it's position (and all other properties)
	private var BGSprite:FlxSprite;
	private var moveSprite : FlxSprite;
	private var startSprite : FlxSprite;
	private var startBtn:FlxButton;
	private var menuText :FlxText;

	// just a helper flag, showing if this substate is persistant or not
	public var isPersistant:Bool = false;

	override public function create():Void
	{
		super.create();
		

		startBtn = new FlxButton(500, 500, null, gotoGame);
		startBtn.loadGraphic("assets/images/Play.png", false, 82, 58);
		startBtn.x = (FlxG.width) / 2;
		startBtn.y = (FlxG.height - startBtn.height) / 2+200;
		

		BGSprite = new FlxSprite(0, 0);
		BGSprite.makeGraphic(Std.int(3 / 4 * FlxG.width), Std.int(3 / 4 * FlxG.height), FlxColor.BLACK);
		BGSprite.x = (FlxG.width - BGSprite.width) / 2;
		BGSprite.y = (FlxG.height - BGSprite.height) / 2;
		BGSprite.alpha = 0.55;
		BGSprite.scrollFactor.set();
		
		moveSprite = new FlxSprite(0, 0);
		moveSprite.loadGraphic("assets/images/Move.png");
		moveSprite.scale.set(.5, .5);
		moveSprite.x = (FlxG.width - moveSprite.width) / 2;
		moveSprite.y = (FlxG.height - moveSprite.height) / 2;
		moveSprite.scrollFactor.set();
		
		startSprite = new FlxSprite(0, 0);
		startSprite.loadGraphic("assets/images/Start.png");
		startSprite.scale.set(.5, .5);
		startSprite.x = (FlxG.width - startSprite.width) / 2;
		startSprite.y = (FlxG.height - startSprite.height) / 2-200;
		startSprite.scrollFactor.set();

		add(BGSprite);
		add(moveSprite);
		add(startSprite);
		add(startBtn);

		_parentState.persistentUpdate = false;
		_parentState.destroySubStates = true;
		_parentState.persistentDraw = true;
	}

	override public function update():Void
	{
		if (FlxG.keys.justPressed.ESCAPE)
		gotoGame();
		super.update();
		
	}
	private function gotoGame():Void
	{
		FlxTimer.manager.active = true;
		FlxTween.manager.active = true;
		close();
	}

	override public function destroy():Void
	{
		BGSprite = FlxDestroyUtil.destroy(BGSprite);
		BGSprite = null;

		startBtn = FlxDestroyUtil.destroy(startBtn);
		startBtn = null;
		
		trace('subdestroy');
		super.destroy();
	}
}
