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
class PauseState extends FlxSubState
{
	// Some test sprite, showing that if the state is persistant (not destroyed after closing)
	// then it will save it's position (and all other properties)
	private var BGSprite:FlxSprite;
	private var closeBtn:FlxButton;
	private var menuBtn:FlxButton;
	private var menuText :FlxText;

	//private var switchParentDrawingBtn:FlxButton;
	//private var switchParentUpdatingBtn:FlxButton;
	// just a helper flag, showing if this substate is persistant or not
	public var isPersistant:Bool = false;

	override public function create():Void
	{
		super.create();
		closeBtn = new FlxButton(20, 20, null, gotoGame);
//		closeBtn.loadGraphic("assets/images/play.png");

		menuBtn = new FlxButton(500,500, null, gotoMenu);
		menuBtn.height =60 * Registre.CoefScale.x;
		menuBtn.width = 200 * Registre.CoefScale.x;

		BGSprite = new FlxSprite(0, 0);
		BGSprite.makeGraphic(FlxG.width, FlxG.height,FlxColor.BLACK);
		BGSprite.alpha = 0.45;
		BGSprite.scrollFactor.set();


		add(BGSprite);
		add(closeBtn);
		add(menuBtn);


		_parentState.persistentUpdate = false;
		_parentState.destroySubStates = false;
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
		// if you will pass 'true' (which is by default) into close() method then this substate will be destroyed
		// but when you'll pass 'false' then you should destroy it manually
		//Registre.BGExt.startTimer();
		FlxTimer.manager.active = true;
		FlxTween.manager.active = true;
		close();
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

		closeBtn = FlxDestroyUtil.destroy(closeBtn);
		closeBtn = null;

		menuBtn = FlxDestroyUtil.destroy(menuBtn);
		menuBtn = null;
		trace('subdestroy');
		super.destroy();
	}
}
