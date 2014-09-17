package com.ddg.arps.game.map 
{
	/**
	 * @author Gert-Jan Stolk
	 */
	public class Unit 
	{
		public static const TYPE_ROCK:uint = 0;
		public static const TYPE_PAPER:uint = 1;
		public static const TYPE_SCISSORS:uint = 2;
		
		public static const IMAGE_ROCK:String = "0";
		public static const IMAGE_PAPER:String = "1";
		public static const IMAGE_SCISSORS:String = "2";
		
		private var type:uint = TYPE_ROCK;
		private var amount:uint = 0;
		
		public function Unit(type:uint, amount:uint = 0) 
		{
			this.type = type;
			this.amount = amount;
		}
		
		public function get Type():uint
		{
			return type;
		}
		
		public function get Amount():uint
		{
			return amount;
		}
		
		public function set Amount(amount:uint):void
		{
			this.amount = amount;
		}
	}
}