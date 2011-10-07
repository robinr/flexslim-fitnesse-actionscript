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
package fitnesse.socketservice
{
	import flash.errors.IllegalOperationError;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.Socket;	
	import mx.logging.ILogger;
	
	public class AbstractSocketServer implements ISocketServer 
	{
		private var socket_ : Socket;
		private var logger_ : ILogger;
		
		public function AbstractSocketServer(self : AbstractSocketServer, client : Socket, logger : ILogger)
		{
			if(self != this)
				throw new IllegalOperationError("AbstractSocketServer cannot be instantiated directly.");
			socket_ = client;
			logger_ = logger;
			socket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, onDataArrived);
		}
		
		public function get socket() : Socket
		{
			return socket_;
		}
		
		public function get logger() : ILogger
		{
			return logger_;
		}
		
		public function close() : void
		{
			socket.removeEventListener(ProgressEvent.SOCKET_DATA,onDataArrived);
			socket.removeEventListener(IOErrorEvent.IO_ERROR,onIOError);
			socket.close();
		}
		
		private function onIOError(evt : IOErrorEvent) : void
		{
			logger.error(socket.toString() + ": "+ evt.toString());
			handleIOError();
		}
		
		protected function handleIOError() : void
		{
			throw new IllegalOperationError("Unhandled IO Error");							
		}
		
		private function onDataArrived(evt : ProgressEvent) : void
		{
			logger.debug(socket.toString() + ": "+ evt.toString());
			processRequest();
		}
		
		protected function processRequest() : void
		{
			throw new IllegalOperationError("Unimplemented 'processRequest()' abstract method");				
		}
	}
}