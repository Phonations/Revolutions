package ;
import Std;
import flixel.FlxG;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.FlxCamera;
import flixel.tile.FlxTilemap;

class CameraMove
{
	/**
	 * Creates a new effects tween
	 * @param	coeff		value of the zoom
	 * @param	prevPoint		previous center of the zoom
	 * @param	currentPoint		current center of the zoom
	 */
	public static function zoom(coeff:Float):Void
	{
		//if (FlxG.cameras.list[2].zoom>=.25 && FlxG.cameras.list[2].zoom<=1.75)
		//{
			//zoom/change viewport of the camera
			FlxG.cameras.list[2].zoom += coeff;
			if (FlxG.cameras.list[2].zoom < .25) { FlxG.cameras.list[2].zoom = .25; }
			if (FlxG.cameras.list[2].zoom > 1.75) { FlxG.cameras.list[2].zoom = 1.75; }
			FlxG.cameras.list[2].height = Std.int(Math.ceil(FlxG.height / FlxG.cameras.list[2].zoom));
			FlxG.cameras.list[2].width = Std.int(Math.ceil(FlxG.width / FlxG.cameras.list[2].zoom));

			//set bounds when the level is smaller than the viewport
			if (Registre.LEVEL_SIZE.x < FlxG.cameras.list[2].width && Registre.LEVEL_SIZE.y < FlxG.cameras.list[2].height)
			{ FlxG.cameras.list[2].setBounds(-(FlxG.cameras.list[2].width -Registre.LEVEL_SIZE.x),-(FlxG.cameras.list[2].height-Registre.LEVEL_SIZE.y),FlxG.cameras.list[2].width*2 -Registre.LEVEL_SIZE.x, FlxG.cameras.list[2].height*2 -Registre.LEVEL_SIZE.y, false);}

			if (Registre.LEVEL_SIZE.x < FlxG.cameras.list[2].width && Registre.LEVEL_SIZE.y > FlxG.cameras.list[2].height)
			{FlxG.cameras.list[2].setBounds(-(FlxG.cameras.list[2].width-Registre.LEVEL_SIZE.x)/2,0,FlxG.cameras.list[2].width+(FlxG.cameras.list[2].width-Registre.LEVEL_SIZE.x)/2, Registre.LEVEL_SIZE.y, false);}

			if (Registre.LEVEL_SIZE.x > FlxG.cameras.list[2].width && Registre.LEVEL_SIZE.y < FlxG.cameras.list[2].height)
			{ FlxG.cameras.list[2].setBounds(0,-(FlxG.cameras.list[2].height-Registre.LEVEL_SIZE.y)/2,Registre.LEVEL_SIZE.x, FlxG.cameras.list[2].height+(FlxG.cameras.list[2].height-Registre.LEVEL_SIZE.y)/2, false);}

			if (Registre.LEVEL_SIZE.x > FlxG.cameras.list[2].width && Registre.LEVEL_SIZE.y > FlxG.cameras.list[2].height)
			{ FlxG.cameras.list[2].setBounds(0, 0, Registre.LEVEL_SIZE.x, Registre.LEVEL_SIZE.y, false); }
			/*Registre.BGExt.foregroundGroup.updateBuffers();
			Registre.BGExt.backgroundGroup.updateBuffers();
			Registre.BGExt.backBackgroundGroup.updateBuffers();*/
		//}
	}

	public static function center(prevPoint:FlxPoint, currentPoint:FlxPoint):Void
	{
		//center level based on the offset of the mouse
		FlxG.cameras.list[2].scroll.x -= -prevPoint.x+currentPoint.x;
		FlxG.cameras.list[2].scroll.y -= -prevPoint.y+currentPoint.y;
	}
}
