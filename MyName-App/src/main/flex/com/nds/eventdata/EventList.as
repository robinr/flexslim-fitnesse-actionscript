package com.nds.eventdata
{
	public class EventList
	{
		public static var eventlist:Array;
		public var size:int;
		public static var presetgenre:String;// Hardcoded
		
		public function EventList(evlist:Array)
		{
			eventlist = evlist;
			size = eventlist.length;
		}
		
		public function geteventIterator(genretype:String):Iterator
		{
			var iter:Iterator;
			var count:int = 0;
			presetgenre = genretype;
			
			for(var i:int = 0; i < size; i++) // Just to find the size of the iterator.
			{
				if(genretype == eventlist[i].genre)
				{
					count++;
				}
			}
			iter = new Iterator(count);
			return iter;
		}
		
		public function geteventdata():Eventelement
		{
			var evelement:Eventelement; 
			for(var i:int = Iterator._index ;i < size; i++,Iterator._index++)//Incrementing for the next element in the list
			{
				if(presetgenre == eventlist[i].genre)
				{
					break;
				}
			}
		
			return eventlist[i];
		}
	}
}