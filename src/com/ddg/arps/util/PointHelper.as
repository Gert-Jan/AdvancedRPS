package com.ddg.arps.util 
{
	import flash.geom.Point;
	/**
	 * @author Gert-Jan Stolk
	 */
	public class PointHelper 
	{
		public static function Add(point1:Point, point2:Point):Point
		{
			return new Point(point1.x + point2.x, point1.y + point2.y);
		}
		
		public static function Subtract(point1:Point, point2:Point):Point
		{
			return new Point(point1.x - point2.x, point1.y - point2.y);
		}
		
		public static function Multiply(point:Point, scalar:Number):Point
		{
			return new Point(point.x * scalar, point.y * scalar);
		}
		
		public static function Divide(point:Point, scalar:Number):Point
		{
			return new Point(point.x / scalar, point.y / scalar);
		}
		
		public static function Cross(point1:Point, point2:Point):Number
		{
			return (point1.x * point2.y) - (point1.y * point2.x);
		}
	}
}