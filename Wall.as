package  {
	
	import flash.display.MovieClip;
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class Wall extends MovieClip {
		
		//var climbable = false;
		//make climbable things a separate class
		
		public function Wall() {
			// constructor code
			Main.walls.push(this);
		}
		
		public function getGlobalPosition():Point
		{
			return MovieClip(this.parent).localToGlobal(new Point(this.x, this.y));
		}
	}
	
}
