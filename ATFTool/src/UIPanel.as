package
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.HUISlider;
	import com.bit101.components.InputText;
	import com.bit101.components.PushButton;
	import com.bit101.components.TextArea;
	import com.bit101.utils.MinimalConfigurator;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.utils.setTimeout;
	
	import Util.OSUtil;
	
	public class UIPanel extends Sprite
	{
		private var _config:MinimalConfigurator;
		
		private var _platform:Array = ["p","d","e",""];
		private var _platformIndex:int = 3;
		
		private var _logTextArea:TextArea;
		
		public function UIPanel()
		{
			super();
			_config = new MinimalConfigurator(this);
			_config.loadXML("ATFToolUI.xml");
			_config.addEventListener(Event.COMPLETE,loadXmlComplete);
		}
		
		private function loadXmlComplete(e:Event):void{
			for (var i:int = 0; i < 4; i++) {
				_config.getCompById("p"+i).addEventListener(MouseEvent.CLICK,onSelectPlatform(i));
			}
			
			_logTextArea = _config.getCompById("logs") as TextArea;
			_logTextArea.editable = false;
		}
		
		/**
		 * 选择源
		 */		
		public function onSelectSource(e:MouseEvent):void{
			var file:File = new File();
			file.browseForDirectory("选择源路径");
			file.addEventListener(Event.SELECT,selectSourceComplete);
		}
		private function selectSourceComplete(e:Event):void{
			var file:File = e.target as File;
			file.removeEventListener(Event.SELECT,selectSourceComplete);
			if(OSUtil.isMac()){
				sourceDir = file.nativePath + "/";
			}else if(OSUtil.isWindows()){
				sourceDir = file.nativePath + "\\";
			}
			
		}

		/**
		 * 选输出路径
		 */		
		public function onSelectExport(e:MouseEvent):void{
			var file:File = new File();
			file.browseForDirectory("选择输出路径");
			file.addEventListener(Event.SELECT,selectExportComplete);
		}
		private function selectExportComplete(e:Event):void{
			var file:File = e.target as File;
			file.removeEventListener(Event.SELECT,selectExportComplete);
			if(OSUtil.isMac()){
				exportDir = file.nativePath + "/";
			}else if(OSUtil.isWindows()){
				exportDir = file.nativePath + "\\";
			}
		}
		
		/**
		 * 点击导出按钮
		 * */
		public function onExport(e:MouseEvent):void{
			if(exportDir == "" || sourceDir == ""){
				return;
			}
			dispatchEvent(new Event("Export"));
		}
		
		/**
		 * 选择平台
		 * */
		private function onSelectPlatform(index:int):Function{
			return function(e:MouseEvent):void{
				_platformIndex = index;
			}
		}
		
		
		public function set sourceDir(value:String):void{
			(_config.getCompById("sourceDir") as InputText).text = value;
		}
		/**
		 * @return 源路径
		 */		
		public function get sourceDir():String{
			return (_config.getCompById("sourceDir") as InputText).text;
		}
		
		public function set exportDir(value:String):void{
			(_config.getCompById("exportDir") as InputText).text = value;
		}
		/**
		 * @return 输出路径
		 */		
		public function get exportDir():String{
			return (_config.getCompById("exportDir") as InputText).text;
		}
		
		/**
		 * @return 输出平台
		 */		
		public function get platform():String{
			return _platform[_platformIndex];
		}
		
		/**
		 * @return 是否压缩
		 */		
		public function get compress():Boolean{
			return (_config.getCompById("compress") as CheckBox).selected;
		}
		
		/**
		 * @return 是否使用mips
		 */		
		public function get mips():Boolean{
			return (_config.getCompById("mips") as CheckBox).selected;
		}
		
		/**
		 * @return 输出质量
		 */		
		public function get quality():int{
			return (_config.getCompById("quality") as HUISlider).value;
		}
		
		/**
		 * @return 是否转换为正方形
		 */		
		public function get to_square():Boolean{
			return (_config.getCompById("to_square") as CheckBox).selected;
		}
		
		/**
		 * @return 是否转换子目录
		 */		
		public function get converChilds():Boolean{
			return (_config.getCompById("converChilds") as CheckBox).selected;
		}
		
		/**
		 * 输出日志 
		 */		
		public function log(text:String):void{
			_logTextArea.text += text;
			setTimeout(function():void{
				_logTextArea.textField.scrollV = _logTextArea.textField.maxScrollV;
			},60)
		}
		
		/**
		 * 清空日志 
		 */		
		public function clearLogs():void{
			_logTextArea.text = "";
		}
		
		public function set exportBtnEnabled(value:Boolean):void{
			(_config.getCompById("export") as PushButton).enabled = value;
		}
	}
}