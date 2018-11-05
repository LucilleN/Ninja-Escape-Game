package  {
	
	import Main;
	
	import flash.display.MovieClip;
	
	
	public class Rope extends MovieClip {
		
		public var platsAdj:Vector.<Platform> = new Vector.<Platform>();
		
		public function Rope() {
			// constructor code
			Main.ropes.push(this);
		}
	}
	
}
