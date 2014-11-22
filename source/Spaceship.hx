package ;

import flixel.animation.FlxAnimation;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.FlxG;

class Spaceship extends FlxSprite
{

	public var engine : Bool;
	public function new(X:Float=0, Y:Float=0)
	{
		super(X, Y);
		loadGraphic("assets/images/Spaceship.png", true, 175, 128);
		//		setSize(width, height / 2);//only affect hitbox
		trace(width, height);
		animation.add('idle', [0], 0);
		animation.add('gaz', [1],0);
		animation.play('idle');
		engine = false;
	}
	override public function update () : Void
	{
		if (engine)
		{
			animation.play('gaz');
		}
		
		if (!engine)
		{
			animation.play('idle');
		}
		super.update();
	}
	
}
