/* ****************************************************
*     ____ _    ____ _  _    ____ _    _ _  _      *
*	|___ |    |___  \/     [__  |    | |\/|       *
*	|    |___ |___ _/\_    ___] |___ | |  |       *
*                                                  *
****************************************************

This program is the implementation of Flex Slim Server which communicates with Fitnesse.jar allows
creation of Functional Test Suites on Actionscript 3.0 

Copyright (C) 2011  

This software was developed by : Asher Sterkin
and maintained by              : Raghavendra. R

For any commercial purpose a prior permission should be obtained
from the authors E-mail : <raghavendrar@nds.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

For any feedback please send e-mail: raghavendrar@nds.com or 
robinr.rao@gmail.com

*/
package fitnesse.slim.service
{
	import asmock.framework.*;
	import asmock.framework.constraints.*;
	import asmock.integration.flexunit.*;
	
	import org.flexunit.Assert;
	
	public class ListSerializerTest
	{
		private var serializer : ListSerializer;
		private var list       : Array;
		
		[Before]
		public function setUp() : void
		{
			list       = new Array();
			serializer = new ListSerializer();
		}
		
		[Test]
		public function nullListSerialize() : void
		{
			Assert.assertEquals("[000000:]", serializer.serialize(list));
		}
		
		[Test]
		public function oneItemListSerialize() : void
		{
			list.push("hello");
			Assert.assertEquals("[000001:000005:hello:]", serializer.serialize(list));			
		}
		
		[Test]
		public function twoItemsSerialize() : void
		{
			list.push("hello");
			list.push("world");
			Assert.assertEquals("[000002:000005:hello:000005:world:]" ,serializer.serialize(list));
		}
		
		[Test]
		public function serializeNestedList() : void
		{
			const sublist : Array = ["element"];
			list.push(sublist);
			Assert.assertEquals("[000001:000024:[000001:000007:element:]:]" ,serializer.serialize(list));			
		}
		
		[Test]
		public function serializeListWithNonString() : void
		{
			list.push(1);
			Assert.assertEquals("[000001:000001:1:]", serializer.serialize(list));						
		}
		
		[Test]
		public function serializeNullElement() : void
		{
			list.push(null);
			Assert.assertEquals("[000001:000004:null:]", serializer.serialize(list));						
		}
		
		private function checkList() : void
		{
			const serialized   : String = serializer.serialize(list);
			const deserialized : Array = serializer.deserialize(serialized);
			
			Assert.assertEquals(list.toString(), deserialized.toString());
		}
		
		[Test(expects=SyntaxError)]
		public function cantDeserializeNullString() : void
		{
			serializer.deserialize(null);
		}
		
		[Test(expects=SyntaxError)]
		public function cantDeserializeEmptyString() : void
		{
			serializer.deserialize("");
		}
		
		[Test(expects=SyntaxError)]
		public function cantDeserializeStringThatDoesntStartWithBracket() : void
		{
			serializer.deserialize("hello");
		}
		
		[Test(expects=SyntaxError)]
		public function cantDeserializeStringThatDoesntEndWithBracket() : void
		{
			serializer.deserialize("[000000:");
		}
		
		[Test]
		public function emptyList() : void
		{
			checkList();	
		}
		
		[Test]
		public function listWithOneElement() : void
		{
			list.push("hello");
			checkList();
		}
		
		[Test]
		public function listWithTwoElements() : void
		{
			list.push("hello");
			list.push("world");
			checkList();
		}
		
		[Test]
		public function listWithSublist() : void
		{
			list.push(["hello","world"]);
			checkList();
		}
	}
}