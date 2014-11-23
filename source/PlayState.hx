package;

import flixel.FlxBasic;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxTypedGroup;
import haxe.ds.Vector;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import nape.callbacks.InteractionListener;
import openfl.geom.Point;
import openfl.utils.Timer;
import Std;
import flixel.FlxG;
import flixel.FlxState;
import flixel.tile.FlxTilemap;
import flixel.*;
import CameraMove;
import flixel.system.frontEnds.DebuggerFrontEnd;
//import LevelManager;
import flixel.tweens.FlxTween;
import  flixel.tweens.FlxEase;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.ui.FlxButton;
import Spaceship;
import flixel.util.*;
import flixel.addons.editors.tiled.*;
import flixel.addons.nape.*;
import nape.space.*;
import nape.geom.*;
import nape.phys.*;
import nape.shape.*;
import nape.callbacks.*;

import flixel.ui.FlxBar;
import flixel.group.FlxGroup;

class PlayState extends FlxNapeState
{
	public var cameraGame : FlxCamera;
	private var spriteBG : FlxSprite;
	private var spriteBG_stars : FlxSprite;
	private var player : Spaceship;
	private var planets : List<FlxNapeSprite>;

	private var space : Space;
	var crashListener : InteractionListener;
	var winListener : InteractionListener;
	private var planetCollisionType:CbType=new CbType();
	private var endCollisionType:CbType=new CbType();
	private var startCollisionType:CbType=new CbType();
	private var playerCollisionType:CbType = new CbType();
		
	private var floorShape : FlxNapeSprite;
	private var pauseSubState:PauseState;
	private var tutoSubState:TutoState;
	private var loseSubState:LoseState;
	private var winSubState:WinState;
	private var fuelBar : FlxBar;
	private var fuelText : FlxText;
	private var textTween : FlxTween;

	override public function create():Void
	{
		super.create();

		FlxG.debugger.visible = true;

		// Setup camera
		FlxG.cameras.bgColor = 0xC2F8FF;

		Registre.level = 3;
		
		cameraGame = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		FlxG.cameras.add(cameraGame);

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
		
		// Setup environment
		FlxG.debugger.visible = true;

		FlxG.autoPause = false;
		
		// Setup physics
		space = new Space(new Vec2(0, 0));
		crashListener = new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, planetCollisionType, playerCollisionType, onCrash);
		space.listeners.add(crashListener);
		winListener = new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, endCollisionType, playerCollisionType, onWin);
		space.listeners.add(winListener);
		
		//load level
		loadLevel("assets/data/lvl" + Registre.level + ".tmx");		
		cameraGame.follow(player);
		
		//fuelbar setup
		fuelBar = new FlxBar(0, FlxG.height - 50, FlxBar.FILL_LEFT_TO_RIGHT, 700, 2, null, null, 0, 600);	
		fuelBar.x = (FlxG.width-fuelBar.width) / 2;
		fuelBar.createFilledBar(0xffff0000, 0xffffffff, false);
		fuelBar.scrollFactor.set();
		fuelText = new FlxText(FlxG.width/2-250 , FlxG.height - 100, 500, 'FUEL LEVEL');
		fuelText.setFormat("assets/data/Capsuula.ttf", 25, FlxColor.WHITE, "center");
		fuelText.scrollFactor.set();
		
		add(fuelText);
		add(fuelBar);
		
		//setup substates
		pauseSubState = new PauseState();
		loseSubState = new LoseState();
		winSubState = new WinState();
		
		//launch music
		/*FlxG.sound.playMusic("assets/sound/musique_beat.ogg");
		FlxG.sound.playMusic("assets/sound/musique_butterfly.ogg");
		FlxG.sound.playMusic("assets/sound/musique_glass.ogg");
		FlxG.sound.playMusic("assets/sound/musique_glassy.ogg");
		FlxG.sound.playMusic("assets/sound/musique_tabular.ogg");
		FlxG.sound.playMusic("assets/sound/musique_split_tabular.ogg");
		FlxG.sound.playMusic("assets/sound/musique_harpolodic.ogg");*/
		
		var s1 : FlxSound =FlxG.sound.load("assets/sound/musique_beat.mp3",1,true);
		var s2 : FlxSound=FlxG.sound.load("assets/sound/musique_butterfly.mp3",1,true);
		var s3 : FlxSound=FlxG.sound.load("assets/sound/musique_glass.mp3",1,true);
		var s4 : FlxSound=FlxG.sound.load("assets/sound/musique_glassy.mp3",1,true);
		var s5 : FlxSound=FlxG.sound.load("assets/sound/musique_tabular.mp3",1,true);
		var s6 : FlxSound=FlxG.sound.load("assets/sound/musique_split_tabular.mp3",1,true);
		var s7 : FlxSound = FlxG.sound.load("assets/sound/musique_harpolodic.mp3", 1, true);
		
		s1.play();
		s2.play();
		s3.play();
		s4.play();
		s5.play();
		s6.play();
		s7.play();
		
		//tutorial screen
		if (Registre.level == 0)
		{
			FlxTimer.manager.active = false;
			FlxTween.manager.active = false;
			tutoSubState = new TutoState();
			openSubState(tutoSubState);
		}		
	}

	override public function onFocusLost():Void
	{
		FlxTimer.manager.active = false;
		FlxTween.manager.active = false;
		/*if (!pauseSubState.exists)
		{
			pauseSubState = new PauseState();
			openSubState(pauseSubState);
		}*/
		trace(pauseSubState.exists);
		
	}
	
	override public function destroy():Void
	{
		cameraGame = null;

		spriteBG = FlxDestroyUtil.destroy(spriteBG);
		spriteBG = null;
		
		pauseSubState=FlxDestroyUtil.destroy(pauseSubState);
		pauseSubState = null;

		super.destroy();
	}
	
	private function onCrash(collision:InteractionCallback):Void {
		FlxG.log.add("crash");
		FlxTimer.manager.active = false;
		FlxTween.manager.active = false;
		openSubState(loseSubState);
	}

	private function onWin(collision:InteractionCallback):Void {
		FlxG.log.add("win");
		FlxTimer.manager.active = false;
		FlxTween.manager.active = false;
		openSubState(winSubState);
	}

	override public function update():Void
	{
		if (FlxG.keys.justPressed.ESCAPE)
		{		
			FlxTimer.manager.active = false;
			FlxTween.manager.active = false;
			openSubState(pauseSubState);
		}
		
		if (FlxG.keys.pressed.S || FlxG.keys.pressed.LEFT)

		{
			if (player.body.angularVel > -player.maxAngleVelocity)
				player.body.angularVel -= player.angleAcceleration;
		}
		if (FlxG.keys.pressed.F || FlxG.keys.pressed.RIGHT)
		{
			if (player.body.angularVel < player.maxAngleVelocity)
				player.body.angularVel += player.angleAcceleration;
		}
		player.engine = FlxG.keys.pressed.UP || FlxG.keys.pressed.E || FlxG.mouse.pressed;

		var playerAcceleration:Vec2 = new Vec2(0, 0);
		if (player.engine && (player.fuel>0))
		{
			playerAcceleration.x += player.engineAcceleration * Math.cos(FlxAngle.asRadians(player.angle));
			playerAcceleration.y += player.engineAcceleration * Math.sin(FlxAngle.asRadians(player.angle));
		}

		var gravity:Vec2 = playerAcceleration;
		
		for (p in planets)
		{
			var d:Float = p.getMidpoint().distanceTo(player.getMidpoint());
			var g = Registre.gravitationConstant * p.body.mass / d / d;
			var angle = FlxAngle.angleBetweenPoint(player, p.getMidpoint(), false);
			gravity.x += g * Math.cos(angle);
			gravity.y += g * Math.sin(angle);
		}

		space.gravity = gravity;
		
		space.step(1 / 30);

		//update fuelbar
		fuelBar.currentValue = player.fuel;
		
		if (player.fuel < 240)
		{
			fuelText.color = 0xff0000;
		}
		
		if (player.fuel == 0)
		{
			onCrash(null);
		}

		super.update();
	}

	private function loadLevel(data:Dynamic):Void
	{
		var tiledLevel : TiledMap = new TiledMap(data);	
		
		// Add spaceship
		//player = new Spaceship(FlxG.width / 2, FlxG.height / 2, space);
		//add(player);
		
		
		//add planets		
		planets = new List<FlxNapeSprite>();
		for (group in tiledLevel.objectGroups)
		{
			for (obj in group.objects)
			{				
				if (obj.type == 'player')
				{
					player = new Spaceship(obj.x, obj.y, space);
					player.velocity.x = 50;
		add(player);
					player.angleAcceleration=Std.parseFloat(obj.custom.AngleAcceleration);
					player.maxAngleVelocity=Std.parseFloat(obj.custom.MaxAngleVelocity);
					player.engineAcceleration = Std.parseFloat(obj.custom.EngineAcceleration);
					
					player.body.cbTypes.add(playerCollisionType);
				}
				else
				{
					FlxG.log.add(space.gravity);
					FlxG.log.add(obj.custom.mass);
					var planet:Planet = new Planet(obj.x, obj.y, obj.type, Std.parseFloat(obj.custom.mass), space);
					planets.add(planet);
					planet.cameras = [cameraGame];
					add(planet);
					if (obj.type == "PlaneteEnd")
						planet.body.cbTypes.add(endCollisionType);
					else if (obj.type == "PlaneteStart")
						planet.body.cbTypes.add(startCollisionType);
					else
						planet.body.cbTypes.add(planetCollisionType);
				}
			}
		}	
	}
}
