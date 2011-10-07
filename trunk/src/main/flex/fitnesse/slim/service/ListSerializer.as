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
	import util.sprintf;
	
	public class ListSerializer
	{
		public function deserialize(input : String) : Array
		{
			checkInputString(input);
			return deserializeString(input);
		}
		
		private function checkInputString(input : String) : void
		{
			if(null == input) 
				throw new SyntaxError("Cannot deserialize null string");
			if("" == input) 
				throw new SyntaxError("Cannot deserialize empty string");			
		}
		
		private function deserializeString(input : String) : Array
		{
			const tokens  : Array = SlimFormat.LIST_PATTERN.exec(input);
			
			if(null == tokens)
				throw new SyntaxError("Input list does not follow the [length:body] pattern");
			return deserializeList(tokens.length, tokens.body);
		}
		
		private function deserializeList(itemCount : int, body : String) : Array
		{
			var result  : Array  = [];

			for(var i : int=0; i<itemCount; i++)
				body = deserializeItem(body, result);
			return result;	
		}
		
		private function deserializeItem(item : String, result : Array) : String
		{
			const tokens  : Array  = SlimFormat.ITEM_PATTERN.exec(item);
			
			if((null == tokens) || (':' != tokens.tail.charAt(tokens.length)))
				throw new SyntaxError("Item does not follow the length:value: format");
			
			result.push(deserializeItemString(tokens.tail.substr(0,tokens.length)));
			return tokens.tail.substr(tokens.length);
		}

		private function deserializeItemString(item : String) : Object
		{
			try
			{
				return deserializeString(item);
			} catch (e : SyntaxError) {
			}
			return item;				
		}
		
		public function serialize(results : Array) : String
		{
			return sprintf(SlimFormat.LIST_FORMAT,results.length, serializeItems(results));
		}
		
		private function serializeItems(results : Array) : String
		{
			var buf : String = "";
			for each(var item : Object in results)
			{
				const sItem : String = serializeItem(item);
				buf += sprintf(SlimFormat.ITEM_FORMAT,sItem.length,sItem);
			}
			return buf;
		}
		
		private function serializeItem(item : Object) : String
		{
			if(item == null) return "null";
			if(item is Array) return serialize(item as Array);
			return item.toString();
		}
	}
}