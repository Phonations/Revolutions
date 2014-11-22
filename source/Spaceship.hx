package ;

import flixel.animation.FlxAnimation;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.FlxG;
import flixel.util.FlxAngle;

class Spaceship extends FlxSprite
{

	public var engine : Bool;
	private var fuel : Int;
	private var fuelCoolDown : Int;

	public function new(X:Float=0, Y:Float=0)
	{
		super(X, Y);
		loadGraphic("assets/images/Spaceship.png", true, 128, 90);
		trace(width, height);
		animation.add('idle', [0], 0);
		animation.add('gaz', [1],0);
		animation.play('idle');
		engine = false;
		fuel = 10;
		fuelCoolDown = 0;
	}
	override public function update () : Void
	{
		if (engine)
		{
			animation.play('gaz');
			fuelCoolDown++;
			
			if (fuelCoolDown % 60 == 0)
			{
				fuel--;
			}
			
			var k:Int = Registre.engineAcceleration;
			velocity.x += k * Math.cos(FlxAngle.asRadians(angle));
			velocity.y += k * Math.sin(FlxAngle.asRadians(angle));
		}
		
		if (!engine)
		{
			animation.play('idle');
			fuelCoolDown = 0;
		}
		
		super.update();
	}
	
}
