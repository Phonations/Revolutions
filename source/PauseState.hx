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
	private var sl:FlxSlider;
	private var slData: Int;
	//private var switchParentDrawingBtn:FlxButton;
	//private var switchParentUpdatingBtn:FlxButton;
	// just a helper flag, showing if this substate is persistant or not
	public var isPersistant:Bool = false;

	override public function create():Void
	{
		super.create();
		closeBtn = new FlxButton(20, 20, null, onClick);
//		closeBtn.loadGraphic("assets/images/play.png");
		closeBtn.scale.x = closeBtn.scale.y = .5;
		closeBtn.alpha = .6;

		menuText = new FlxText(FlxG.width/2-100 * Registre.CoefScale.x, FlxG.height/2, 200 * Registre.CoefScale.x,"MENU"); // x, y, width
		menuText.setFormat("assets/data/Lato-Lig.ttf", Std.int(60 * Registre.CoefScale.x), 0xffffff, "center");
		menuText.alpha = .6;

		menuBtn = new FlxButton(menuText.x, menuText.y, null, gotoMenu);
		menuBtn.height =60 * Registre.CoefScale.x;
		menuBtn.width = 200 * Registre.CoefScale.x;
		menuBtn.alpha = 0;

		BGSprite = new FlxSprite(0, 0);
		//BGSprite.loadGraphic("assets/images/BG.png");
		BGSprite.makeGraphic(FlxG.width, FlxG.height,FlxColor.BLACK);
		BGSprite.alpha = 0.45;

		sl = new FlxSlider(this, 'slData', (FlxG.width - Std.int(300*Registre.CoefScale.x)) / 2, menuBtn.y+150*Registre.CoefScale.y, 0, 100, Std.int(300*Registre.CoefScale.x), Std.int(30*Registre.CoefScale.y*Registre.mobileZoom),1, FlxColor.WHITE, FlxColor.WHITE);
		sl.handle.makeGraphic(Std.int(30*Registre.CoefScale.y*Registre.mobileZoom), Std.int(30*Registre.CoefScale.y*Registre.mobileZoom), FlxColor.WHITE);
		sl.setTexts(null, false, null, null);
		sl.hoverAlpha = 1;
		slData = 0;
		sl.body.alpha = .6;
		sl.handle.alpha = .6;
		/*sl.x = (FlxG.width - sl.width) / 2;
		sl.y = menuBtn.y-300*Registre.CoefScale.y;*/


		add(BGSprite);
		add(closeBtn);
		add(menuBtn);
		add(menuText);
		add(sl);


		var a: Array<FlxCamera> = closeBtn.cameras.copy();
		if (closeBtn.cameras.length>1)
		{
		a.reverse();
		a.pop();
		a.pop();
		a.pop();
		closeBtn.cameras = a;
		}

		a = BGSprite.cameras.copy();
		if (BGSprite.cameras.length>1)
		{
		a.reverse();
		a.pop();
		a.pop();
		a.pop();
		BGSprite.cameras = a;
		}

		a = menuBtn.cameras.copy();
		if (menuBtn.cameras.length>1)
		{
		a.reverse();
		a.pop();
		a.pop();
		a.pop();
		menuBtn.cameras = a;
		}

		a = menuText.cameras.copy();
		if (menuText.cameras.length>1)
		{
		a.reverse();
		a.pop();
		a.pop();
		a.pop();
		menuText.cameras = a;
		}

		a = sl.cameras.copy();
		if (sl.cameras.length>1)
		{
		a.reverse();
		a.pop();
		a.pop();
		a.pop();
		sl.cameras = a;
		}

		_parentState.persistentUpdate = false;
		_parentState.persistentDraw = true;
	}

	private function onClick()
	{
		// if you will pass 'true' (which is by default) into close() method then this substate will be destroyed
		// but when you'll pass 'false' then you should destroy it manually
		//Registre.BGExt.startTimer();
		FlxTimer.manager.active = true;
		FlxTween.manager.active = true;
		trace(slData);
		close();
	}

	private function gotoMenu()
	{
		FlxTimer.manager.active = true;
		FlxTween.manager.active = true;
		FlxG.switchState(new MenuState());
	}

	// This function will be called by substate right after substate will be closed
	public static function onSubstateClose():Void
	{
		//FlxG.fade(FlxG.BLACK, 1, true);


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
