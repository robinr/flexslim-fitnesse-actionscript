package mypk.core.widget
{
	import mypk.core.dataaccess.ProgramData;
	import mypk.core.widget.ctrlr.ProgressBarCtrlr;

	public class ProgressBarValidator
	{
		public static var controller:ProgressBarCtrlr;
		public static var data1:ProgramData;
		public static var data2:ProgramData;
		public static var data3:ProgramData;
		public var stime:String;
		public var dura:String;
		public var validate:String;
		public function ProgressBarValidator(startTime:String, duration:String)
		{
			data1 = ProgramScheduleSettings.getdata();
			data2 = ProgramScheduleSettings.getdata();
			data3 = ProgramScheduleSettings.getdata();
			stime = startTime;
			dura  = duration;
		}
		public function startStb() : void
		{
			controller.start();
			
		}
		public function progress() : String
		{
			return "";
		}
		public function tune(channel : String) : void
		{
			controller.refresh();
		}
		public function Validate():String
		{
			validate = "Event 1:"+data3.toString()+"Event 2:"+data2.toString()+"Event 3:"+data1.toString();
			return validate;
		}
	}
}