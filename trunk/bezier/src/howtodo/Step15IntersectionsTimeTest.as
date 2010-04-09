package howtodo 
{
	import flash.utils.clearInterval;	
	import flash.text.TextFieldAutoSize;	
	import flash.utils.setInterval;	
	import flash.text.TextField;	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Bezier;
	import flash.geom.Intersection;
	import flash.geom.Line;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import howtodo.view.DragPoint;		

	public class Step15IntersectionsTimeTest extends BezierUsage {

		private static const DESCRIPTION:String = "<B>Bezier-Bezier intersection time test</B><BR/> every frame does 1000 intersections";

		private static const GREEN:uint = 0x00FF00; 
		private static const GRAY:uint = 0x333333; 
		private static const BLUE:uint = 0x0000FF; 

		protected var bezierBlue:Bezier;
		
		protected const startGray:DragPoint = new DragPoint();
		protected const controlGray:DragPoint = new DragPoint();
		protected const endGray:DragPoint = new DragPoint();
		protected const bezierGray:Bezier = new Bezier(startGray.point, controlGray.point, endGray.point);
		
		protected const intersections:Array = [];

		private var fpsTextField : TextField = new TextField();		
		private var framesCounter:int = 0;
		private var intervalCookie:int = 0;
		
		public function Step15IntersectionsTimeTest() {
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedTotageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStageHandler);
		}

		override protected function init():void {
			
			addEventListener(KeyboardEvent.KEY_UP, onKeyUpHandler);
			
			initDescription(DESCRIPTION);
			
			bezierBlue = bezier;
			bezier = undefined;
						
			initControl(start, BLUE, "S");
			initControl(control, BLUE, "C");
			initControl(end, BLUE, "E");
			
			initControl(startGray, GRAY, "S");
			initControl(controlGray, GRAY, "C");
			initControl(endGray, GRAY, "E");
			
			bezierBlue.isSegment = false;
			bezierGray.isSegment = false;
			
			setTestPosition(100,400, 800,500, 100,600, 
							200,700, 300,100, 400,700,
							100,300, 500,750);
							
			addTextField(fpsTextField, 100, 80);
										
			onPointMoved();
		}
		
		private function onAddedTotageHandler(event : Event) : void
		{			
			intervalCookie = setInterval(updateFps, 1000);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
		}
		private function onRemoveFromStageHandler(event : Event) : void
		{
			clearInterval(intervalCookie);
			stage.removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
		}
		
		private function addTextField(textField:TextField, x:Number, y:Number) : void 
		{			
			textField.selectable = false;
			textField.wordWrap = false;
			textField.multiline = true;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.mouseEnabled = false;
			textField.mouseWheelEnabled = false;
			textField.x = x;
			textField.y = y;
			addChild(textField);
		}	
		
		private function updateFps() : void
		{
			fpsTextField.text = "FPS: "+framesCounter;
			framesCounter = 0;
		}

		private function onEnterFrameHandler(event:Event) : void
		{
			onPointMoved();
		}
		
		private function onKeyUpHandler(event:KeyboardEvent):void {
			if (event.keyCode == Keyboard.SPACE) {
				trace(getTestPosition());
			}
		}

		private function setTestPosition(
				s0x:Number, s0y:Number, c0x:Number, c0y:Number, e0x:Number, e0y:Number,
				s1x:Number, s1y:Number, c1x:Number, c1y:Number, e1x:Number, e1y:Number, 
				s2x:Number, s2y:Number, e2x:Number, e2y:Number):void 
		{
			start.x = s0x;
			start.y = s0y;
			control.x = c0x;
			control.y = c0y;
			end.x = e0x;
			end.y = e0y;

			startGray.x = s1x;
			startGray.y = s1y;
			controlGray.x = c1x;
			controlGray.y = c1y;
			endGray.x = e1x;
			endGray.y = e1y;					
		}
		
		private function getTestPosition ():String {
			return ""+[
			start.x,
			start.y,
			control.x,
			control.y,
			end.x,
			end.y,

			startGray.x,
			startGray.y,
			controlGray.x,
			controlGray.y,
			endGray.x,
			endGray.y
			];
		}

		
		override protected function onPointMoved(event:Event = undefined):void 
		{			
			framesCounter += 1;
			
			graphics.clear();

			graphics.lineStyle(0, BLUE, 1);
			drawBezier(bezierBlue);
			
			graphics.lineStyle(0, GRAY, 1);
			drawBezier(bezierGray);
			
			removeIntersections();
			
			showBezierBezierIntersection(bezierBlue, bezierGray);			
		}

		protected function showBezierBezierIntersection(curve1:Bezier, curve2:Bezier):void {
			var time:Number;
			var isect:Intersection;
			
			for (var j:int=0; j<1000; j++)
			{
				isect = curve1.intersectionBezier(curve2);
			}
			if (isect) {
				for (var i:uint = 0;i < isect.currentTimes.length; i++) {
					time = isect.currentTimes[i];
					showIntersection(curve1.getPoint(time), false, time);
					time = isect.targetTimes[i];
					showIntersection(curve2.getPoint(time), true, time);
				}
			}
		}

		protected function showLineBezierIntersection(curve:Bezier, line:Line):void {
			var isect:Intersection = curve.intersectionLine(line);
			if (isect) {
				if (isect.currentTimes.length) {
					var time:Number = isect.currentTimes[0];
					showIntersection(curve.getPoint(time), false, time);
					time = isect.targetTimes[0];
					showIntersection(line.getPoint(time), true, time);
					
					if (isect.currentTimes.length > 1) {
						time = isect.currentTimes[1];
						showIntersection(curve.getPoint(time), false, time);
						time = isect.targetTimes[1];
						showIntersection(line.getPoint(time), true, time);
					}
				}
			}
		}

		protected function showLineLineIntersection(line1:Line, line2:Line):void {
			var isect:Intersection = line1.intersectionLine(line2);
			if (isect) {
				if (isect.currentTimes.length) {
					var time:Number = isect.currentTimes[0];
					showIntersection(line1.getPoint(time), false, time);
					time = isect.targetTimes[0];
					showIntersection(line2.getPoint(time), true, time);
				}
				/*
				var line:Line = Line(isect.coincidenceLine);
				if (line) {
					graphics.lineStyle(3, 0x0000FF, 1);
					drawLine(line); 
				}
				 */
			}
		}

		protected function showIntersection(point:Point, small:Boolean, time:Number):DragPoint {
			if (point is Point) {
				var intersection:DragPoint = new DragPoint();
				intersection.position = point;
				addChild(intersection);
				intersections.push(intersection);
				if (small) {
					intersection.radius -= 2;
				} else {
					intersection.pointName = "     t:" + time;
				}
				return intersection;
			}
			return null;
		}

		protected function removeIntersections():void {
			while(intersections.length) {
				var intersectionPoint:DragPoint = intersections.pop();
				removeChild(intersectionPoint);
			}
		}
	}
}