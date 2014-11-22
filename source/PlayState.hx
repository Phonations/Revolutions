package;

import flixel.FlxBasic;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
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
import flixel.ui.FlxBar;

class PlayState extends FlxState
{
	public var cameraGame : FlxCamera;
	private var spriteBG : FlxSprite;
	private var spriteBG_stars : FlxSprite;
	private var player : Spaceship;
	private var planets : FlxSpriteGroup;
	private var pauseSubState:PauseState;
	private var fuelBar : FlxBar;
	private var fuelText : FlxText;
	private var textTween : FlxTween;


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
		
		//launch music
		//FlxG.sound.playMusic("musique_beat");
		//FlxG.sound.playMusic("musique_butterfly");
		/*FlxG.sound.playMusic("musique_dreamworks");
		FlxG.sound.playMusic("musique_glass");
		FlxG.sound.playMusic("musique_glassy");
		FlxG.sound.playMusic("musique_harpolodic");
		FlxG.sound.playMusic("musique_split");
		FlxG.sound.playMusic("musique_split_tabular");	*/	
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
			player.angle -= Registre.keyPressedAngleAcceleration;
			
		if (FlxG.keys.pressed.F || FlxG.keys.pressed.RIGHT)
			player.angle += Registre.keyPressedAngleAcceleration;
			
		player.engine = FlxG.keys.pressed.UP || FlxG.keys.pressed.E || FlxG.mouse.pressed;
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
