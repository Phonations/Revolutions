package;

import flixel.FlxBasic;
import flixel.group.FlxTypedGroup;
import openfl.geom.Point;
import openfl.utils.Timer;
import Std;
import flixel.FlxG;
import flixel.FlxState;
import flixel.tile.FlxTilemap;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.FlxCamera;
import CameraMove;
import flixel.system.frontEnds.DebuggerFrontEnd;
//import LevelManager;
import flixel.tweens.FlxTween;
import  flixel.tweens.FlxEase;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.ui.FlxButton;
import flixel.util.FlxTimer;
import flixel.util.FlxDestroyUtil;
import Spaceship;
import flixel.util.FlxAngle;

class PlayState extends FlxState
{
	private var mousePrev:FlxPoint;
	private var mouseInitWorld:FlxPoint;
	private var mousePrevWorld:FlxPoint;
	private var mouseCurrentWorld:FlxPoint;
	private var distPrev:Float;
	private var centerPrev : FlxPoint;
	private var timerTap : Timer;
	private var tap : Bool;
	private var pinch : Bool;
	private var scroll : Bool;
	private var drag : Bool;
	private var persistantSubState:PauseState;
	private var openPersistantBtn:FlxButton;
//	public var cameraUI : FlxCamera;
	public var cameraGame : FlxCamera;
	private var mouseOrientationX :Int;
	private var spriteBG : FlxSprite;
	private var spriteBG_stars : FlxSprite;
	private var player : Spaceship;


	override public function create():Void
	{
		//Registre.BGExt= new LevelManager("assets/data/lvl"+Registre.level+"zlib.tmx");

		super.create();

		// Setup camera

		FlxG.cameras.bgColor = 0xC2F8FF;

		cameraGame = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		FlxG.cameras.add(cameraGame);

//		cameraUI = new FlxCamera(0, 0, FlxG.width, FlxG.height);
//		FlxG.cameras.add(cameraUI);

//		cameraGame.zoom = .25;
//		cameraGame.height = Std.int(Math.ceil(FlxG.height / cameraGame.getScale().y));
//		cameraGame.width = Std.int(Math.ceil(FlxG.width / cameraGame.getScale().x));
		cameraGame.width = FlxG.width;
		cameraGame.height = FlxG.height;
		cameraGame.antialiasing = true;

		// setup background
		
		spriteBG = new FlxSprite(0, 0);
		spriteBG.loadGraphic('assets/images/BG.jpg');
		spriteBG.scale.x = FlxG.width / 1920;
		spriteBG.scale.y = FlxG.height / 1080;
		spriteBG.updateHitbox();
		spriteBG.scrollFactor.set();
		add(spriteBG);
		
		spriteBG_stars = new FlxSprite(0, 0);
		spriteBG_stars.loadGraphic('assets/images/BG_Stars.png');
		spriteBG_stars.scale.x = FlxG.width / 1920;
		spriteBG_stars.scale.y = FlxG.height / 1080;
		spriteBG_stars.updateHitbox();
		spriteBG_stars.scrollFactor.set(.5,.5);
		add(spriteBG_stars);

		// Setup pause state

//		persistantSubState = new PauseState();
//		openPersistantBtn = new FlxButton(20, 20, null, onPersistantClick);
//		openPersistantBtn.loadGraphic("assets/images/pause.png");
//		openPersistantBtn.scale.x = openPersistantBtn.scale.y = .5;
//		openPersistantBtn.alpha = .6;
//		add(openPersistantBtn);

//		openPersistantBtn.cameras = [cameraUI];

		// Setup mouse and touch

		mousePrev = new FlxPoint(0, 0);
		mouseInitWorld = new FlxPoint(0, 0);
		mouseCurrentWorld = new FlxPoint(0, 0);
		mousePrevWorld = new FlxPoint(0, 0);
		centerPrev = new FlxPoint(0, 0);
		distPrev = 0;

		timerTap = new Timer(1000, 0);

		tap = false;
		pinch = false;
		scroll = false;
		drag = false;
		mouseOrientationX = 0;
		// Setup environment
		FlxG.debugger.visible = true;

		FlxG.autoPause = false;

		// Add spaceship

		player = new Spaceship(FlxG.width / 2, FlxG.height / 2);
		add(player);
		cameraGame.follow(player);
	}


	override public function destroy():Void
	{
//		cameraUI = null;
		cameraGame = null;

		openPersistantBtn=FlxDestroyUtil.destroy(openPersistantBtn);
		openPersistantBtn = null;

		spriteBG=FlxDestroyUtil.destroy(spriteBG);
		spriteBG = null;

		persistantSubState=FlxDestroyUtil.destroy(persistantSubState);
		persistantSubState = null;

		super.destroy();
	}



	override public function onFocusLost():Void
	{
		FlxTimer.manager.active = false;
		FlxTween.manager.active = false;
		openPersistantBtn.kill();
		if (persistantSubState.exists)
		{
			persistantSubState.destroy();
			persistantSubState = null;
		}
		persistantSubState = new PauseState();
		persistantSubState.isPersistant = false;
		openSubState(persistantSubState);
	}

	override public function update():Void
	{
//		if (!openPersistantBtn.alive && !persistantSubState.exists)openPersistantBtn.revive();
		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed && FlxG.touches.list.length ==1)
			{

				timerTap.start();
				tap = false;
				scroll = true;
				drag = false;

				mousePrev.x = touch.screenX;
				mousePrev.y = touch.screenY;

				mouseInitWorld.x = touch.getWorldPosition(cameraGame).x;
				mouseInitWorld.y = touch.getWorldPosition(cameraGame).y;

				if(Std.int(mouseInitWorld.x - touch.getWorldPosition(cameraGame).x)!=0)mouseOrientationX = Std.int(mouseInitWorld.x - touch.getWorldPosition(cameraGame).x);
			}

			if (touch.pressed && FlxG.touches.list.length ==1)
			{
				if (mousePrev.distanceTo(touch.getScreenPosition())!=0)
				{
					tap = false;
				}

				if (!pinch && scroll)
				{
					cameraGame.scroll.x -= (touch.screenX - mousePrev.x) * (1 / cameraGame.zoom);
					cameraGame.scroll.y -= (touch.screenY - mousePrev.y) * (1 / cameraGame.zoom);
					mousePrev.x = touch.screenX;
					mousePrev.y = touch.screenY;
				}

				if (Std.int(mousePrevWorld.x - touch.getWorldPosition(cameraGame).x) != 0) mouseOrientationX = Std.int(mousePrevWorld.x - touch.getWorldPosition(cameraGame).x);
				mousePrevWorld.x = touch.getWorldPosition(cameraGame).x;
				mousePrevWorld.y = touch.getWorldPosition(cameraGame).y;
			}

			if (touch.justReleased)
			{
				if (timerTap.currentCount<1 && tap)
				{

				}
				timerTap.stop();
				timerTap.reset();

				tap = false;
				scroll = false;
				drag = false;
			}
		}

		if (FlxG.touches.list.length ==2)
		{
			tap = false;
			scroll = false;
			drag = false;
			pinch = true;
			if (distPrev != 0)
			{
				CameraMove.zoom((FlxG.touches.getByID(0).getWorldPosition(cameraGame).distanceTo(FlxG.touches.getByID(1).getWorldPosition(cameraGame))-distPrev)/500, Registre.LEVEL_SIZE);
				cameraGame.scroll.x -= -centerPrev.x+(FlxG.touches.getByID(0).getWorldPosition(cameraGame).x+FlxG.touches.getByID(1).getWorldPosition(cameraGame).x)/2;
				distPrev = FlxG.touches.getByID(0).getWorldPosition(cameraGame).distanceTo(FlxG.touches.getByID(1).getWorldPosition(cameraGame));
			}

			else
			{
				distPrev = FlxG.touches.getByID(0).getWorldPosition(cameraGame).distanceTo(FlxG.touches.getByID(1).getWorldPosition(cameraGame));
				centerPrev.x =(FlxG.touches.getByID(0).getWorldPosition(cameraGame).x+FlxG.touches.getByID(1).getWorldPosition(cameraGame).x)/2;
				centerPrev.y =(FlxG.touches.getByID(0).getWorldPosition(cameraGame).y+FlxG.touches.getByID(1).getWorldPosition(cameraGame).y)/2;
			}

		}
		if (FlxG.touches.list.length != 2)
		{
			distPrev = 0;
		}

		if (FlxG.touches.list.length == 0)
		{
			tap = false;
			pinch = false;
			scroll = false;
			drag = false;
		}
		#end


		#if !mobile
			if (FlxG.mouse.justPressed) // just pressed
			{
				timerTap.start();
				tap = false;
				scroll = true;

				mouseInitWorld.x = FlxG.mouse.getWorldPosition(cameraGame).x;
				mouseInitWorld.y = FlxG.mouse.getWorldPosition(cameraGame).y;
			}

			if (FlxG.mouse.pressed) // presse
			{
				if (mousePrev.distanceTo(FlxG.mouse.getScreenPosition()) !=0) // is the mouse moving ?
				{
					tap = false;

					//scroll level
					if (scroll)
					{
						cameraGame.scroll.x -= (FlxG.mouse.screenX - mousePrev.x)*(1/cameraGame.zoom);
						cameraGame.scroll.y -= (FlxG.mouse.screenY - mousePrev.y)*(1/cameraGame.zoom);
					}
				}
			}

			if (FlxG.mouse.wheel != 0)
			{
				CameraMove.zoom(FlxG.mouse.wheel / 10);
				CameraMove.center(mousePrevWorld, FlxG.mouse.getWorldPosition(cameraGame));
				tap = false;
				scroll = false;
				drag = false;
			}

			if (FlxG.mouse.justReleased)
			{
				if (timerTap.currentCount<1 && tap)
				{

				}
				timerTap.stop();
				timerTap.reset();
				tap = false;
				scroll = false;
				drag = false;
			}
			if(Std.int(mousePrevWorld.x - FlxG.mouse.getWorldPosition(cameraGame).x)!=0)mouseOrientationX = Std.int(mousePrevWorld.x - FlxG.mouse.getWorldPosition(cameraGame).x);
			mousePrev.x = FlxG.mouse.screenX;
			mousePrev.y = FlxG.mouse.screenY;
			mousePrevWorld.x = FlxG.mouse.getWorldPosition(cameraGame).x;
			mousePrevWorld.y = FlxG.mouse.getWorldPosition(cameraGame).y;

		#end
		super.update();
	}

	private function onPersistantClick():Void
	{
		//Registre.BGExt.pauseTimer();
		FlxTimer.manager.active = false;
		FlxTween.manager.active = false;
		openPersistantBtn.kill();
		if (persistantSubState.exists)
		{
			persistantSubState.destroy();
			persistantSubState = null;
		}
		persistantSubState = new PauseState();
		persistantSubState.isPersistant = false;
		openSubState(persistantSubState);
	}
}
