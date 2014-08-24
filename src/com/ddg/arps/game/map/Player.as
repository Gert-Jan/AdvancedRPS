package com.ddg.arps.game.map {
	/**
	 * @author Gert-Jan Stolk
	 */
	public class Player 
	{
		private var color:uint = 0x000000;
		public function Player(color:uint) 
		{
			this.color = color;
		}
		
		public function get Color():uint
		{
			return color;
		}
	}
}