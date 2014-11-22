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
import flixel.util.FlxAngle;
import Spaceship;
import flixel.util.FlxAngle;

class PlayState extends FlxState
{
	public var cameraGame : FlxCamera;
	private var spriteBG : FlxSprite;
	private var spriteBG_stars : FlxSprite;
	private var player : Spaceship;


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

		// Add spaceship

		player = new Spaceship(FlxG.width / 2, FlxG.height / 2);
		add(player);
		//player.velocity.x = 50;
		cameraGame.follow(player);
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
		
		if (FlxG.keys.pressed.LEFT)
			player.angle -= Registre.keyPressedAngleAcceleration;
		if (FlxG.keys.pressed.RIGHT)
			player.angle += Registre.keyPressedAngleAcceleration;
		player.engine = FlxG.keys.pressed.UP || FlxG.mouse.pressed;
		
		//player.angle = FlxAngle.angleBetweenPoint(player, FlxG.mouse.getWorldPosition(), true);
		
		
		super.update();
	}
}
