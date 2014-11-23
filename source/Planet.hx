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
	public var type:String;
	public function new(X:Float, Y:Float, radius:Float, _type : String, mass : Float, space:Space)
	{
		super(X, Y, null, false, true);
		type = _type;

		var size:Int = Math.ceil(radius);
		loadGraphic("assets/images/" + type+".png");
		FlxG.log.add(radius);
		scale.x = radius / width;
		scale.y = radius / height;
		//makeGraphic(512, 512, FlxColor.CORAL);
		createCircularBody(radius, BodyType.STATIC);
		setBodyMaterial(1, 0.2, 0.4, mass);
		body.space = space;
		updateHitbox();
	}		
}