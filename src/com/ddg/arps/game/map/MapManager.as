package com.ddg.arps.game.map 
{
	import com.ddg.arps.Settings;
	import com.ddg.arps.util.PointHelper;
	import flash.geom.Point;
	import starling.display.Sprite;
	/**
	 * @author Gert-Jan Stolk
	 */
	public class MapManager 
	{
		private static const instance:MapManager = new MapManager();
		
		public static function get Instance():MapManager
		{
			return instance;
		}
		
		public function MapManager() 
		{}
		
		private var edgeSurface:Sprite = new Sprite();
		private var nodeSurface:Sprite = new Sprite();
		private var unitSurface:Sprite = new Sprite();
		private var uiSurface:Sprite = new Sprite();
		private var players:Vector.<Player> = new Vector.<Player>();
		private var nodes:Vector.<Node> = new Vector.<Node>();
		private var edges:Vector.<Edge> = new Vector.<Edge>();
		
		public function get EdgeSurface():Sprite
		{
			return edgeSurface;
		}
		
		public function get NodeSurface():Sprite
		{
			return nodeSurface;
		}
		
		public function get UnitSurface():Sprite
		{
			return unitSurface;
		}
		
		public function get UISurface():Sprite
		{
			return uiSurface;
		}
		
		public function Init():void
		{
			GenerateMap(Settings.Instance.StageWidth, Settings.Instance.StageHeight);
		}
		
		private function GenerateMap(width:uint, height:uint):void
		{
			// settings
			const margin:Number = 40;
			const baseOffset:Number = 100;
			
			// create player
			var p1:Player = new Player(0x4444ff);
			var p2:Player = new Player(0xff6600);
			players.push(p1);
			players.push(p2);
			
			// create bases
			var p1Node:Node;
			var p2Node:Node;
			var x:Number;
			var y:Number;
			if (width > height)
			{
				x = Math.random() * baseOffset + margin;
				y = Math.random() * (height - margin * 2) + margin;
				p1Node = Node.CreateFactoryNode(new Point(x, y), p1, true);
				p2Node = Node.CreateFactoryNode(new Point(width - x, height - y), p2, true); // mirror
			}
			else
			{
				x = Math.random() * (width - margin * 2) + margin;
				y = Math.random() * baseOffset + margin;
				p1Node = Node.CreateFactoryNode(new Point(x, y), p1, true);
				p2Node = Node.CreateFactoryNode(new Point(width - x, height - y), p2, true); // mirror
			}
			nodes.push(p1Node);
			nodes.push(p2Node);
			
			// start seeding nodes
			SeedNode(p1Node, width, height, 1);
			
			nodes[2].Owner = p1;
			nodes[3].Owner = p2;
			nodes[4].Owner = p1;
			nodes[5].Owner = p2;
			
			// create edges
			for (var i:int = 0; i < nodes.length; i++)
			{
				for (var j:int = 0; j < nodes.length; j++)
				{
					if (i != j)
					{
						var node:Node = nodes[i];
						var otherNode:Node = nodes[j];
						if (IsValidEge(node, otherNode))
						{
							edges.push(new Edge(node, otherNode));
							// mirror
							node = nodes[i % 2 == 0 ? i + 1 : i - 1];
							otherNode = nodes[j % 2 == 0 ? j + 1 : j - 1];
							if (IsValidEge(node, otherNode))
							{
								edges.push(new Edge(node, otherNode));
							}
						}
					}
				}
			}
		}
		
		private function IsValidEge(node1:Node, node2:Node):Boolean
		{
			var p1:Point = node1.Position;
			var p2:Point = node2.Position;
			var v:Point = PointHelper.Subtract(p2, p1);
			var distance:Number = PointHelper.Subtract(p1, p2).length;
			if (distance > 100 && distance < 175)
			{
				for each (var edge:Edge in edges)
				{
					// check if the edge already exists
					if ((edge.Node1 == node1 && edge.Node2 == node2) ||
						(edge.Node1 == node2 && edge.Node2 == node1))
						return false;
					// check if the edge crosses another edge
					var ep1:Point = edge.Node1.Position;
					var ep2:Point = edge.Node2.Position;
					var ev:Point = PointHelper.Subtract(ep2, ep1);
					var u1:Number = PointHelper.Cross(PointHelper.Subtract(ep1, p1), v) / PointHelper.Cross(v, ev);
					var u2:Number = PointHelper.Cross(PointHelper.Subtract(p1, ep1), ev) / PointHelper.Cross(ev, v);
					if (u1 > 0.001 && u1 < 0.999 && u2 > 0.001 && u2 < 0.999)
					{
						return false;
					}
				}
				return true;
			}
			return false;
		}
		
		private function SeedNode(node:Node, width:uint, height:uint, iteration:uint):void
		{
			// settings
			const margin:Number = 40;
			const minDistance:Number = 100;
			const maxDistance:Number = 175;
			const minAngle:Number = 30 * (Math.PI * 2 / 360);
			const maxAngle:Number = 90 * (Math.PI * 2 / 360);
			
			// rotate around the node, place new nodes at random angles/distances
			var newNodes:Vector.<Node> = new Vector.<Node>();
			var angle:Number = Math.random() * ((maxAngle - minAngle) / 2);
			while (angle < Math.PI * 2)
			{
				var distance:Number = Math.random() * (maxDistance - minDistance) + minDistance;
				var position:Point = new Point(node.Position.x + Math.cos(angle) * distance, node.Position.y + Math.sin(angle) * distance);
				var isInBounds:Boolean = IsInBounds(position, width, height, margin);
				var isClearOfOtherNodes:Boolean = IsClearOfOtherNodes(position, minDistance);
				if (isInBounds && isClearOfOtherNodes)
				{
					// create the node
					var node:Node;
					if (Math.random() < 0.2)
						node = Node.CreateFactoryNode(position);
					else
						node = Node.CreateResourceNode(position, Math.round(Math.random() * iteration * 5 + 5));
					nodes.push(node);
					// mirror the node
					var mirrorPosition:Point = new Point(width - position.x, height - position.y);
					if (IsClearOfOtherNodes(mirrorPosition, minDistance))
					{
						// we're in the clear create both nodes
						var mirrorNode:Node = node.CloneAtPosition(mirrorPosition);
						nodes.push(mirrorNode);
						newNodes.push(node);
						newNodes.push(mirrorNode);
						
						// add some random units
						var unit:Unit = new Unit(Math.floor(Math.random() * 3), Math.round(Math.random() * 5));
						node.AddUnit(unit);
						mirrorNode.AddUnit(unit);
					}
					else
					{
						// resolve the situation
						nodes.pop().Dispose();
					}
				}
				angle += Math.random() * (maxAngle - minAngle);
			}
			
			// seed from new nodes
			for each (var newNode:Node in newNodes)
			{
				SeedNode(newNode, width, height, iteration + 1);
			}
		}
		
		private function IsInBounds(position:Point, width:uint, height:uint, margin:Number):Boolean
		{
			if (position.x > margin && position.y > margin && position.x < width - margin && position.y < height - margin)
				return true;
			else
				return false;
		}
		
		private function IsClearOfOtherNodes(position:Point, minDistance:Number):Boolean
		{
			for each (var node:Node in nodes)
			{
				if (PointHelper.Subtract(position, node.Position).length < minDistance)
					return false;
			}
			return true;
		}
		
		public function Update(deltaTime:Number):void
		{
			for each(var edge:Edge in edges)
			{
				edge.Update(deltaTime);
			}
		}
	}
}