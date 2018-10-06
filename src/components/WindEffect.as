package components
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	public class WindEffect extends Sprite
	{
		private var _pictureArray:Array;
		
		public function WindEffect($url:String)
		{
			loadPicture($url);
		}
		
		private function loadPicture($url:String):void
		{
			var loader:Loader = new Loader;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			loader.load(new URLRequest($url));
		}
		
		private function onLoadComplete(e:Event):void
		{
			//addChild(e.target.content);
			createEffect(e.target.content);
		}
		
		private function createEffect($bitmap:Bitmap):void
		{
			//center image horizontally
			var centerWidth:Number = (stage.stageWidth - $bitmap.width) * .5;
			
			//center image vertically
			var centerHeight:Number = (stage.stageHeight - $bitmap.height) * .5;
			
			var numberOfColumns:uint = 50;
			var numberOfRows:uint = 25;
			
			var sizeWidth:uint = $bitmap.width / numberOfColumns;
			var sizeHeight:uint = $bitmap.height / numberOfRows;
			var numberOfBoxes:uint = numberOfColumns * numberOfRows;
			_pictureArray = [];
			
			for (var i:uint = 0; i < numberOfColumns; i++)
			{
				//these loops are what splits the image into 1250 pieces
				for (var j:uint = 0; j < numberOfRows; j++)
				{
					//trace("i: " + i + " j: " + j);
					//1 temporary bitmapdata
					var tempBitmapData:BitmapData = new BitmapData(sizeWidth, sizeHeight);
					
					//1 temporary rectangle (x,y,width,height)
					//we pass i * sizeWidth for the x parameter  & i * sizeHeight for the y parameter
					//and the sizeWidth & sizeHeight for the width and height parameters.
					var sourceRect:Rectangle = new Rectangle (i * sizeWidth, j * sizeHeight, sizeWidth, sizeHeight);
					//trace (sourceRect);//for testing
					tempBitmapData.copyPixels($bitmap.bitmapData, sourceRect, new Point);
					
					//we then create 1 temporary bitmap to house the bitmapdata we just copied.
					var tempBitmap:Bitmap = new Bitmap (tempBitmapData);
					
					//and 1 temporary sprite to house the bitmap to enable interactivity.
					var tempSprite:Sprite = new Sprite;
					
					//we just add each box inside it's own sprite to enable interactivity since bitmaps by themselves are not interactive.
					tempSprite.addChild (tempBitmap);
					
					//each sprite is added into the _pictureArray array for access later.
					_pictureArray.push (tempSprite);
					
					//then position each of them onto the stage. 
					//We add the center width & center height so image centers on the stage.
					tempSprite.x = i * sizeWidth + centerWidth;
					tempSprite.y = j * sizeHeight + centerHeight;
					addChild (tempSprite);
					
				}
			}
			stage.addEventListener(MouseEvent.CLICK, blowWind);
		}
		
		private function blowWind (e:MouseEvent):void 
		{
			stage.removeEventListener (MouseEvent.CLICK, blowWind);
			
			for (var i:uint = 0; i < _pictureArray.length; i++)
			{
				TweenLite.to (
					_pictureArray[i],
					getRandomInRange (.25, 2, false),
					{
						x: stage.stageWidth + 100,
						y:_pictureArray[i].y + getRandomInRange (-100, 100, false),//
						rotation: getRandomInRange (-90, 90),
						ease:Strong.easeIn,
						onComplete:removeSprite,
						onCompleteParams:[_pictureArray[i]]
					}
				);
			}
		}
		
		private function removeSprite ($sprite:Sprite):void
		{
			removeChild ($sprite);
		}
		
		public static function getRandomInRange ($min:Number, $max:Number, $rounded:Boolean = true):Number
		{
			if ($rounded) return Math.round (Math.random () * ($max - $min) + $min);
			else return Math.random () * ($max - $min) + $min;
		}
	}
}