package fixture
{
	import com.nds.eventdata.EventList;
	import com.nds.eventdata.Eventelement;
	import com.nds.eventdata.Iterator;
	

	
	public class EventFx
	{
		private var _name : String;
		private var _genre : String;
		private var _starttime : String;
		private var _duration : String;
		public var elementVector : Array;//Vector<Eventelement>;
		 
		public function EventFx()
		{
			elementVector = new Array; //Vector<Eventelement>;
		}
		
		public function setName(value:String):void
		{
			_name = value;
		}

		public function setGenre(value:String):void
		{
			_genre = value;
		}

		public function setStarttime(value:String):void
		{
			_starttime = value;
		}

		public function setDuration(value:String):void
		{
			_duration = value;
		}

		
		
		
		public  function test1( ) : String
		{
			var list : EventList = new EventList(elementVector);
			var iter : Iterator = list.geteventIterator("sports");
			var str :String = "";
			iter.reset();
			for( var i: int = 0 ; i<iter.size ; i++)
			{
				var event : Eventelement = iter.getNext();
				str = str+ event.display()+"";
			}
			return str;
		}

public function execute() : void
		{
			var event : Eventelement = new Eventelement(_name,_genre,_starttime,_duration);
			elementVector.push(event);
			//trace("-----------------------------------------------"+elementVector[0].display());
		}
		
		
		
	}
}