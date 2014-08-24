package com.ddg.arps.game.map 
{
	import com.ddg.arps.Assets;
	import com.ddg.arps.game.map.Player;
	import flash.geom.Point;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	/**
	 * @author Gert-Jan Stolk
	 */
	public class Node 
	{
		public static const TYPE_RESOURCES:int = 0;
		public static const TYPE_FACTORY:int = 1;
		
		private static const IMAGE_OUTLINE_BASE:String = "0";
		private static const IMAGE_OUTLINE_NORMAL:String = "1";
		private static const IMAGE_CONTENT_FACTORY:String = "2";
		
		private static var nodeSheet:TextureAtlas = Assets.Instance.Nodes;
		private var outlineImage:Image;
		private var contentImage:Image;
		private var contentText:TextField;
		private var sprite:Sprite = new Sprite();
		private var position:Point = new Point();
		private var type:int = TYPE_RESOURCES;
		private var resourceRate:int = 0;
		private var isBase:Boolean = false;
		private var owner:Player = null;
		
		private static var unitSheet:TextureAtlas = Assets.Instance.Units;
		private var rockUnit:Unit = new Unit(Unit.TYPE_ROCK);
		private var paperUnit:Unit = new Unit(Unit.TYPE_PAPER);
		private var scissorsUnit:Unit = new Unit(Unit.TYPE_SCISSORS);
		private var rockImage:Image;
		private var paperImage:Image;
		private var scissorsImage:Image;
		private var rockSprite:Sprite = new Sprite();
		private var paperSprite:Sprite = new Sprite();
		private var scissorsSprite:Sprite = new Sprite();
		
		public function Node(position:Point) 
		{
			this.position = position;
			MapManager.Instance.NodeSurface.addChild(sprite);
			MapManager.Instance.UnitSurface.addChild(rockSprite);
			MapManager.Instance.UnitSurface.addChild(paperSprite);
			MapManager.Instance.UnitSurface.addChild(scissorsSprite);
		}
		
		public static function CreateResourceNode(position:Point, resourceRate:int, owner:Player = null, isBase:Boolean = false):Node
		{
			var node:Node = new Node(position);
			node.type = TYPE_RESOURCES;
			node.resourceRate = resourceRate;
			node.owner = owner;
			node.isBase = isBase;
			SetImages(node);
			node.UpdateSprite();
			return node;
		}
		
		public static function CreateFactoryNode(position:Point, owner:Player = null, isBase:Boolean = false):Node
		{
			var node:Node = new Node(position);
			node.type = TYPE_FACTORY;
			node.resourceRate = 0;
			node.owner = owner;
			node.isBase = isBase;
			SetImages(node);
			node.UpdateSprite();
			return node;
		}
		
		public function CloneAtPosition(position:Point):Node
		{
			var node:Node = new Node(position);
			node.type = this.type;
			node.resourceRate = this.resourceRate;
			node.isBase = this.isBase;
			SetImages(node);
			node.UpdateSprite();
			return node;
		}
		
		private static function SetImages(node:Node):void
		{
			//outline
			if (node.isBase)
				node.outlineImage = new Image(nodeSheet.getTexture(IMAGE_OUTLINE_BASE));
			else
				node.outlineImage = new Image(nodeSheet.getTexture(IMAGE_OUTLINE_NORMAL));
			// contents
			if (node.type == TYPE_FACTORY)
				node.contentImage = new Image(nodeSheet.getTexture(IMAGE_CONTENT_FACTORY));
			else
			{
				node.contentText = new TextField(135, 135, "+" + node.resourceRate, "Arial", 50, 0xffffff, false);
				node.contentText.vAlign = VAlign.CENTER;
				node.contentText.hAlign = HAlign.CENTER;
			}
			
			node.rockImage = new Image(unitSheet.getTexture(Unit.IMAGE_ROCK));
			node.paperImage = new Image(unitSheet.getTexture(Unit.IMAGE_PAPER));
			node.scissorsImage = new Image(unitSheet.getTexture(Unit.IMAGE_SCISSORS));
		}
		
		private function UpdateSprite():void
		{
			sprite.removeChildren();
			if (owner == null)
			{
				outlineImage.color = 0xffffff;
				if (contentImage != null)
					contentImage.color = 0xffffff;
			}
			else
			{
				outlineImage.color = owner.Color;
				if (contentImage != null)
					contentImage.color = owner.Color;
				if (contentText != null)
					contentText.color = owner.Color;
			}
			sprite.addChild(outlineImage);
			if (type == TYPE_FACTORY)
				sprite.addChild(contentImage);
			else
				sprite.addChild(contentText);
			sprite.pivotX = outlineImage.width / 2;
			sprite.pivotY = outlineImage.height / 2;
			sprite.x = position.x;
			sprite.y = position.y;
			sprite.scaleX = 0.3;
			sprite.scaleY = 0.3;
			
			rockSprite.addChild(rockImage);
			rockSprite.pivotX = rockImage.width / 2;
			rockSprite.pivotY = rockImage.height / 2;
			rockSprite.scaleX = 0.3;
			rockSprite.scaleY = 0.3;
			rockSprite.x = position.x;
			rockSprite.y = position.y - 32;
			rockSprite.visible = false;
			
			paperSprite.addChild(paperImage);
			paperSprite.pivotX = paperImage.width / 2;
			paperSprite.pivotY = paperImage.height / 2;
			paperSprite.scaleX = 0.3;
			paperSprite.scaleY = 0.3;
			paperSprite.x = position.x + 22;
			paperSprite.y = position.y + 15;
			paperSprite.visible = false;
			
			scissorsSprite.addChild(scissorsImage);
			scissorsSprite.pivotX = scissorsImage.width / 2;
			scissorsSprite.pivotY = scissorsImage.height / 2;
			scissorsSprite.scaleX = 0.3;
			scissorsSprite.scaleY = 0.3;
			scissorsSprite.x = position.x - 22;
			scissorsSprite.y = position.y + 15;
			scissorsSprite.visible = false;
		}
		
		public function Dispose():void
		{
			sprite.removeChildren();
			MapManager.Instance.NodeSurface.removeChild(sprite);
			MapManager.Instance.UnitSurface.removeChild(rockSprite);
			MapManager.Instance.UnitSurface.removeChild(paperSprite);
			MapManager.Instance.UnitSurface.removeChild(scissorsSprite);
		}
		
		public function get Position():Point
		{
			return position;
		}
		
		public function get Owner():Player
		{
			return owner;
		}
		
		public function set Owner(owner:Player):void
		{
			this.owner = owner;
			UpdateSprite();
		}
		
		public function AddUnit(unit:Unit):void
		{
			switch(unit.Type)
			{
				case Unit.TYPE_ROCK:
					rockUnit.Amount += unit.Amount;
					break;
				case Unit.TYPE_PAPER:
					paperUnit.Amount += unit.Amount;
					break;
				case Unit.TYPE_SCISSORS:
					scissorsUnit.Amount += unit.Amount;
					break;
			}
		}
	}
}