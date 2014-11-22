package ;

import flixel.animation.FlxAnimation;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.FlxG;

class Spaceship extends FlxSprite
{

	public var engine : Bool;
	private var fuel : Int;
	private var fuelCoolDown : Int;
	static private var k = 10;
	
	public function new(X:Float=0, Y:Float=0)
	{
		super(X, Y);
		loadGraphic("assets/images/Spaceship.png", true, 175, 128);
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
			
			velocity.x -= k * Math.cos(180 / Math.PI * angle);
			velocity.y -= k * Math.sin(180 / Math.PI *angle);
		}
		
		if (!engine)
		{
			animation.play('idle');
			fuelCoolDown = 0;
		}	
		
		super.update();
	}
	
}
