package com.ddg.arps 
{
	import flash.utils.getTimer;
	import starling.core.Starling;
	/**
	 * @author Gert-Jan Stolk
	 */
	public class Settings 
	{
		private static const instance:Settings = new Settings();
		
		public static function get Instance():Settings
		{
			return instance;
		}
		
		public function Settings() 
		{}
		
		public function get StageWidth():Number
		{
			return Starling.current.stage.stageWidth;
		}
		
		public function get StageHeight():Number
		{
			return Starling.current.stage.stageHeight;
		}
		
		public function GetCurrentTime():int
		{
			return getTimer();
		}
		
		public function GetTimeInSeconds(time:int):Number
		{
			return time * 0.001;
		}
	}
}