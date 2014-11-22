package ;

import flixel.animation.FlxAnimation;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.FlxG;

class Planet extends FlxSprite
{
	
	public function new(X:Float=0, Y:Float=0, type : String, mass : String) 
	{
		super(X, Y);
		loadGraphic("assets/images/PlaneteCreuse.png", true, 512, 512);
	}		
}