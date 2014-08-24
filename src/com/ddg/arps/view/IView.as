package com.ddg.arps.view 
{
	import starling.display.Sprite;
	import starling.events.KeyboardEvent;
	/**
	 * @author Gert-Jan Stolk
	 */
	public interface IView 
	{
		function Activate():void;
		function Deactivate():void;
		function Update(deltaTime:Number):void;
		function get IsActive():Boolean;
		function get Surface():Sprite;
		function OnKeyDown(event:KeyboardEvent):void;
		function OnKeyUp(event:KeyboardEvent):void;
	}
}