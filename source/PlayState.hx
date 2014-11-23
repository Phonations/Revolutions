package;

import flixel.FlxBasic;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxTypedGroup;
import haxe.ds.Vector;
import flixel.system.FlxSound;
import flixel.text.FlxText;
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
import flixel.ui.FlxBar;


class PlayState extends FlxNapeState
{
	public var cameraUI : FlxCamera;
	public var cameraGame : FlxCamera;
	private var spriteBG : FlxSprite;
	private var spriteBG_stars : FlxSprite;
	private var player : Spaceship;
	private var planets : FlxSpriteGroup;

	private var space : Space;
	
	private var floorShape : FlxNapeSprite;
	private var pauseSubState:PauseState;
	private var tutoSubState:TutoState;
	private var fuelBar : FlxBar;
	private var fuelText : FlxText;
	private var textTween : FlxTween;

	override public function create():Void
	{
		super.create();

		FlxG.debugger.visible = true;

		// Setup camera
		FlxG.cameras.bgColor = 0xC2F8FF;

		Registre.level = 1;
		
		cameraGame = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		FlxG.cameras.add(cameraGame);

		cameraUI = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		FlxG.cameras.add(cameraUI);
		
		cameraUI.width = FlxG.width;
		cameraUI.height = FlxG.height;
		cameraUI.antialiasing = true;
		
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
		
		
		spriteBG_stars = new FlxSprite(0, 0);
		spriteBG_stars.loadGraphic('assets/images/BG_Stars.png');
		spriteBG_stars.scale.x = FlxG.width / 1920;
		spriteBG_stars.scale.y = FlxG.height / 1080;
		spriteBG_stars.updateHitbox();
		spriteBG_stars.scrollFactor.set(.3,.3);
		
		
		// Setup environment
		FlxG.debugger.visible = true;

		FlxG.autoPause = false;
		
		// Setup physics
		space = new Space(new Vec2(0, 0));
		
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
		
		
		
		//setup pause state
		pauseSubState = new PauseState();
		
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
		
		//camera gestion
		spriteBG.cameras = [cameraGame];
		spriteBG_stars.cameras = [cameraGame];
		fuelBar.cameras = [cameraUI];
		fuelText.cameras = [cameraUI];
		planets.cameras = [cameraGame];
		player.cameras = [cameraGame];
		
		add(spriteBG);
		add(spriteBG_stars);
		add(planets);
		add(player);
		add(fuelText);
		add(fuelBar);
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
		FlxG.camera = null;

		spriteBG = FlxDestroyUtil.destroy(spriteBG);
		spriteBG = null;
		
		pauseSubState=FlxDestroyUtil.destroy(pauseSubState);
		pauseSubState = null;

		super.destroy();
	}

	override public function update():Void
	{
		//camera zoom
		if (FlxG.mouse.wheel != 0)
		{
			cameraGame.zoom += FlxG.mouse.wheel / 30;
			if (cameraGame.zoom >= 1)cameraGame.zoom = 1;
			if (cameraGame.zoom <= .5) cameraGame.zoom = .6;
			cameraGame.height = Std.int(Std.int(FlxG.height / cameraGame.getScale().y));
			cameraGame.width = Std.int(Std.int(FlxG.width /  cameraGame.getScale().x));
			trace(cameraGame.width );
			//spriteBG.scale.set(1 / FlxG.camera.zoom, 1 / FlxG.camera.zoom);
		}
		
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

		var gravity:Vec2 = new Vec2(0, 0);
		if (player.engine && (player.fuel>0))
		{
			var k:Float = 1000;
			gravity.x += k * Math.cos(FlxAngle.asRadians(player.angle));
			gravity.y += k * Math.sin(FlxAngle.asRadians(player.angle));
		}
		
		for (p in planets.members)
		{
			var d:Float = p.getMidpoint().distanceTo(player.getMidpoint());
			var g = Registre.gravitationConstant / d / d;
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

		super.update();
	}

	private function loadLevel(data:Dynamic):Void
	{
		var tiledLevel : TiledMap = new TiledMap(data);	
		
		
		// Add spaceship
		player = new Spaceship(FlxG.width / 2, FlxG.height / 2, space);
		player.velocity.x = 50;
		
		//add planets		
		planets = new FlxSpriteGroup();		
		for (group in tiledLevel.objectGroups)
		{
			for (obj in group.objects)
			{				
				if (obj.type == 'player')
				{
					player.x = obj.x;
					player.y = obj.y;
					FlxG.log.add(obj.custom.AngleAcceleration);
					FlxG.log.add(obj.custom.MaxAngleVelocity);
					FlxG.log.add(obj.custom.EngineAcceleration);
					player.angleAcceleration=Std.parseInt(obj.custom.AngleAcceleration);
					player.maxAngleVelocity=Std.parseInt(obj.custom.MaxAngleVelocity);
					player.engineAcceleration=Std.parseInt(obj.custom.EngineAcceleration);
				}
				else
				{
					FlxG.log.add(space.gravity);
					planets.add(new Planet(obj.x, obj.y, obj.type,Std.parseInt(obj.custom.mass), space));
				}			
				
			}
		}	
	}
}
