package {
	import flash.display.MovieClip;
	import flash.ui.Mouse;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.geom.Rectangle;
	

/*---the class for each character------------------------------------------------------------*/

	public class Character extends MovieClip {
/*---Properties------------------------------------------------------------------------------*/
		//Timer
		public var myTimer:Timer=new Timer(1000,16);
		
		public var target0:MovieClip;
		public var hat:MovieClip;

		//speed
		protected var walkingSpeed:int=30;
		protected var tempSpeed:Number=0;

		//coordinate
		protected var computerX:Number;
		protected var computerY:Number;
		protected var startPointX:Number;
		protected var startPointY:Number;
		protected var velocityX:Number;
		protected var velocityY:Number;
		protected var goToComputerNo:Number;
		
		public function get GoToComputerNo():int{
			return goToComputerNo;
		}

		protected var exerciseNum:Number;
		
		public function get ExerciseNum():int{
			return exerciseNum;
		}
		
		public function set ExerciseNum(exerciseNum:int):void{
			if ( exerciseNum> -2 && exerciseNum <4){
				this.exerciseNum  = exerciseNum;
			}
		}
		
		protected var playExerciseTime:Number=0;
		
		public function get PlayExerciseTime():int{
			return playExerciseTime;
		}
		
		public function set PlayExerciseTime(playExerciseTime:int):void{
			if (playExerciseTime > -1 && playExerciseTime <5){
				this.playExerciseTime  = playExerciseTime;
			}
		}
		
		protected var finishExercise:Boolean=false;
		
		public function get FinishExercise():Boolean{
			return finishExercise;
		}
		
		public function set FinishExercise(finishExercise:Boolean):void{
				this.finishExercise  = finishExercise;
		}
		
		protected var characterStage:String;
		protected var isdeath:Boolean=false;
		
		public function get Isdeath():Boolean{
			return isdeath;
		}
		
		public function set Isdeath(isdeath:Boolean):void{
				this.isdeath = isdeath;
		}
		
		protected var characterDragEnable:Boolean=false;
		
		public function get CharacterDragEnable():Boolean{
			return characterDragEnable;
		}
		
		protected var gameLevel:int;
		protected var characterNum:int;
		
		public function get CharacterNum():int{
			return characterNum;
		}
	
		protected var isMouseOverOnMe:Boolean = false;
		
		protected var stage1Time:int = 8;
		protected var stage2Time:int = 12;
		protected var stage3Time:int = 16;
		
		protected var tempIndexBeforeDrag:int = 10;
	
/*---constructor-----------------------------------------------------------------------------*/
		public function Character(goToCompNo:Number,startPtX:Number,startPtY:Number,gameLevel:int,characterNum:Number) {
			
			this.gameLevel = gameLevel;
			this.characterNum = characterNum;
			this.width=90;
			this.height=130;
			
			this.x = startPtX;
			this.y = startPtY;
			
			stage1Time = int(Math.random()*10%3)+5;
			stage2Time = int(Math.random()*10%3)+9;

			if(gameLevel > 1){
			stage1Time = int(Math.random()*10%3)+7;
			stage2Time = int(Math.random()*10%3)+11;
			}
			initCharacter(goToCompNo,startPtX,startPtY);
		}
		
/*---Method - initCharacter -----------------------------------------------------------------*/
		protected function initCharacter(goToCompNo:Number,startPtX:Number,startPtY:Number):void {

			this.startPointX = startPtX;
			this.startPointY = startPtY;
			goToComputerNo=goToCompNo;
	
			switch (goToComputerNo) {
				case 0 :{computerX=97;computerY=378;break;};
				case 1 :{computerX=204;computerY=380;break;};
				case 2 :{computerX=277;computerY=391;break;};
				case 3 :{computerX=387;computerY=390;break;};
				case 4 :{computerX=450;computerY=379;break;};
				case 5 :{computerX=560;computerY=380;break;};
				default :{trace("error");break;}
			};
			randomSpeed();
			characterStage="walkToComp";
			var randomStart:int=(Math.random()*10*goToComputerNo*7)%5+5;
			gotoAndPlay(randomStart);
		
			myTimer.reset();
			myTimer.start();
			
			this.addEventListener(Event.ENTER_FRAME,myEnterFrame);
			this.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
			
	
		}
/*---Method- random Speed--------------------------------------------------------------------*/
		protected function randomSpeed():void{
			tempSpeed = 0;
			var preDistance:int = Math.pow((computerX-startPointX),2)+Math.pow((computerY-startPointY),2);
			var distance:int = Math.pow(preDistance,0.5);
			walkingSpeed=distance/((Math.random()*10%8)+5);
			velocityX = (computerX-startPointX)/walkingSpeed;
			velocityY = (computerY-startPointY)/walkingSpeed;

			if(computerX-startPointX >=0){
				this.scaleX = 0.8;
			}
			else {
				this.scaleX =-0.8;
			}
}
		
/*---Listener--------------------------------------------------------------------------------*/

/*---mouse Down-(Trigger Method)-------------------------------------------------------------*/		
		public function mouseDownTrigger():void{
			myTimer.stop();
			this.removeEventListener(Event.ENTER_FRAME,myEnterFrame);
			this.removeEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
			this.removeEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
			gotoAndPlay("wantPlayComp");
			characterStage="wantPlayComp";
			this.removeEventListener(Event.ENTER_FRAME,myEnterFrame);
		}
/*---mouse Out-(Listener-Mouse)--------------------------------------------------------*/
		public function mouseOutHandler(evt:MouseEvent):void {
			MovieClip(root).myCursor.gotoAndStop("mouseMove");
			isMouseOverOnMe = false;
			//trace("mouseOUT");
			this.removeEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
			evt.updateAfterEvent();
		}
		
		
/*---mouse Over-(Listener-Mouse)-------------------------------------------------------------*/
		public function mouseOverHandler(evt:MouseEvent):void {
			
			isMouseOverOnMe = true;
			this.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
			if (characterDragEnable==true) {
				MovieClip(root).myCursor.gotoAndStop("mouseOn");
			}
			else {
					MovieClip(root).myCursor.gotoAndStop("mouseMove");
				}
			evt.updateAfterEvent();
		}
/*---mouse Up-(Trigger method from stage)----------------------------------------------------*/
		public function mouseUpHandlerTrigger(exerciseFrame:String,exercsieNumber:int):int {
			//character go to and stop at particlar frame
			this.exerciseNum=exercsieNumber;
			this.gotoAndStop(exerciseFrame);
			characterDragEnable=false;

			if(exerciseNum != -1){
				this.scaleX = 0.8;
				characterStage="playExercise";
				if(exerciseNum==2){
					this.gotoAndStop("skating");
				}
				if(gameLevel ==1 ){
					playExerciseTime=2;
					this.play();
				}
				if(gameLevel>1 && exerciseNum==2){
					this.play();
				}
				if (myTimer.currentCount<stage2Time) {
					return 3;
				} else {
					return 1;
				}
			}
			else{
				startPointX=this.x;
				startPointY=this.y;
				randomSpeed();
				characterStage="walkToComp";
				this.play();
				this.addEventListener(Event.ENTER_FRAME,myEnterFrame);
				return 0;
			}
		}
/*---Enter Frame-(Listner- event)------------------------------------------------------------*/
		protected function myEnterFrame(evt:Event):void {
			
			//setting for the mouse
			switch (characterStage) {
				case "walkToComp" :{
						
						if (tempSpeed<walkingSpeed) {
							this.x = this.x + velocityX;
							this.y = this.y + velocityY;
							tempSpeed=tempSpeed+1;
						} 
						else {
							this.x = computerX;
							this.y = computerY;
							
							//if the character arrive the computer
								if(goToComputerNo%2 != 0){
									this.scaleX = -0.8;
								}
								else {
									this.scaleX = 0.8;
								}
							//set the index
							var position2:Number=MovieClip(root).numChildren-3;

							if (goToComputerNo!=2&&goToComputerNo!=3) {

								if (MovieClip(root).computerArray[2]==false) {
									position2=position2-1;
								}
								if (MovieClip(root).computerArray[3]==false) {
									position2=position2-1;
								}
							}
							
							MovieClip(root).setChildIndex(this,position2);
							
							if (myTimer.currentCount<stage1Time) {
								characterStage="stageOneStand";
								gotoAndPlay("stageOneStand");
							} else if (myTimer.currentCount>stage1Time-1 && myTimer.currentCount<stage2Time) {
								characterStage="stageTwoDrag";
								gotoAndPlay("stageTwoDrag");
								characterDragEnable = true;
							} else if (myTimer.currentCount >stage2Time-1 && myTimer.currentCount <stage3Time) {
								characterStage="stageThreeFinalDrag";
								gotoAndPlay("stageThreeFinalDrag");
								characterDragEnable = true;
							}
							if(isMouseOverOnMe == true && characterDragEnable == true){
								MovieClip(root).myCursor.gotoAndStop("mouseOn");
								stage.addEventListener(MouseEvent.MOUSE_MOVE,MovieClip(root).mouseMoveHandler);
								stage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_MOVE,true,false));
							}
							this.removeEventListener(Event.ENTER_FRAME,myEnterFrame);
							this.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
							this.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
							myTimer.addEventListener(TimerEvent.TIMER,timerListener);
							myTimer.start();
							
						}
						break;
					};

				case "stageSixLeaveStage" :{
						
						if (tempSpeed<walkingSpeed) {
							this.x = this.x + velocityX;
							this.y = this.y + velocityY;
							tempSpeed=tempSpeed+1;
						} else {
							characterDie();
						}
						break;

					};
				case "stageFourDeath" :
					{
						
						if (this.currentLabel=="stageFourDeathEnd") {
							this.removeEventListener(Event.ENTER_FRAME,myEnterFrame);
							this.removeEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
							//this.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
							this.stop();
							isdeath=true;
							MovieClip(root).addCharacterEnable=true;
							MovieClip(root).liveUpdate();
							characterDie();
						}
						break;
				}
			}
		};
		

/*---Timer-(Listner- time)-------------------------------------------------------------------*/
		protected function timerListener(e:TimerEvent):void {
			
			if (myTimer.currentCount>stage1Time-1 && myTimer.currentCount<stage3Time) {
				characterDragEnable=true;
			}

			if (myTimer.currentCount==stage1Time){
				gotoAndPlay("stageTwoDrag");
				//characterDragEnable=true;
				
			}
			if (myTimer.currentCount==stage2Time) {
				gotoAndPlay("stageThreeFinalDrag");
			}
			if (myTimer.currentCount==stage3Time) {
				characterDragEnable=false;
				MovieClip(root).computerArray[goToComputerNo]=true;
				this.removeEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
				//this.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
				this.addEventListener(Event.ENTER_FRAME,myEnterFrame);
				myTimer.stop();
				gotoAndPlay("stageFourDeath");
				characterStage="stageFourDeath";
			}
		}
/*---Method - Finish exercise one time-------------------------------------------------------*/
		protected function completeExercise(exerciseStatus:String) {
			stop();
			playExerciseTime=playExerciseTime-1;
			
			if (playExerciseTime==0 && gameLevel ==1) {
				finishExercise=true;
			}
			if(finishExercise == false && exerciseNum ==2){
				gotoAndStop("skatingBack");
			}
			
			if (playExerciseTime>0){
				this.gotoAndPlay(MovieClip(root).exerciseObjectArray[exerciseNum][2]);
			}
			
			else if (finishExercise == true) {
						
				MovieClip(root).exerciseObjectArray[exerciseNum][6].visible = false;
				MovieClip(root).exerciseObjectArray[exerciseNum][6].gotoAndStop(1);
			
				if (exerciseStatus=="finishJumpingPart1") {
					gotoAndPlay("jumpingDown");
				} else if (exerciseStatus=="finishSkatingPart1") {
					gotoAndPlay("skating3");
				} else if (exerciseStatus == "dumbbellDown") {
					gotoAndPlay("dumbbellDown");
				} else if (exerciseStatus == "jumpRopeDown") {
					gotoAndPlay("jumpRopeDown");
				} 
				else if (exerciseStatus == "doneExercise") {
					
					if (exerciseNum==0||exerciseNum==1) {
						startPointY=startPointY+50;
						this.y=this.y+50;
						startPointX=startPointX+20;
						this.x=this.x+20;
					} else if(exerciseNum ==3){
						startPointY=startPointY+50;
						this.y=this.y+50;
						startPointX=startPointX-30;
						this.x=this.x-30;
					}
					else{
						startPointY=startPointY+40;
						this.y=this.y+40;
						startPointX=startPointX-80;
						this.x=this.x-80;		
					}
					
					MovieClip(root).exerciseObjectArray[exerciseNum][0].gotoAndStop(1);
					MovieClip(root).exerciseObjectArray[exerciseNum][1].visible = true;
					MovieClip(root).exerciseArray[exerciseNum]=true;
					playExerciseTime = 0;
					finishExercise=false;
					restart();
					//trace("finish");
				}
			}
		}
/*---Method -restart-After finish the exercise , restart the character-----------------------*/
		protected function restart():void {
			
			startPointX=this.x;
			startPointY=this.y;
						
			var position:Number=8;
			// choice one : leave stage 
			if (myTimer.currentCount%2==0) {
				characterStage="stageSixLeaveStage";

				if (exerciseNum!=1&&exerciseNum!=3) {
					if(exerciseNum==0){
					computerX=-10;computerY=300;
					}
					else{
					computerX=670;computerY=300;
					}
					
					randomSpeed();
					gotoAndPlay("walkSide");
				
					position = MovieClip(root).getChildIndex(MovieClip(root).exerciseObjectArray[exerciseNum][0])+2;
					MovieClip(root).setChildIndex(this,position);
					
				}else {
					computerX=300;computerY=200;
					position = 9;
					randomSpeed();
					gotoAndPlay("walkBack");
				}
				MovieClip(root).setChildIndex(this,position);
				MovieClip(root).addCharacterEnable=true;
				
				// choice two: back to comp
			} else {
				
				for (var k:int=5; k>-1; k--) {
					if (MovieClip(root).computerArray[k]==true) {
						MovieClip(root).computerArray[k]=false;

						position = MovieClip(root).getChildIndex(MovieClip(root).exerciseObjectArray[0][6]);
						MovieClip(root).setChildIndex(this,position);
						initCharacter(k,this.x,this.y);
						break;
					}
				}
			}
			this.addEventListener(Event.ENTER_FRAME,myEnterFrame);
			var tempIndex2:int = MovieClip(root).getChildIndex(MovieClip(root).exerciseObjectArray[exerciseNum][0]);
			MovieClip(root).setChildIndex(MovieClip(root).exerciseObjectArray[exerciseNum][6],tempIndex2+1);
		}

/*---Method -character Die-------------------------------------------------------------------*/
		public function characterDie():void {
			this.stop();
			isdeath=true;
			myTimer.removeEventListener(TimerEvent.TIMER,timerListener);
			this.removeEventListener(Event.ENTER_FRAME,myEnterFrame);
			this.removeEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
			MovieClip(root).characterOnStage=MovieClip(root).characterOnStage-1;
			MovieClip(root).removeElement(this.characterNum);
			this.parent.removeChild(this);
		}
	}//end of the class
}//end of the program