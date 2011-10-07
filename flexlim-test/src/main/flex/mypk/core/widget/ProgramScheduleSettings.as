package mypk.core.widget
{
	import mypk.core.dataaccess.ProgramData;
	
	public class ProgramScheduleSettings
	{
		public static var data : Array;
		private var channel : int;
		private var startTime : Date;
		private var duration : int;
		private var title : String;
		
		public function ProgramScheduleSettings()
		{
			data = new Array();
		}
		public function setChannel(channel:String):void
		{
			this.channel = int(channel);	
		}
		
		public function setStartTime(startTime:String):void
		{
			
			this.startTime = new Date();
			this.startTime.hours = int(startTime.charAt(0))*10 + int(startTime.charAt(1));
			this.startTime.minutes = int(startTime.charAt(3))*10 + int(startTime.charAt(4));
			
		}
		
		public function setDuration(duration:String):void
		{
			this.duration = int(duration);	
		}	
		
		public function setTitle(title:String):void
		{
			this.title = title;	
		}
		
		public function execute() : void
		{
			data.push(new ProgramData(channel, startTime, duration, title));	
		}
		public static function getdata() : ProgramData
		{
			var prgdata:ProgramData;
			prgdata = data.pop();
			return prgdata;
		}
	}
}