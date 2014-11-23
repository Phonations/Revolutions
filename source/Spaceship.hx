package ;

import flixel.animation.FlxAnimation;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.FlxG;
import flixel.util.FlxAngle;

class Spaceship extends FlxSprite
{

	public var engine : Bool;
	public var fuel : Int;
	private var fuelCoolDown : Int;

	public function new(X:Float=0, Y:Float=0)
	{
		super(X, Y);
		loadGraphic("assets/images/Spaceship.png", true, 128, 90);
		trace(width, height);
		animation.add('idle', [0], 0);
		animation.add('gaz', [1], 0);
		animation.add('lowgaz', [1,0,0,1,1,0,1,1,1,0],15,true);
		animation.play('idle');
		engine = false;
		fuel = 600;
		fuelCoolDown = 0;
	}
	override public function update () : Void
	{
		if (engine && fuel>0)
		{
			animation.play('gaz');
			
			if (fuel < 240)
			animation.play('lowgaz');
			
			fuelCoolDown++;
			
		//	if (fuelCoolDown % 60 == 0)
			//{
				fuel--;
		//	}
			
			var k:Int = Registre.engineAcceleration;
			velocity.x += k * Math.cos(FlxAngle.asRadians(angle));
			velocity.y += k * Math.sin(FlxAngle.asRadians(angle));
		}
		
		if (fuel <= 0)
		animation.play("idle");
		
		
		
		if (!engine)
		{
			animation.play('idle');
			fuelCoolDown = 0;
		}
		
		super.update();
	}
	
}
