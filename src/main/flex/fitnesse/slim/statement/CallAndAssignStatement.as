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
    import flash.events.Event;
    import flash.events.EventDispatcher;
    
    [Event(name="done", type="flash.events.Event")]
	public class CallAndAssignStatement extends EventDispatcher implements IStatement
	{
        private var executor_ : StatementExecutor;
    	private var target_   : String;
		private var instance_ : String;
		private var method_   : String;
		private var args_     : Array;
		
		public function CallAndAssignStatement(target : String, instance : String, method : String, args : Array)
		{
			target_   = target;
			instance_ = instance;
			method_   = method;
			args_     = args;
		}
		
		public function execute(executor : StatementExecutor) : Object
		{
            executor_ = executor;
            executor_.addEventListener("done", doneHandler);
            
        	return executor.callAndAssign(target_, instance_, method_, args_);
		}
                
        public function retrieveResult() : Object 
        {
            return executor_.result;
        }
        
        private function doneHandler(event:Event) : void 
        {
            executor_.removeEventListener("done", doneHandler);
            dispatchEvent(new Event("done"));
        }
	}
}