package com.ddg.arps 
{
	import flash.geom.Rectangle;
	import flash.text.Font;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	/**
	 * @author Gert-Jan Stolk
	 */
	public dynamic class Assets 
	{
		private static const instance:Assets = new Assets();
		
		public static function get Instance():Assets
		{
			return instance;
		}
		
		public function Assets() 
		{}
		
		[Embed(source = "../../../../assets/img/Nodes.png")]
		private static const nodes:Class;
		[Embed(source = "../../../../assets/img/Edge.png")]
		private static const edge:Class;
		[Embed(source = "../../../../assets/img/Units.png")]
		private static const units:Class;
		
		public function Init():void
		{
		}
		
		private function CreateTexture(asset:Class):Texture
		{
			if (this[asset] == null)
				this[asset] = Texture.fromBitmap(new asset());
			return this[asset];
		}
		
		private function CreateTileMap(asset:Class, tileWidth:int, tileHeight:int, offset:int = 0):TextureAtlas
		{
			if (this[asset] == null)
			{
				var texture:Texture = Texture.fromBitmap(new asset());
				var atlas:TextureAtlas = new TextureAtlas(texture, null);
				var tileCountX:int = Math.floor(texture.width / tileWidth);
				var tileCountY:int = Math.floor(texture.height / tileHeight);
				for (var y:int = 0; y < tileCountY; y++)
				{
					for (var x:int = 0; x < tileCountX; x++)
					{
						var rect:Rectangle = new Rectangle(x * tileWidth, y * tileHeight, tileWidth, tileHeight);
						atlas.addRegion((y * tileCountX + x + offset).toString(), rect);
					}
				}
				this[asset] = atlas;
			}
			return this[asset];
		}
		
		public function get Nodes():TextureAtlas { return CreateTileMap(nodes, 137, 137); }
		public function get Edge():Texture { return CreateTexture(edge); }
		public function get Units():TextureAtlas { return CreateTileMap(units, 90, 90); }
	}
}