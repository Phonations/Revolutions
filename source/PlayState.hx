package;

import flixel.FlxBasic;
import flixel.group.FlxSpriteGroup;
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
import flixel.util.FlxAngle;
import Spaceship;
import flixel.util.FlxAngle;

import flixel.addons.editors.tiled.TiledLayer;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectGroup;
import flixel.addons.editors.tiled.TiledTile;
import flixel.addons.editors.tiled.TiledTileSet;

class PlayState extends FlxState
{
	private var timerTap : Timer;
	private var tap : Bool;
	private var pinch : Bool;
	private var scroll : Bool;
	private var drag : Bool;
	private var persistantSubState:PauseState;
	private var openPersistantBtn:FlxButton;
//	public var cameraUI : FlxCamera;
	public var cameraGame : FlxCamera;
	private var spriteBG : FlxSprite;
	private var spriteBG_stars : FlxSprite;
	private var player : Spaceship;
	private var planets : FlxSpriteGroup;


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
		spriteBG_stars.scrollFactor.set(.3,.3);
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
		timerTap = new Timer(1000, 0);

		tap = false;
		pinch = false;
		scroll = false;
		drag = false;

		// Setup environment
		FlxG.debugger.visible = true;

		FlxG.autoPause = false;

		// Add spaceship

		player = new Spaceship(FlxG.width / 2, FlxG.height / 2);
		add(player);
		player.velocity.x = 50;
		cameraGame.follow(player);
		Registre.level = 1;
		//load level
		planets = new FlxSpriteGroup();		
		add(planets);
		loadLevel("assets/data/lvl" + Registre.level + ".tmx");
		
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
		player.angle = FlxAngle.angleBetweenMouse(player, true);
		if (FlxG.mouse.justPressed)
		{
			player.engine = true;
		}
		
		if (FlxG.mouse.justReleased)
		{
			player.engine = false;
		}
		
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
	
	private function loadLevel(data:Dynamic):Void
	{
		var tiledLevel : TiledMap = new TiledMap(data);	
		
		for (group in tiledLevel.objectGroups)
		{
			for (obj in group.objects)
			{				
				if (obj.type == 'player')
				{
					player.x = obj.x;
					player.y = obj.y;
				}
				else
				{
					planets.add(new Planet(obj.x, obj.y, obj.type));
				}			
				
			}
		}	
	}
}
