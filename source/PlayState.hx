package;

import flixel.FlxBasic;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxTypedGroup;
import haxe.ds.Vector;
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
	public var cameraGame : FlxCamera;
	private var spriteBG : FlxSprite;
	private var spriteBG_stars : FlxSprite;
	private var player : Spaceship;
	private var planets : FlxSpriteGroup;

	private var space : Space;
	
	private var floorShape : FlxNapeSprite;
	var logCount:Int = 0;

	override public function create():Void
	{
		super.create();

		FlxG.debugger.visible = true;
		FlxG.log.add(logCount++);

		// Setup camera
		FlxG.cameras.bgColor = 0xC2F8FF;

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

		Registre.level = 1;
		
		// Setup physics
		FlxG.log.add(logCount++);
		space = new Space(new Vec2(0, 0));
		FlxG.log.add(logCount++);
		
		//load level
		loadLevel("assets/data/lvl" + Registre.level + ".tmx");		
		cameraGame.follow(player);
		
		//fuelbar setup
		fuelBar = new FlxBar(0, FlxG.height - 50, FlxBar.FILL_LEFT_TO_RIGHT, 700, 2, null, null, 0, 10);	
		fuelBar.x = (FlxG.width-fuelBar.width) / 2;
		fuelBar.createFilledBar(0xffff0000, 0xffffffff, false);
		fuelBar.scrollFactor.set();
		fuelText = new FlxText(FlxG.width/2-250 , FlxG.height - 100, 500, 'FUEL LEVEL');
		fuelText.setFormat("assets/data/Capsuula.ttf", 25, FlxColor.WHITE, "center");
		fuelText.scrollFactor.set();
		
		add(fuelText);
		add(fuelBar);

		
		//setup pause state
		pauseSubState = new PauseState();
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
			if (player.body.angularVel > -Registre.maxVelocityRotation)
				player.body.angularVel -= Registre.keyPressedAngleAcceleration;
		}
		if (FlxG.keys.pressed.F || FlxG.keys.pressed.RIGHT)
		{
			if (player.body.angularVel < Registre.maxVelocityRotation)
				player.body.angularVel += Registre.keyPressedAngleAcceleration;
		}
		player.engine = FlxG.keys.pressed.UP || FlxG.keys.pressed.E || FlxG.mouse.pressed;

		var gravity:Vec2 = new Vec2(0, 0);
		if (player.engine)
		{
			var k:Float = 1000;
			gravity.x += k * Math.cos(FlxAngle.asRadians(player.angle));
			gravity.y += k * Math.sin(FlxAngle.asRadians(player.angle));
		}
		
		for (p in planets.members)
		{
			var d:Float = p.getMidpoint().distanceTo(player.getMidpoint());
			var g = 10000000 / d / d;
			var angle = FlxAngle.angleBetweenPoint(player, p.getMidpoint(), false);
			gravity.x += g * Math.cos(angle);
			gravity.y += g * Math.sin(angle);
		}

		FlxG.log.add(gravity);
		FlxG.log.add(player.angularVelocity);
		FlxG.log.add(player.angle);
		space.gravity = gravity;
		
		space.step(1 / 30);

		//update fuelbar
		fuelBar.currentValue = player.fuel;
		
		if (player.fuel < 4)
		{
			fuelText.color = 0xff0000;
		}

		super.update();
	}

	private function loadLevel(data:Dynamic):Void
	{
		var tiledLevel : TiledMap = new TiledMap(data);	
		
		
		// Add spaceship
		FlxG.log.add(logCount++);
		player = new Spaceship(FlxG.width / 2, FlxG.height / 2, space);
		add(player);
		player.velocity.x = 50;
		
		//add planets		
		planets = new FlxSpriteGroup();		
		add(planets);
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
					FlxG.log.add(space.gravity);
					planets.add(new Planet(obj.x, obj.y, obj.type, obj.custom.mass, space));
				}			
				
			}
		}	
	}
}
