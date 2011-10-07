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
	public class SlimFormat
	{
		public static const LENGTH_WIDTH       : int    = 6;
		public static const LENGTH_FORMAT      : String = "%0"+LENGTH_WIDTH+"d";
		public static const LENGTH_BODY_FORMAT : String = LENGTH_FORMAT+":%s";
		public static const LIST_PATTERN       : RegExp = /\[(?P<length>\d{6}):(?P<body>.*)\]/;
		public static const LIST_FORMAT        : String = "["+LENGTH_BODY_FORMAT+"]";
		public static const ITEM_PATTERN       : RegExp = /(?P<length>\d{6}):(?P<tail>.*)/;
		public static const ITEM_FORMAT        : String = LENGTH_BODY_FORMAT+":";
		public static const RESPONSE_FORMAT    : String = LENGTH_BODY_FORMAT;
	}
}