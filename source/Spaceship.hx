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
	private var fuel : Int;
	private var fuelCoolDown : Int;

	public function new(X:Float, Y:Float, space:Space)
	{
		super(X, Y, null, false, true);
		loadGraphic("assets/images/Spaceship.png", true, 128, 90);
		createRectangularBody(128, 90, BodyType.DYNAMIC);
		body.space = space;
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
		}
		
		if (!engine)
		{
			animation.play('idle');
			fuelCoolDown = 0;
		}
		
		super.update();
	}
	
}
