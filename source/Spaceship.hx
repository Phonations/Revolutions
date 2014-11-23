package ;

import flixel.animation.FlxAnimation;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.FlxG;
import flixel.util.FlxAngle;

import flixel.addons.nape.FlxNapeSprite;

import nape.space.*;
import nape.geom.*;
import nape.phys.*;
import nape.shape.*;

class Spaceship extends FlxNapeSprite
{

	public var engine : Bool;
	public var fuel : Int;

	public function new(X:Float, Y:Float, space:Space)
	{
		super(X, Y, null, false, true);
		loadGraphic("assets/images/Spaceship.png", true, 128, 90);
		createRectangularBody(128, 90, BodyType.DYNAMIC);
		body.space = space;
		trace(width, height);
		animation.add('idle', [0], 0);
		animation.add('gaz', [1], 0);
		animation.add('lowgaz', [1,0,0,1,1,0,1,1,1,0],15,true);
		animation.play('idle');
		engine = false;
		fuel = 600;
	}
	override public function update () : Void
	{
		if (engine && fuel>0)
		{
			animation.play('gaz');
			
			if (fuel < 240)
				animation.play('lowgaz');
			
			fuel--;

		}
		
		if (fuel <= 0)
			animation.play("idle");
		
		if (!engine)
		{
			animation.play('idle');
		}
		
		super.update();
	}
	
}
