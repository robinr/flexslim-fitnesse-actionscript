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
	import fitnesse.slim.statement.StatementExecutor;
	import fitnesse.slim.statement.StatementFactory;

	public class ListExecutor
	{
		private var factory_  : StatementFactory;
		private var executor_ : StatementExecutor;
		
		public function ListExecutor(factory : StatementFactory=null, executor : StatementExecutor=null)
		{
			factory_  = factory;
			executor_ = executor;
		}
		
		public function execute(instructions : Array) : Array
		{
			var results : Array = [];
			for each(var instruction : Object in instructions)
				executeInstruction(instruction, results);
			return results;
		}
		
		private function executeInstruction(inst : Object, results : Array) : void
		{
			if(!(inst is Array))
				throw new SyntaxError("Instruction must be an Array");
			var instruction : Array  = inst as Array;
			const id        : String = instruction.shift();
			results.push([id,factory_.getStatement(instruction).execute(executor_)]);
		}
	}
}