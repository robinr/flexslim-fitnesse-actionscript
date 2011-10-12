package com.nds.eventdata
{
	public class Eventelement
	{
		public var evname:String;
		public var genre:String;
		public var startime:String;
		public var duration:String;
		
		public function Eventelement(evnm:String,gen:String,stdate:String,dur:String):void
		{
			evname = evnm;
			genre = gen;
			startime = stdate;
			duration = dur;
		}
		public function display () : String
		{
		return evname+" "+genre+" "+startime+" "+duration;	
		} 
	}
}