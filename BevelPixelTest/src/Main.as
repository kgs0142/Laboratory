package 
{
	import flash.display.Sprite;
	import flash.events.Event;
    import org.flixel.FlxG;
    import org.flixel.FlxGame;
	
	/**
	 * ...
	 * @author Husky
	 */
    [SWF(width = "540", height = "360", backgroundColor = "#CCCCCC")]
	public class Main extends FlxGame 
	{
		
		public function Main():void 
		{
            super(180, 120, CCreateModule, 3, 60, 60);
            
            FlxG.debug = true;
            FlxG.mouse.show();
		}
	}
}