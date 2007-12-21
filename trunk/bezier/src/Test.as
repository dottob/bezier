package {
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import howtodo.*;	
	
	[SWF(backgroundColor="0xFFFFFF")]

	public class Test extends Sprite {
	
		
		private var step:Sprite;
		
		private const constructors:Array = [
			Step00HowToDo,
			Step01Building,
			Step02ClosestPoint,
			Step03EditDrag,
			Step04EmulationCubic,
			Step05SmoothCurve,
			Step06PointOnBezier,
			Step07PointOnCurve,
			Step08Bounce,
			Step09DashedLine
		]
		
		public function Test() {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = 31;
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			initGrid();
			
			var interval:uint = setInterval(function ():void {
				onKeyUp();
				clearInterval(interval);
			},100);
		}
		
		private function showStep(k:uint):void {
			var StepConstructor:Class = constructors[k];
			if (!isNaN(k)) {
				if (step) {
					removeChild(step);
				}
				step = new StepConstructor();
				addChild(step);
			}
		}
		private function onKeyUp(event:KeyboardEvent=null):void {
			var k:uint;
			if (event is KeyboardEvent) {
				k = event.keyCode;
			} else {
				k = 48;
			}
			if (k>47 && k<58) {
				showStep(k-48);
			}
		}
		
		private function initGrid():void {
			var gridTxt:TextField = new TextField();
			addChild(gridTxt);
			gridTxt.text = PointView.GRID+" - grid step";
			gridTxt.type = TextFieldType.INPUT;
			gridTxt.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			gridTxt.restrict = "0-9";
		}

		private function onFocusOut(event:FocusEvent):void {
			var gridTxt:TextField = event.target as TextField;
			PointView.GRID = Number(parseInt(gridTxt.text)) || 10;
			gridTxt.text = PointView.GRID+" - grid step";
		}
		
		
	}
}













