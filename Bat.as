package  {
	
	import Main;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class Bat extends MovieClip {
		
		var speedMin:Number = 8;
		var speedMax:Number = 16;
		var bufferY:Number = 50;
		var maxY:Number = 950;
		var minY:Number = 800;

		public static var batStrength:Number = -0.5;

		public static var resetXMin:Number = 0;
		public static var resetXMax:Number = 0;
		
		public var speedX:Number = 0;
		
		public var dir:String;
		
		public function Bat() {
			// constructor code
			trace("constructed bat");
			Main.bats.push(this);
			setupBat();
		}
		
		public function setupBat():void {
			trace("setupBat");
			resetBat(false);
			this.addEventListener(Event.ENTER_FRAME, onBatEF);
		}

		public function resetBat(respawn:Boolean = true):void {
			trace("resetBat: "+this.name);
			//this.speedX = Math.floor(Math.random()*(speedMax - speedMin) + speedMin);			
			//this.y = Math.floor(Math.random()*(maxY - minY) + minY);			
			//this.x = Math.floor(Math.random()*(resetXMax - resetXMin) + resetXMin);			
			this.speedX = -Main.randomInteger(this.speedMin, this.speedMax); // forcing negative for now
			this.dir = "left"; //(this.speedX < 0) ? "left" : "right";
			this.y = Main.randomInteger(this.minY, this.maxY);
			this.x = Main.randomInteger(resetXMin, resetXMax);
			if (respawn) this.gotoAndPlay("spawn");
		}

		function onBatEF(evt:Event):void {
			//trace("onBatEF: "+this.name);
			//var bat:MovieClip = evt.currentTarget as MovieClip;
			if (this.currentLabel == "flying") {
				this.x += this.speedX; 
			}
			if (this.x <= -20) {
				resetBat();
				//this.gotoAndPlay("spawn");
			}
		}

	}
	
}
