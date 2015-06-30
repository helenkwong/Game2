package {
	import flash.media.*;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.geom.Rectangle;
	import flash.events.KeyboardEvent;

	/*---------------the class for each character-----------------------*/
	public class KeyBoard extends MovieClip {
		/*-----------------------------Properties------------------------*/
		
		//speed
		private var keyPressArray:Array = new Array();
		private var keyPressCounter:int = 0; 
		public var arrowObjectArray:Array= new Array();
		private var charExerciseNum:int;
		public var mc_arrow_37:MovieClip;
		public var mc_arrow_38:MovieClip;
		public var mc_arrow_39:MovieClip;
		public var mc_arrow_40:MovieClip;
		public var mc_keyboardShape:MovieClip;

		
		/*-----------------------------constructor-----------------------------*/
		public function KeyBoard(exerciseNum,gameLevel) {
			var arrowSpace:int = 80;
			this.visible = true;
			arrowObjectArray [0] = this.mc_arrow_37;
			arrowObjectArray [1] = this.mc_arrow_38;
			arrowObjectArray [2] = this.mc_arrow_39;
			arrowObjectArray [3] = this.mc_arrow_40;
			charExerciseNum = exerciseNum;
			for(var i:int = 0 ; i<4; i++){
				arrowObjectArray[i].visible = false;
			}
			this.scaleX = 0.3;
			this.scaleY = 0.3;
			
			switch (exerciseNum){
				case 0:{this.x = -275;this.y=-100;break;}
				case 1:{this.x = -200;this.y=-120;break;}
				case 2:{this.x =115;this.y=-120;break;}
				case 3:{this.x = 50;this.y=-100;break;}
			};
			
			var arrayToRandom:Array = new Array(37,38,39,40);
			var qRequired:Number = Math.random()*10%3+1;
			if(gameLevel == 2){
			qRequired =1;
			arrowSpace = 80;
			}
			// Outputs numbers non-repeated
			for(var q:Number = 0; q<qRequired; q++){
				var randomPos:int = Math.random()*arrayToRandom.length;	
				var randomNumber = arrayToRandom[randomPos];
				keyPressArray.push(randomNumber);
				arrayToRandom.splice(randomPos,1);
			}
		
			for(var w:int = 0; w<keyPressArray.length;w++){
				arrowObjectArray[keyPressArray[w]-37].x = 110*w+arrowSpace;
				arrowObjectArray[keyPressArray[w]-37].visible = true;
				if(w == 0 && keyPressArray.length == 1 && (keyPressArray[w] == 37 || keyPressArray[w] == 39) ){
					arrowObjectArray[keyPressArray[w]-37].x= arrowObjectArray[keyPressArray[w]-37].x -10;
				}
			}

			if(gameLevel == 2){
			this.mc_keyboardShape.width = 140;
			this.y = this.y -50;
			this.scaleX = 0.45;
			this.scaleY = 0.45;
			this.x = this.x + 30;
			}
			if(gameLevel ==3){
				this.x = this.x + (4 - keyPressArray.length)*15;
				this.mc_keyboardShape.width = keyPressArray.length*110+40;
			}
		}
		

/*---Listener ---------------------------*/
		public function addListenerKey():void{
			stage.addEventListener(KeyboardEvent.KEY_UP,keyHandlerFunction);
		}
		
		public function keyPressComplete(evt:Event){
			if(this.alpha >0){
				this.alpha = this.alpha -0.1;
			}
			else {
				stage.removeEventListener(KeyboardEvent.KEY_UP,keyHandlerFunction);
				this.removeEventListener(Event.ENTER_FRAME,keyPressComplete);
				MovieClip(root).currentCharacterObject.FinishExercise = true;
				MovieClip(root).exerciseActionComplete();
				MovieClip(root).topObjectContainer.removeChild(this);

			}
		}
	
		public function keyHandlerFunction(keyEvt:KeyboardEvent){
				
			var keyFrameVar:int = 0;
			var tempCounter:int = keyPressCounter;
			MovieClip(root).playSoundKey(0);
			if(keyPressArray[keyPressCounter] == keyEvt.keyCode){
				keyPressCounter =keyPressCounter +1;
				
				//trace(MovieClip(root).currentCharacterObject.name);
				MovieClip(root).currentCharacterObject.PlayExerciseTime += 1;
				keyFrameVar=2;
			
				if (MovieClip(root).currentCharacterObject.PlayExerciseTime==1){
					
					MovieClip(root).currentCharacterObject.gotoAndPlay(MovieClip(root).exerciseObjectArray[charExerciseNum][2]);
					
					if(charExerciseNum ==0){
					MovieClip(root).exerciseObjectArray[0][1].gotoAndPlay(2);
					}
				}
			}
			
			else{
				keyFrameVar=3;  //keywrong
				if(MovieClip(root).gameLevel ==3){
					MovieClip(root).gameMark = MovieClip(root).gameMark -2;
					MovieClip(root).markUpdate();
				}
			
			}
				
			arrowObjectArray[keyPressArray[tempCounter]-37].gotoAndStop(keyFrameVar);
			
			if(keyPressCounter == keyPressArray.length){
				
				stage.removeEventListener(KeyboardEvent.KEY_UP,keyHandlerFunction);
				this.addEventListener(Event.ENTER_FRAME,keyPressComplete);
			}
			keyEvt.updateAfterEvent();
		}



	}//end of the class
}//end of the program