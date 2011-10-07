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

package fitnesse.slim.statement
{

	public class StatementFactory
	{
		private var statements : Array;
		
		public function StatementFactory()
		{
			statements                  = new Array();
			statements["import"]        = getImportStatement;
			statements["make"]          = getMakeStatement;
			statements["call"]          = getCallStatement;
			statements["callAndAssign"] = getCallAndAssignStatement;
		}
		
		public function getStatement(args : Array) : IStatement
		{
			const instruction : String = args.shift();
			if(instruction in statements)
				return statements[instruction](args);
			return new InvalidStatement(instruction);
		}
		
		private function getInvalidStatement(instruction : String) : IStatement
		{
			return new InvalidStatement(instruction);
		}
		
		private function getImportStatement(args : Array) : IStatement
		{
			return new ImportStatement(args[0]);
		}

		private function getMakeStatement(args : Array) : IStatement
		{
			const instance  : String = args.shift();
			const className : String = args.shift();
			
			return new MakeStatement(instance, className, args);
		}
		
		private function getCallStatement(args : Array) : IStatement
		{
			const instance  : String = args.shift();
			const method    : String = args.shift();
			
			return new CallStatement(instance, method, args);			
		}
		
		private function getCallAndAssignStatement(args : Array) : IStatement
		{
			const target    : String = args.shift();
			const instance  : String = args.shift();
			const method    : String = args.shift();
			
			return new CallAndAssignStatement(target, instance, method, args);			
		}		
	}
}