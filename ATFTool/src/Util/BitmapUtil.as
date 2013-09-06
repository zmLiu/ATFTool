package Util
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.PNGEncoderOptions;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	public class BitmapUtil
	{
		
		private static var sizes:Array = [2,4,8,16,32,128,256,512,1024,2048,4096,8192];
		
		/**
		 * 图像尺寸自动纠正为2幂
		 * @param file			文件
		 * @param toSquare		是否转换为方形
		 * @param converCallBack	转换完毕的回掉
		 * @param logCallBack		输出日志回掉
		 */			
		public static function converBitmapToPowerOf2(file:File,toSquare:Boolean,converCallBack:Function,logCallBack:Function):void{
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.READ);
			
			var bytes:ByteArray = new ByteArray();
			fs.readBytes(bytes);
			fs.close();
			getBitmapData(bytes,getBitmapCallBack);
			
			function getBitmapCallBack(bitmapdata:BitmapData):void{
				var rect:Rectangle = getPowerOf2Rect(bitmapdata.width,bitmapdata.height);
				
				if(toSquare && rect.width != rect.height){
					if(rect.width > rect.height){
						rect.height = rect.width;
					}else if(rect.height > rect.width){
						rect.width = rect.height;
					}
					logCallBack("图片转换为正方形...\n");
				}
				
				if(rect.width != bitmapdata.width || rect.height != bitmapdata.height){
					logCallBack("图片边长转换为2幂...\n");
					
					var temp:BitmapData = new BitmapData(rect.width,rect.height,true,0);
					temp.copyPixels(bitmapdata,temp.rect,new Point(0,0));
					
					var data:ByteArray = temp.encode(temp.rect,new PNGEncoderOptions());
					
					fs = new FileStream();
					fs.open(file,FileMode.WRITE);
					fs.writeBytes(data);
					fs.close();
				}else{
//					bytes = null;
				}
				converCallBack(bytes,file);
			}
		}
		
		
		/**
		 * 根据bytearray获取 
		 * @param bytes
		 * @param callBack
		 * 
		 */		
		public static function getBitmapData(bytes:ByteArray,callBack:Function):void{
			var loader:Loader = new Loader();
			loader.loadBytes(bytes);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loaderComplete);
			
			function loaderComplete(e:Event):void{
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,loaderComplete);
				callBack((loader.contentLoaderInfo.content as Bitmap).bitmapData);
			}
		}
		
		/**
		 * 根据宽高获取一个两边边长都是2幂的矩形
		 * @param width		原始宽度
		 * @param height	原始高度
		 * 
		 */				
		public static function getPowerOf2Rect(width:int,height:int):Rectangle{
			
			width = getSize(width);
			height = getSize(height);
			
			return new Rectangle(0,0,width,height);
			
			function getSize(value:int):int{
				var length:int = sizes.length;
				for (var i:int = 0; i < length-1; i++) {
					if(value == sizes[i]){
						return value;
					}
					
					if(value > sizes[i] && value < sizes[i+1]){
						return sizes[i+1];
					}
				}
				return value;
			}
		}
	}
}