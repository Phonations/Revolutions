package ;

import flixel.animation.FlxAnimation;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.addons.nape.FlxNapeSprite;
import flixel.util.*;
import nape.space.*;
import nape.geom.*;
import nape.phys.*;
import nape.shape.*;
import Orbit;

class Planet extends FlxNapeSprite
{
	public var orbit:Orbit;
	
	public function new(X:Float, Y:Float, type : String, mass : Float, space:Space)
	{
		super(X, Y, null, false, true);
		loadGraphic("assets/images/PlaneteStart.png");
		createCircularBody(128, BodyType.STATIC);
		body.space = space;
		/*orbit = new Orbit(mass);
		orbit.x = x;
		orbit.y = y;*/
	}		
}