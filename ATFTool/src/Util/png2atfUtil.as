package Util
{
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;

	public class png2atfUtil
	{
		
		private static var nativeProcess:NativeProcess;
		
		/**
		 * 转换Atf 
		 * @param workPath		工作路径
		 * @param sourceFile	源文件
		 * @param exportFile	目标文件
		 * @param platform		转换平台
		 * @param compress		是否压缩
		 * @param mips			是否弃用mips
		 * @param quality		图片质量
		 * @param converCallBack	转换完成的回掉
		 * @param logCallBack	日志回掉
		 */		
		public static function converAtf(workPath:String,sourceFile:String,exportFile:String,platform:String,compress:Boolean,mips:Boolean,quality:int,converCallBack:Function,logCallBack:Function):void{
			var workingDirectory:File = new File(workPath);
			var executable:File;
			if(OSUtil.isMac()){
				executable = File.applicationDirectory.resolvePath("png2atf");
			}else if(OSUtil.isWindows()){
				executable = File.applicationDirectory.resolvePath("png2atf.exe");
			}
			var params:Vector.<String> = new Vector.<String>();
			params.push("-c");
			
			if(platform != ""){
				params.push(platform);
			}
			
			if(compress){
				params.push("-r");
			}
			
			params.push("-q");
			params.push(quality);
			
			if(mips){
				params.push("-n");
				params.push("0,");
			}else{
				params.push("-n");
				params.push("0,0");
			}
			
			params.push("-i");
			params.push(sourceFile);
			params.push("-o");
			params.push(exportFile);
			
			var info:NativeProcessStartupInfo = new NativeProcessStartupInfo();
			info.workingDirectory = workingDirectory;
			info.arguments = params;
			info.executable = executable;
			
			if(nativeProcess == null){
				nativeProcess = new NativeProcess();
				nativeProcess.addEventListener(NativeProcessExitEvent.EXIT,onExit);
				nativeProcess.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA,onData);
				nativeProcess.addEventListener(ProgressEvent.STANDARD_ERROR_DATA,onError);
			}
			try
			{
				nativeProcess.start(info);
			} 
			catch(error:Error) 
			{
				logCallBack(error.getStackTrace()+"\n");
				
			}
			
			
			function onExit(e:NativeProcessExitEvent):void{
				converCallBack();
			}
			
			function onData(e:ProgressEvent):void{
				logCallBack(nativeProcess.standardOutput.readUTFBytes(nativeProcess.standardOutput.bytesAvailable));
			}
			
			function onError(e:ProgressEvent):void{
				logCallBack(nativeProcess.standardError.readUTFBytes(nativeProcess.standardError.bytesAvailable));
			}
			
			
		}
	}
}