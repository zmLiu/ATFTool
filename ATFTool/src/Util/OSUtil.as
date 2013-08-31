package Util
{
	import flash.system.Capabilities;

	public class OSUtil
	{
		public static function isMac():Boolean{
			return Capabilities.os.indexOf("Mac") != -1;
		}
		
		public static function isWindows():Boolean{
			return Capabilities.os.indexOf("Win") != -1;
		}
	}
}