package ;

/**
 * ...
 * @author ...
 */

import flixel.FlxSprite;
import nape.geom.Vec2;
 
class Orbit extends FlxSprite
{
	private var planet:Planet = null;
	public function new() 
	{
		super();
		loadGraphic("assets/images/Trajectoir.png");
	}

	public function updatePlanet(newPlanet:Planet)
	{
		planet = newPlanet;
		// set midpoint of the orbit to the planet midpoint
		x = planet.x - width / 2;
		y = planet.y - height / 2;
	}
	public function updateRadius(velocity:Vec2)
	{
		/// TODO: very bad fix this
	//	width = velocity.x;
		//height = velocity.y;
	}
}