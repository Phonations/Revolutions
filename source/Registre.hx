package;

import flixel.util.FlxPoint;
import flixel.util.FlxSave;



class Registre
{
	public static var levels:Array<Dynamic> = [];
	public static var CoefScale : FlxPoint;
	public static var mobileZoom : Int;
	public static var level : Int;
	public static var LEVEL_SIZE : FlxPoint;
	
	public static var saves:Array<FlxSave> = [];
	
	// Loaded from the level
	public static var spaceshipAngleAcceleration:Float = 0.1;
	public static var spaceshipMaxAngleVelocity:Float = 2;
	public static var spaceshipEngineAcceleration:Float = 1;
	
	public static var gravitationConstant = 10000000;
}