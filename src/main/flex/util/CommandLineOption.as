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
	public dynamic class CommandLineOption
	{	
		private var name_ : String = "";
		
		public function CommandLineOption()
		{
			
		}
		
		protected static function hasOption(values : Array) : Boolean
		{
			return (values.length > 0) && ('-' == values[0].charAt(0));
		}
		
		protected function unexpectedEndOfLine(argName : String) : void
		{
			throw new MissingCommandLineOptionArgumentError(name_, argName);			
		}
		
		protected function unexpectedOption(argName : String, values : Array) : void
		{
			throw new MissingCommandLineOptionArgumentError(name_, argName);			
		}
		
		protected function setValue(argName : String, values : Array) : void
		{
			if(values.length == 0)
				unexpectedEndOfLine(argName);
			if(hasOption(values))
				unexpectedOption(argName, values);
			this[argName] = values.shift();			
		}
		
		protected function setValues(schema : Array, optName : String, values : Array) : void
		{
			for each(var argName : String in schema[optName])
				setValue(argName, values);
		}
		
		public static function makeOption(schema : Array, optName : String, values : Array) : CommandLineOption 
		{
			var option : CommandLineOption = new CommandLineOption();
			
			option.name_ = optName;
			option.setValues(schema, optName, values);
			return option;
		}
	}
}