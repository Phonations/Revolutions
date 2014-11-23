package ;

/**
 * ...
 * @author ...
 */

import flixel.FlxSprite;
 
class Orbit extends FlxSprite
{
	var planetMass:Float;
	public function new(mass:Float) 
	{
		super();
		planetMass = mass;
		loadGraphic("assets/images/Trajectoir.png");
	}
	

}