package com.ddg.arps
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import starling.core.Starling;
	
	/**
	 * @author Gert-Jan Stolk
	 */
	[SWF(width="800", height="480", frameRate="60", backgroundColor="#000000")]
	public class Main extends Sprite 
	{
		private var starling:Starling;
		
		public function Main():void 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			Assets.Instance.Init();
			starling = new Starling(Game, stage);
			starling.showStats = true;
			starling.start();
		}
	}
}