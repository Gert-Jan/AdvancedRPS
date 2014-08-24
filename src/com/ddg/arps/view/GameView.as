package com.ddg.arps.view 
{
	import com.ddg.arps.game.graphics.Camera;
	import com.ddg.arps.game.map.MapManager;
	import starling.display.Sprite;
	import starling.events.KeyboardEvent;
	/**
	 * @author Gert-Jan Stolk
	 */
	public class GameView implements IView
	{
		private var camera:Camera = null;
		private var surface:Sprite = new Sprite();
		private var isActive:Boolean = false;
		
		public function GameView() 
		{
			Init();
			InitTest();
		}
		
		private function Init():void
		{
			MapManager.Instance.Init();
			camera = Camera.Instance;
			surface.addChild(camera.Surface);
			surface.addChild(MapManager.Instance.EdgeSurface);
			surface.addChild(MapManager.Instance.NodeSurface);
			surface.addChild(MapManager.Instance.UnitSurface);
			surface.addChild(MapManager.Instance.UISurface);
		}
		
		private function InitTest():void
		{
			
		}
		
		public function Activate():void
		{
			if (!isActive)
			{
				isActive = true;
				ViewManager.Instance.RootSurface.addChild(surface);
			}
		}
		
		public function Deactivate():void
		{
			if (isActive)
			{
				isActive = false;
				ViewManager.Instance.RootSurface.removeChild(surface);
			}
		}
		
		public function Update(deltaTime:Number):void
		{
			camera.Update(deltaTime);
			MapManager.Instance.Update(deltaTime);
		}
		
		public function get IsActive():Boolean
		{
			return isActive;
		}
		
		public function get Surface():Sprite
		{
			return surface;
		}
		
		public function OnKeyDown(event:KeyboardEvent):void
		{
		}
		
		public function OnKeyUp(event:KeyboardEvent):void
		{
		}
	}
}