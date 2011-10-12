package com.nds.eventdata
{
	public class Iterator
	{
		public var size:int;
		public static var _index:int = 0; // Made it as a static index, so that it can be accessed by the EventList for incrementing.
		
		public function Iterator(sz:int)
		{
			size = sz;
		}
		
		public function getNext():Eventelement
		{  
			var eventdata:Eventelement;
			
			//eventdata = EventList.geteventdata();
		//	var evelement:Eventelement; 
			for(var i:int = Iterator._index ;i < size; i++,Iterator._index++)//Incrementing for the next element in the list
			{
				if(EventList.presetgenre == EventList.eventlist[i].genre)
				{
					break;
				}
			}
			_index = _index + 1;
			return EventList.eventlist[i];
			
		}
		
		public function isEmpty():Boolean
		{
			if(_index >= size)
			{
				return true;
				
			}
			return false;
		}
		
		public function reset():void
		{
			_index= 0;
		}
	}
}