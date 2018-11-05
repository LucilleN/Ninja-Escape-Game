package  {
	
	import Main;
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import Wall;
	
	
	public class Platform extends MovieClip {
		
		public var wallsAdj:Vector.<Wall> = new Vector.<Wall>();
		public var ropesAdj:Vector.<Rope> = new Vector.<Rope>();
		
		public function Platform() {
			// constructor code
			Main.platforms.push(this);
			//trace("Main.walls: "+Main.walls);
		}
		
		public function getGlobalPosition():Point {
			return MovieClip(this.parent).localToGlobal(new Point(this.x, this.y));
		}
	}
	
}
