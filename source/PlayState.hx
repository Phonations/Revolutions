package;

import flixel.FlxBasic;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxTypedGroup;
import haxe.ds.Vector;
import openfl.geom.Point;
import openfl.utils.Timer;
import Std;
import flixel.FlxG;
import flixel.FlxState;
import flixel.tile.FlxTilemap;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.*;
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

import flixel.addons.editors.tiled.*;
import flixel.addons.nape.FlxNapeSprite;
import nape.space.*;
import nape.geom.*;
import nape.phys.*;
import nape.shape.*;

class PlayState extends FlxState
{
	public var cameraGame : FlxCamera;
	private var spriteBG : FlxSprite;
	private var spriteBG_stars : FlxSprite;
	private var player : Spaceship;
	private var planets : FlxSpriteGroup;
	private var space : Space;
	
	private var floorShape : FlxNapeSprite;

	override public function create():Void
	{
		super.create();

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
		//load level
		loadLevel("assets/data/lvl" + Registre.level + ".tmx");
		
		cameraGame.follow(player);
		
		// Setup physic
		
		var gravity:Vec2 = new Vec2(0, 600);
		space = new Space(gravity);
		
		var width:Int = 500;
		var height:Int = 200;
		var rectangleVertices:Array<Vec2> = Polygon.rect(50, 500, width, height);
		var boxVertices      :Array<Vec2> = Polygon.box(width, height);
		// ^ equivalent to Polygon.rect(-width/2, -height/2, width, height);
		var pentagonVertices :Array<Vec2> = Polygon.regular(width, height, 5);
		
		var floorBody:Body = new Body(BodyType.STATIC);
		floorShape.makeGraphic(width, height);
		
		floorShape.body = floorBody;
		
		var circle:Circle = new Circle(10); // local position argument is optional.
		var anotherCircle:Circle = new Circle(10, new Vec2(5, 0));
		
		var circleBody:Body = new Body(); // Implicit BodyType.DYNAMIC
		circleBody.position.setxy(FlxG.width/2, FlxG.height/2);
		// or circleBody.position = new Vec2(stage.width/2, stage.height/2);
		// or circleBody.position.x = stage.width/2; etc.
		circleBody.velocity.setxy(0, 1000);
		
		var circleShape:Circle = new Circle(50);
		
		// Set individual values
		circleShape.material.elasticity = 1;
		circleShape.material.density = 4;

		// Assign a totally different Material, can use this style to share Materials.
		circleShape.material = Material.rubber();
		circleShape.body = circleBody;
	}


	override public function destroy():Void
	{
		cameraGame = null;

		spriteBG = FlxDestroyUtil.destroy(spriteBG);
		spriteBG = null;

		super.destroy();
	}

	override public function update():Void
	{
		if (FlxG.keys.justPressed.ESCAPE)
			flash.system.System.exit(0);
		
		if (FlxG.keys.pressed.S || FlxG.keys.pressed.LEFT)
			player.angle -= Registre.keyPressedAngleAcceleration;
		if (FlxG.keys.pressed.F || FlxG.keys.pressed.RIGHT)
			player.angle += Registre.keyPressedAngleAcceleration;
		player.engine = FlxG.keys.pressed.UP || FlxG.keys.pressed.E || FlxG.mouse.pressed;
		
		//if (FlxG.mouse.po
		//player.angle = FlxAngle.angleBetweenPoint(player, FlxG.mouse.getWorldPosition(), true);
		
		
		super.update();
	}

	private function loadLevel(data:Dynamic):Void
	{
		var tiledLevel : TiledMap = new TiledMap(data);	
		
		
		// Add spaceship
		player = new Spaceship(FlxG.width / 2, FlxG.height / 2);
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
					planets.add(new Planet(obj.x, obj.y, obj.type, obj.custom.mass));
				}			
				
			}
		}	
	}
}
