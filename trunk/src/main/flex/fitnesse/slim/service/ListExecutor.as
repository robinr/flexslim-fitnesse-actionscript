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
	import fitnesse.slim.statement.CallStatement;
	import fitnesse.slim.statement.IStatement;
	import fitnesse.slim.statement.StatementExecutor;
	import fitnesse.slim.statement.StatementFactory;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;

    [Event(name="done", type="flash.events.Event")]
    public class ListExecutor extends EventDispatcher
	{
		private var factory_          : StatementFactory;
		private var executor_         : StatementExecutor;
        private var instructions_     : Array;
        public  var results           : Array;
        private var currentStatement_ : IStatement;
        private var currentId_        : String;
        
		public function ListExecutor(factory : StatementFactory=null, executor : StatementExecutor=null)
		{
			factory_  = factory;
			executor_ = executor;
		}
		
		public function execute(instructions : Array) : void
		{
            instructions_ = instructions;
            results = [];
            processNextInstruction();
		}
        
        private function processNextInstruction():void
        {
            if(instructions_.length > 0) {
                var instruction:Object = instructions_.shift();
                executeInstruction(instruction);    
            }
            else {
                dispatchEvent(new Event("done"));
            }
        }
        
		private function executeInstruction(inst : Object) : void
		{
			if(!(inst is Array))
				throw new SyntaxError("Instruction must be an Array");
			var instruction : Array  = inst as Array;
			currentId_ = instruction.shift();
            currentStatement_ = factory_.getStatement(instruction);
            if(currentStatement_ is CallStatement) {
                (currentStatement_ as CallStatement).addEventListener("done", doneHandler);
                currentStatement_.execute(executor_);
            }
            else {
                var result:Object = currentStatement_.execute(executor_);
                results.push([currentId_,result]);
                processNextInstruction();
            }
		}
        
        private function doneHandler(event:Event):void
        {
            (currentStatement_ as CallStatement).removeEventListener("done", doneHandler);
            results.push([currentId_, (currentStatement_ as CallStatement).retrieveResult()]);
            processNextInstruction();
        }
	}
}