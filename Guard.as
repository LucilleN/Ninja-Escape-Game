package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import Main;
	import Ninja;
	import flash.geom.Point;
	
	
	public class Guard extends MovieClip {
		
		var speedWalk:Number = 7;
		var speedRun:Number = 15;
		var speedX:Number;
		public var facing:String = "right";
		
		public static var xMax:Number = 0;
		public static var xMin:Number = 0;
		
		public function Guard() {
			// constructor code
			Main.guards.push(this);
			this.addEventListener(Event.ENTER_FRAME, onGuardEF);
		}
		
		/*
		public function patrol():void {
			this.gotoAndPlay("walking");
			this.x += this.speedWalk;
			if (this.x >= Main.bg.guardXMaxPt || this.x <= Main.bg.guardXMinPt) {
				//facing = facing == "right" ? "left" : "right";
				this.scaleX *= -1;
				speedWalk *= -1;
			}
		}
		*/
		
		public function seesNinja():Boolean {
			//trace("seesNinja()");
			if (!Main.player.concealed()) {
				if (this.hitTestObject(Main.player)) {
					trace("guard spotted le ninja");
					return true;
				}
				return false;				
			}
			return false;	
		}
		
		function onGuardEF(evt:Event):void {
			//var bat:MovieClip = evt.currentTarget as MovieClip;
			if (this.currentLabel == "walking") {
				this.speedX = this.speedWalk;
				this.x += this.speedX; 
				if (this.x >= xMax || this.x <= xMin) {
					flip();
				}
			}
			if (seesNinja()) {
				moveGuardTowardNinja();
				if (Main.player.hit.hitTestObject(this.hit)) {
					trace("guard went to the ninja");
					MovieClip(root).gotoAndStop("game over");
					MovieClip(root).gameOverPopup.gotoAndStop("caught");
					Main.stopAllEnemies();
				}

				/*
				for each (var guard:Guard in Main.guards) {
					guard.gotoAndStop("standing");
				}
				*/
				
			}
		}
		
		public function flip():void {
			this.scaleX *= -1;			
			facing = (facing == "right") ? "left" : "right";
			speedWalk *= -1;
		}
	
		public function moveGuardTowardNinja():void {
			var guardGlobPos:Point = MovieClip(this.parent).localToGlobal(new Point(this.x, this.y))
			speedX = (speedX < 0) ? -speedRun : speedRun;
			if ((Main.player.x < guardGlobPos.x && facing == "right") || (Main.player.x > guardGlobPos.x && facing == "left")) { 
				flip();
			}
			if (!Main.player.hit.hitTestObject(this.hit))
			{
				trace("MOVE TO NINJA");
				this.x += speedX;
			}
			gotoAndStop("seesNinja");
		}  	
	}

}
