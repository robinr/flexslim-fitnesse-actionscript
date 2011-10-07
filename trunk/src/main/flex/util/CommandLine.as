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
	public dynamic class CommandLine extends CommandLineOption
	{
		public function isDefined(name : String) : Boolean
		{
			return (name in this);
		}

		protected override function unexpectedEndOfLine(argName : String) : void
		{
			throw new MissingCommandLineArgumentError(argName);
		}
		
		private static function makeSchema(descriptor : String) : Array
		{
			var schema : Array = new Array();
			
			for each (var token : OptionToken in OptionTokenizer.getTokens(descriptor))
				schema[token.name] = token.args;
			return schema;
		}
		
		private function setOptions(schema : Array, values : Array) : void
		{
			while(hasOption(values))
				setOption(schema, values.shift().substring(1), values);
		}
		
		private function setOption(schema : Array, optName : String, values : Array) : void
		{
			if (!(optName in schema))
				throw new UndefinedCommandLineOptionSuppliedError(optName);
			
			this[optName] = makeOption(schema, optName, values);			
		}
		
		public static function makeCommandLine(descriptor : String, values : Array) : CommandLine
		{
			const schema    : Array       = makeSchema(descriptor);
			var commandLine : CommandLine = new CommandLine();
			
			commandLine.setOptions(schema, values);
			commandLine.setValues(schema, "", values);
			
			if(values.length > 0)
				throw new UnexpectedCommandLineArgumentError(values);
			
			return commandLine;
		}
	}
}