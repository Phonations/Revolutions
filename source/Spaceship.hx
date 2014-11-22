package ;

import flixel.animation.FlxAnimation;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.FlxG;

class Spaceship extends FlxSprite
{

	public function new(X:Float=0, Y:Float=0)
	{
		super(X, Y);
		loadGraphic("assets/images/Spaceship.png", true, 128, 128);
		//		setSize(width, height / 2);//only affect hitbox
		trace(width, height);
		/*animation.add('idle', [0, 1, 2, 3, 4, 5], 5);
		animation.play('idle');*/
	}
}
