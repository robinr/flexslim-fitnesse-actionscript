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

package util
{	
	public class OptionTokenizer
	{
		public static function getTokens(input : String) : Array
		{
			var pattern   : RegExp = /\[-(\w+)((?: \w+)*)\]/g; 
			var lastIndex : int    = 0;
			var tokens    : Array  = [];
		
			for(var matcher : Array = pattern.exec(input); 
				matcher != null; 
				matcher = pattern.exec(input)
			){
				addToken(tokens, matcher);
				lastIndex = pattern.lastIndex;
			}

			addReminder(tokens, input.substring(lastIndex));
			return tokens;
		}

		private static function addToken(tokens : Array, matcher : Array) : void
		{
			tokens.push(new OptionToken(matcher[1],matcher[2]));
		}
		
		private static function addReminder(tokens : Array, reminder : String) : void
		{
			if(reminder.length > 0)
				tokens.push(new OptionToken("",reminder));
		}		
	}
}