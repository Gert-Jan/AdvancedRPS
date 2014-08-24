package com.ddg.arps.game.map 
{
	import com.ddg.arps.Assets;
	import com.ddg.arps.util.PointHelper;
	import flash.geom.Point;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	/**
	 * @author Gert-Jan Stolk
	 */
	public class Edge 
	{
		private static const ANIM_SPEED:Number = 2;
		private static var edgeTexture:Texture = Assets.Instance.Edge;
		private var image:Image;
		private var sprite:Sprite = new Sprite();
		private var node1:Node;
		private var node2:Node;
		private var position:Point;
		private var vector:Point;
		private var anim:Number = 0;
		
		public function Edge(node1:Node, node2:Node) 
		{
			this.node1 = node1;
			this.node2 = node2;
			this.vector = PointHelper.Subtract(node1.Position, node2.Position);
			this.position = PointHelper.Divide(PointHelper.Add(node1.Position, node2.Position), 2);
			InitSprite();
			MapManager.Instance.EdgeSurface.addChild(sprite);
		}
		
		public function get Node1():Node
		{
			return node1;
		}
		
		public function get Node2():Node
		{
			return node2;
		}
		
		private function InitSprite():void
		{
			sprite.removeChildren();
			edgeTexture.repeat = true;
			image = new Image(edgeTexture);
			sprite.addChild(image);
			sprite.pivotX = sprite.width / 2;
			sprite.pivotY = sprite.height / 2;
			sprite.x = position.x;
			sprite.y = position.y;
			sprite.scaleX = vector.length / sprite.width;
			sprite.scaleY = 0.3;
			sprite.rotation = Math.atan2(vector.y, vector.x);
			sprite.alpha = 0.5;
			image.setTexCoords(0, new Point(0, 0));
			image.setTexCoords(1, new Point(sprite.scaleX / 0.2, 0));
			image.setTexCoords(3, new Point(sprite.scaleX / 0.2, 1));
			image.setTexCoords(2, new Point(0, 1));
		}
		
		public function Update(deltaTime:Number):void
		{
			if (node1.Owner != null && node1.Owner == node2.Owner)
			{
				image.color = node1.Owner.Color;
				anim += deltaTime;
				if (anim > ANIM_SPEED)
					anim = anim - ANIM_SPEED;
			}
			else
			{
				image.color = 0x888888;
			}
			image.setTexCoords(0, new Point(anim / 0.2 / ANIM_SPEED, 0));
			image.setTexCoords(1, new Point(sprite.scaleX / 0.2 + anim / 0.2 / ANIM_SPEED, 0));
			image.setTexCoords(3, new Point(sprite.scaleX / 0.2 + anim / 0.2 / ANIM_SPEED, 1));
			image.setTexCoords(2, new Point(anim / 0.2 / ANIM_SPEED, 1));
		}
	}
}