package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.utils.setTimeout;
	
	import Util.BitmapUtil;
	import Util.png2atfUtil;
	
	[SWF(width=500,height=395)]
	public class ATFTool extends Sprite
	{
		private var ui:UIPanel;
		
		
		private var sourceDir:String;//源
		private var exportDir:String;//目标
		private var platform:String;//平台
		private var compress:Boolean;//是否压缩
		private var mips:Boolean;//是否启用
		private var quality:int;//质量
		private var to_square:Boolean;//是否转换为正方形
		
		private var exportFiles:Vector.<File>;
		
		public function ATFTool()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			ui = new UIPanel();
			ui.addEventListener("Export",onExport);
			addChild(ui);
		}
		
		/**
		 * 点击了导出按钮 
		 */		
		private function onExport(e:Event):void{
			ui.exportBtnEnabled = false;
			
			sourceDir = ui.sourceDir;
			exportDir = ui.exportDir;
			platform = ui.platform;
			compress = ui.compress;
			mips = ui.mips;
			quality = ui.quality;
			to_square = ui.to_square;
			
			exportFiles = new Vector.<File>();
			ergodicDirectory(new File(sourceDir));
			
			ui.clearLogs();
			ui.log("开始导出ATF...\n");
			ui.log("总共选择了"+exportFiles.length+"个文件.\n");
			
			if(exportFiles.length == 0){
				ui.log("导出完毕.\n");
				ui.exportBtnEnabled = true;
			}else{
				setTimeout(function():void{
					startExport(exportFiles.pop());
				},600);
			}
		}
		
		/**
		 * 遍历文件夹
		 * */
		private function ergodicDirectory(file:File):void{
			var array:Array = file.getDirectoryListing();
			var f:File;
			var length:int = array.length;
			for (var i:int = 0; i < length; i++) {
				f = array[i];
				if(f.isDirectory && ui.converChilds){
					createDir(f);
					ergodicDirectory(f);
				}else{
					if(f.extension != "png" && f.extension != "jpg"){
						copyFile(f);
					}else{
						exportFiles.push(f);
					}
				}
			}
		}
		
		/**创建文件夹*/		
		private function createDir(file:File):void{
			var path:String = file.nativePath.replace(sourceDir,exportDir);
			var f:File = new File(path);
			if(!f.exists){
				f.createDirectory();
			}
		}
		
		/**复制文件*/		
		private function copyFile(file:File):void{
			var path:String = file.nativePath.replace(sourceDir,exportDir);
			var f:File = new File(path);
			if(!f.exists){
				file.copyTo(f,true);
			}
		}
		
		/**
		 * 开始输出
		 * */
		private function startExport(file:File):void{
			ui.log("\n"+file.name + "开始导出...剩余:"+exportFiles.length+"个文件...\n");
			
			BitmapUtil.converBitmapToPowerOf2(file,to_square,converCallBack,logCallBack);
			
			function converCallBack():void{
				var sourceFile:String = file.nativePath;
				var exportFile:String = sourceFile.replace(sourceDir,exportDir);
				exportFile = exportFile.replace("."+file.extension,".atf");
				
				png2atfUtil.converAtf(sourceDir,sourceFile,exportFile,platform,compress,mips,quality,converAtfCallBack,logCallBack);
			}
			
			function converAtfCallBack():void{
				if(exportFiles.length > 0){
					startExport(exportFiles.pop());
				}else{
					ui.log("导出完毕.\n");
					ui.exportBtnEnabled = true;
				}
			}
			
			function logCallBack(text:String):void{
				ui.log(text);
			}
		}
	}
}