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

class Planet extends FlxNapeSprite
{
	
	public function new(X:Float, Y:Float, type : String, mass : Float, space:Space)
	{
		super(X, Y, null, false, true);
		loadGraphic("assets/images/"+type+".png");
		//makeGraphic(512, 512, FlxColor.CORAL);
		createCircularBody(128, BodyType.STATIC);
		setBodyMaterial(1, 0.2, 0.4, mass);
		body.space = space;
	}		
}