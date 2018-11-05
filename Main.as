package  {
	
	import Ninja;
	import Bat;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	
	
	public class Main extends MovieClip {
		
		public static var leftPressed:Boolean = false;
		public static var rightPressed:Boolean = false;
		public static var upPressed:Boolean = false;
		public static var downPressed:Boolean = false;
		
		public static var sPressed:Boolean = false; //shurikens
		public static var bPressed:Boolean = false; //bo staff
		public static var gPressed:Boolean = false;	//grappling hook
		public static var kPressed:Boolean = false; //shuko claws
		public static var cPressed:Boolean = false; //cricket
		
		public static var spacePressed:Boolean = false;
		
		public static var gravity:Number = 2;
		
		public static var player:Ninja;
		
		public static var bg:MovieClip;
		
		public static var platforms:Vector.<Platform> = new Vector.<Platform>();
		public static var walls:Vector.<Wall> = new Vector.<Wall>();
		public static var shades:Vector.<Shade> = new Vector.<Shade>();
		public static var guards:Vector.<Guard> = new Vector.<Guard>();
		public static var bats:Vector.<Bat> = new Vector.<Bat>();
		public static var ropes:Vector.<Rope> = new Vector.<Rope>();
		
		public static var bgMaxX:Number = -160;
		public static var bgMinX:Number = -2220;
		public static var bgMaxY:Number = 0;
		public static var bgMinY:Number = -995;
		
		public static var bgStartX = -300;
		public static var bgStartY = -700;
		
		public static var reachedEndOfGame:Boolean = false;
		
		public function Main() {
			stage.focus = stage;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPressed);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyReleased);
			
			this.addEventListener(Event.ENTER_FRAME, onEF);
			/*
			platforms = new Vector.<Platform>();
			platforms = new Vector.<Platform>();
			platforms = new Vector.<Platform>();
			platforms = new Vector.<Platform>();
			platforms = new Vector.<Platform>();
			*/
			
			/*
			Bat.setUpBat(MovieClip(root).bg.bat1);
			Bat.setUpBat(MovieClip(root).bg.bat2);
			Bat.setUpBat(MovieClip(root).bg.bat3);
			Bat.setUpBat(MovieClip(root).bg.bat4);
			Bat.setUpBat(MovieClip(root).bg.bat5);
			Bat.setUpBat(MovieClip(root).bg.bat6);
			Bat.setUpBat(MovieClip(root).bg.bat7);
			*/
		}
		
		private function onKeyPressed(evt:KeyboardEvent):void {
			switch (evt.keyCode) {
				case Keyboard.LEFT:
					leftPressed = true;
				break;
				case Keyboard.RIGHT:
					rightPressed = true;
				break;
				case Keyboard.UP:
					upPressed = true;
				break;
				case Keyboard.DOWN:
					downPressed = true;
				break;
				case Keyboard.S:
					sPressed = true;
				break;
				case Keyboard.B:
					bPressed = true;
				break;
				case Keyboard.G:
					gPressed = true;
				break;
				case Keyboard.K:
					kPressed = true;
				break;
				case Keyboard.C:
					cPressed = true;
				break;
				case Keyboard.SPACE:
					spacePressed = true;
				break;
			}
		}
		
		function onKeyReleased(evt:KeyboardEvent):void {
			switch (evt.keyCode) {
				case Keyboard.LEFT:
					leftPressed = false;
				break;
				case Keyboard.RIGHT:
					rightPressed = false;
				break;
				case Keyboard.UP:
					upPressed = false;
				break;
				case Keyboard.DOWN:
					downPressed = false;
				break;
				case Keyboard.S:
					sPressed = false;
				break;
				case Keyboard.B:
					bPressed = false;
				break;
				case Keyboard.G:
					gPressed = false;
				break;
				case Keyboard.K:
					kPressed = false;
				break;
				case Keyboard.C:
					cPressed = false;
				break;
				case Keyboard.SPACE:
					spacePressed = false;
				break;
			}
		}
		
		public static function pairWallsWithPlats():void
		{
			trace("pairWallsWithPlats()");
			trace(Main.platforms);
			// pair up walls with platforms
			for each (var platform:Platform in Main.platforms)
			{
				for each (var wall:Wall in Main.walls)
				{
					if (wall.hitTestObject(platform)) {
						platform.wallsAdj.push(wall);
					}
				}
			}			
		}
		
		public static function pairRopesWithPlats():void
		{
			for each (var platform:Platform in Main.platforms)
			{
				for each (var rope:Rope in Main.ropes)
				{
					if (rope.hitTestObject(platform)) {
						platform.ropesAdj.push(rope);
						rope.platsAdj.push(platform);
					}
				}
			}			
		}
		
		function onEF(evt:Event):void {
			if (this.currentLabel == "game") { 
				moveNinja();
				useWeapons();
				reachedEndOfGame = player.checkIfReachedEnd();
				if (reachedEndOfGame) stopAllEnemies();
				//bg.guard2.patrol();
			}
		}
		
		/*
		function willBeInBounds():Boolean {
			if (bg.x > bgMaxX - ninja.speedWalk || bg.x < bgMinX + ninja.speedWalk) {
				return false;
			}
			if (bg.y > bgMaxY - ninja.speedWalk || bg.y < bgMinY + ninja.speedWalk) {
				return false;
			}
			else {
				return true;
			}
		}
		*/
		
		function moveNinja():void {
			
			var bat:Bat;
			
			if (player.currentLabel == "jumping")
			{
				player.fall();
			}
			else if (player.currentLabel == "bo staff") {
				for each (bat in Main.bats) {
					if (player.weaponHit.hitTestObject(bat)) {
						bat.resetBat();
						//bat.gotoAndPlay("spawn");
					}
				}
				
				
				return;
			}
			
			player.checkEnemies();
			///*
			bat = player.hitByBat();
			if (bat) {
				trace("STILL HITTING BAT: "+bat.name);
				return;
				//player.move("left", Bat.batStrength);
				//bg.x += Bat.batStrength;
			}
			//*/
			
			
			
			if (leftPressed) {
				//if (!player.hitWall("left")) {
				player.move("left", player.speedWalk);
				//player.checkCurrPlat();
				if (ninja.currentLabel == "standing" || ninja.currentLabel == "attacked") {
					ninja.gotoAndStop("walking");
				}
				if (ninja.facing != "left") {
					ninja.flip();
				}
				//}
				/*
					else {
					while (player.hitWall("left")) {
						trace("move BG left");
						bg.x --;
					}
				}
				*/
					
			}
			if (rightPressed) {
				//if (!player.hitWall("right")) {
				player.move("right", player.speedWalk);
				//player.checkCurrPlat();
				if (ninja.currentLabel == "standing" || ninja.currentLabel == "attacked") {
					ninja.gotoAndStop("walking");
				}
				if (ninja.facing != "right") {
					ninja.flip();
				}
				//}
				/*
				else {
					while (player.hitWall("right")) {
						trace("move BG right");
						bg.x ++;
					}
				}
				*/

			}
			if (downPressed) {
				if (player.hitRope()) {
					player.move("down", player.speedClimb);
				}
				//trace(bg.y);
				/*
				if (bg.y > bgMinY + ninja.speedWalk) bg.y -= ninja.speedWalk;
				else bg.y = bgMinY;
				player.checkCurrPlat();
				if (ninja.currentLabel == "standing") {
					ninja.gotoAndStop("walking");
				}
				*/
			}
			if (upPressed) {
				if (player.hitRope()) {
					player.move("up", player.speedClimb);
				}
				else {
					player.jump();
				}
				//trace(player.currPlat);
				// possible check for ladders?
				
				/*
				if (bg.y < bgMaxY - ninja.speedWalk) bg.y += ninja.speedWalk;
				else bg.y = bgMaxY;
				if (ninja.currentLabel == "standing") {
					ninja.gotoAndStop("walking");
				}
				*/
			}
			if (!leftPressed && !rightPressed) // && !upPressed && !downPressed)
			{
				if (ninja.currentLabel == "walking")
				{
					ninja.gotoAndStop("standing");
				}
				/*
				else if (ninja.currentLabel == "climbing") {
					ninja.gotoAndStop("idleClimb");
				}
				*/
			}
			if (!upPressed && !downPressed) {
				if (ninja.currentLabel == "climbing") {
					trace("ninja current label: " + ninja.currentLabel);
					ninja.gotoAndStop("idleClimb");
				}
			}
		}
		
		function useWeapons():void {
			if (bPressed) {
				if (player.currentLabel == "standing") {
					player.gotoAndStop("bo staff");
				}
			}
			else {
				if (player.currentLabel == "bo staff") {
					player.gotoAndStop("standing");
				}
			}
		}
		
		
		public static function randomInteger(min:int, max:int):int {
			if (min > max) {
				var swapTemp = min;
				min = max;
				max = swapTemp;
			}
			return Math.floor(Math.random() * (max - min) + min);
		}
		
		public static function stopAllEnemies():void {
			for each (var guard:Guard in guards) {
				guard.removeEventListener(Event.ENTER_FRAME, guard.onGuardEF);
			}
			for each (var bat:Bat in bats) {
				bat.removeEventListener(Event.ENTER_FRAME, bat.onBatEF);
			}
		}
	}
	
	
	
}
