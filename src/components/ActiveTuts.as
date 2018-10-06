package components
{
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	public class ActiveTuts extends Sprite
	{
		public function ActiveTuts()
		{
			super();
			
			if (stage)
			{
				init();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE ,init);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var effect:WindEffect = new WindEffect('assets/test.jpg');
			addChild(effect);
		}
	}
}