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
	import fitnesse.socketservice.*;
	
	import flash.net.*;
	
	import mx.logging.*;
	import fitnesse.slim.statement.StatementExecutor;
	import fitnesse.slim.statement.StatementFactory;
	
	public class SlimSocketServerFactory implements ISocketServerFactory
	{
		private const serializer : ListSerializer    = new ListSerializer();
		private const sFactory   : StatementFactory  = new StatementFactory();
		private const sExecutor  : StatementExecutor = new StatementExecutor()
		private const executor   : ListExecutor      = new ListExecutor(sFactory, sExecutor);
		
		public function SlimSocketServerFactory()
		{
		}
		
		public function getSocketServer(parent : ServerSocket, client : Socket, logger : ILogger):ISocketServer
		{
			return new SlimSocketServer(parent, client, new SlimInstructionProcessor(serializer, executor), logger);	
		}
	}
}