package  {
	
	import Main;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class Ninja extends MovieClip {
		
		var speedWalk:Number = 5;
		var speedRun:Number = 8;
		var speedClimb:Number = 3;
		var speedJump:Number = 35;
		var speedFall:Number = 0;
		var speedFallMax:Number = 35;
		
		private var wallHitXOffset:Number = 90;
		
		public var mapsCollected:Array = new Array(false);
		
		public var facing:String = "right";
		public var currPlat:Platform = null;
		public var currWall:Wall = null;
		//public var currClimbable:Wall = null;
		public var currRope:Rope = null;
		
		public function Ninja() {
			//this.addEventListener(Event.ENTER_FRAME, onEF);
		}
		
		public function flip():void {
			this.scaleX *= -1;			
			facing = (facing == "right") ? "left" : "right";
		}
		
		public function jump():void
		{
			trace("jump");
			trace(this.currPlat);
			if (this.currRope == null && this.currPlat != null && this.currentLabel != "jumping")
			{
				trace("jump START");
				this.currPlat = null;
				
				this.speedFall = -this.speedJump;
				this.gotoAndStop("jumping");
				this.ninjaJumping.gotoAndPlay("takeoff");
			}
			
		}
		
		public function fall():void
		{
			//trace("fall");
			//trace("this.ninjaJumping.currentLabel: "+this.ninjaJumping.currentLabel);
			if (this.ninjaJumping.currentLabel == "airborne" || this.ninjaJumping.currentLabel == "fall")
			{
				if (this.speedFall < this.speedFallMax) this.speedFall += Main.gravity;
				else this.speedFall = this.speedFallMax;
				//this.y += this.speedFall; we want to move the background instead
				if (speedFall < 0) { //if ninja is rising 
					if (Main.bg.y < Main.bgMaxY + this.speedFall) Main.bg.y -= this.speedFall;
					else Main.bg.y = Main.bgMaxY;
				}
				else if (speedFall > 0) { //if ninja is falling 
					if (Main.bg.y > Main.bgMinY + this.speedFall) Main.bg.y -= this.speedFall;
					else Main.bg.y = Main.bgMinY;
				}
			//}
				// hitTestPoint vs platforms
				for each (var plat:Platform in Main.platforms) {
					if (plat.hitTestPoint(this.x, this.y)) {
						trace("LANDED");
						trace(this.currPlat);
						this.currPlat = plat;
						this.speedFall = 0;
						this.ninjaJumping.gotoAndPlay("landing");
						//find distance between platform y and ninja y, and then move the background
						Main.bg.y += this.y - plat.getGlobalPosition().y;
						break;
					}
				}
				if (this.hitRope()) {
					trace("hit a rope mid fall");
					this.speedFall = 0;
					this.gotoAndStop("idleClimb");
				}
			}
			else if (this.ninjaJumping.currentLabel == "landingEnd") {
				this.gotoAndStop("standing");
			}
		}
		
		public function checkCurrPlat():void {
			trace("checking platform");
			if (this.currPlat)
			{
				trace("has a currPlat");
				if (!this.currPlat.hitTestPoint(this.x, this.y) && this.currRope == null)
				{
					trace("No longer on platform");
					this.currPlat = null;
					this.speedFall = 0;
					this.gotoAndStop("jumping");
					this.ninjaJumping.gotoAndStop("fall");
				}
			}
			/*
			if (this.currRope && !this.currPlat) {
				for each (var plat:Platform in this.currRope.platsAdj) {
					if (plat.hitTestPoint(this.x, this.y)) {
						this.currPlat = plat;
						return;
					}
				}
			}
			*/
			
		}
		
		public function checkCurrRope():void {
			if (this.currRope) {
				if (!this.hit.hitTestObject(this.currRope)) {
					this.currRope = null;
					this.gotoAndStop("jumping");
					this.ninjaJumping.gotoAndStop("fall");
				}
			}
		}
		
		public function hitWall(dir:String, speed:Number):Boolean {
			//trace("hitWall()");
			//*
			var xPos:Number = (dir == "right") ? (this.x + wallHitXOffset + speed) : (this.x - (wallHitXOffset + speed));
			var walls:Vector.<Wall> = (this.currPlat) ? this.currPlat.wallsAdj : Main.walls;
			for each (var wall:Wall in walls) {
				//if (wall.hitTestObject(this.wallHit)) {
				if (wall.hitTestPoint(xPos, this.y)) {
					//trace("hit a wall");
					this.currWall = wall;
					//technically don't need currWall anymore
					return true;
				}
			}
			//*/
			/*
			var wall:Wall;
			if (this.currPlat) {
				trace("this.currPlat.wallsAdj: "+this.currPlat.wallsAdj);
				for each (wall in this.currPlat.wallsAdj) {
					if (wall.hitTestObject(this)) {
						trace("hit a wall");
						return true;
					}
				}
			}
			else {
				trace("Main.walls: "+Main.walls);
				for each (wall in Main.walls) {
					if (wall.hitTestObject(this)) {
						trace("hit a wall");
						return true;
					}
				}
			}
			//*/
			return false;
		}
		
		public function hitRope():Boolean {
			var ropes:Vector.<Rope> = (this.currPlat) ? this.currPlat.ropesAdj : Main.ropes;
			for each (var rope:Rope in ropes) {
				if (this.hit.hitTestObject(rope)) {
					this.currRope = rope;
					//this.gotoAndStop("idleClimb");
					return true;
				}
			}
			this.currRope = null;
			return false;
		}
		
		public function concealed():Boolean {
			//trace("got to concealed(). Main.shades.length is " + Main.shades.length);
			for (var i:int = 0; i < Main.shades.length; i++) {
				//trace("inside concealed forloop");
				if (Main.shades[i].hitTestPoint(this.x, this.y)) {
					//trace("concealed true");
					return true;
				}
			}
			return false;
		}
		
		public function hitByBat():Bat {
			var bat:Bat;
			for each (bat in Main.bats) {
				if ((this.hit.hitTestObject(bat)) && (bat.currentLabel == "flying")) {
					//this.gotoAndStop("attacked");
					//trace("bat current label:" + Main.bats[i].currentLabel);
					trace("ouch just hit by "+bat.name);
					return bat;
				}
			} 
			return null;
		}
		
		
		///*
		public function checkEnemies():void {
			var bat:Bat = this.hitByBat();
			if (bat) {
				this.scaleX = (this.scaleX < 0) ? -this.scaleX : this.scaleX;
				if (this.currPlat) {
					this.gotoAndStop("attacked");
				}
				move(bat.dir, (bat.speedX * Bat.batStrength));
			}
			else {
				if (this.currentLabel == "attacked") {
					this.gotoAndStop("standing");
				}
			}
			
		}
		//*/
		
		public function move(dir:String, speed:Number):void {
			if (!this.hitWall(dir, speed)) { //we are not hitting any walls
				if (dir == "right") {
					if (Main.bg.x > Main.bgMinX + speed) Main.bg.x -= speed;
					else Main.bg.x = Main.bgMinX;
				}
				else if (dir == "left") { 
					if (Main.bg.x < Main.bgMaxX - speed) Main.bg.x += speed;
					else Main.bg.x = Main.bgMaxX;
				}
			}
			else { //we DID hit a wall
				//if (this.currWall) { //technically don't need currWall anymore
				while (this.hitWall(dir, speed)) {
					Main.bg.x = (dir == "right") ? (Main.bg.x + 1) : (Main.bg.x - 1);
				}
				//}
			}
			this.checkCurrPlat();
			this.checkCurrRope();
			//this.checkEnemies();
			if (this.currRope) { //or, if (this.hitRope())
				if (dir == "up") {
					Main.bg.y += speed;
					gotoAndStop("climbing");
					trace("go to and stop climbing");
					trace("ninja current label: " + this.currentLabel);
					this.currPlat == null;
				}
				else if (dir == "down") {
					/*
					if (this.currPlat) {
						while (this.currPlat.hitTestPoint(this.x, this.y-1)) {
							Main.bg.y++;
						}
					}
					*/
					//else {
						Main.bg.y -= speed;
						gotoAndStop("climbing");
						trace("go to and stop climbing");
						trace("ninja current label: " + this.currentLabel);
						//this.checkCurrPlat();
						this.checkCurrRope();
					//}
				}
			}
			//this.checkIfReachedEnd();
			if (!this.mapsCollected[0]) this.checkForMap();
		}
		
		public function checkForMap():void {
			if (this.hitTestObject(Main.bg.map)) {
				this.mapsCollected[0] = true;
				Main.bg.map.visible = false;
				MovieClip(root).mapIcon.visible = true;
				MovieClip(root).mapIcon.gotoAndPlay("appear");
			}
		}
		
		public function checkIfReachedEnd():Boolean {
			//trace(Main.bg.door)
			if (Main.bg.door && this.hit.hitTestObject(Main.bg.door))
			{
				if (Main.bg.door.currentLabel != "opening") {
					trace("about to play door animation");
					Main.bg.door.gotoAndStop("opening");
					return true;
				}
				else {
					if (Main.bg.door.openingDoor.currentLabel == "fully opened") {
						if (this.mapsCollected[0]) {
							MovieClip(root).gotoAndStop("game over");
							MovieClip(root).gameOverPopup.gotoAndStop("win");
						}
						else {
							MovieClip(root).gotoAndStop("game over");
							MovieClip(root).gameOverPopup.gotoAndStop("no map");
						}
					}
				}
			}
			return false;
		}
		
		/*
		public function seenByGuards():void {
			this.gotoAndStop("attacked");
		}
		*/
		
		/*
		function onEF(evt:Event):void {
		
		}
		*/
	}
	
}
