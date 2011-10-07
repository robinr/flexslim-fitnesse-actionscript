package mypk.core.dataaccess
{
	public class ProgramData
	{
		private var channel : int;
		private var startTime : Date;
		private var duration : int;
		private var title : String;
		
		public function ProgramData(channel : int, startTime: Date, duration : int, title : String)
		{
			this.channel = channel;
			this.startTime = startTime;
			this.duration = duration;
			this.title = title;
		}
		
		public function toString() : String
		{
			return channel.toString() + duration.toString() + title;
		}
			
	}
}