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
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.ServerSocket;
	import flash.net.Socket;
	import flash.utils.Dictionary;
	
	import mx.logging.ILogger;
	
	import util.sprintf;
	
	public class SocketService
	{
		private var socket_       : ServerSocket;
		private var port_         : int;
		private var factory_      : ISocketServerFactory;
		private var logger_       : ILogger;
		private var servers_      : Dictionary;
		private var exitFunction_ : Function;
		
		public function SocketService(port : int, factory : ISocketServerFactory, exitFunction: Function, logger : ILogger)
		{
			factory_      = factory;
			exitFunction_ = exitFunction;
			logger_       = logger;
			socket_       = new ServerSocket();
			port_         = port;
			servers_      = new Dictionary();
			setListeners();
			bind();
		}

		private function bind() : void
		{
			try {
				socket.bind(port);
			} catch(e : Error) {
				logger.info(sprintf("Binding to port %d failed.",port));
				logger.debug(e.message);
				exitFunction(-1);
			}		
		}
		
		public function get factory() : ISocketServerFactory
		{
			return factory_;
		}
		
		public function get socket() : ServerSocket
		{
			return socket_;
		}

		public function get port() : int
		{
			return port_;
		}
		
		public function get logger() : ILogger
		{
			return logger_;
		}
		
		public function get exitFunction() : Function
		{
			return exitFunction_;
		}
		
		public function start() : void
		{
			logger.debug(sprintf("Listening on %d port.",port));
			socket.listen();
		}
		
		private function onConnect(evt : ServerSocketConnectEvent) : void
		{
			const client : Socket        = evt.socket;
			const server : ISocketServer = getSocketServer(client);
			
			
			const onClientClose : Function = function(evt : Event) : void
			{
				logger.debug(client.toString()+": "+evt.toString());
				servers_[client].close();
				delete servers_[client];
				client.removeEventListener(Event.CLOSE, onClientClose);				
			}
			logger.debug(evt.toString());
			servers_[client] = server;
			client.addEventListener(Event.CLOSE, onClientClose);
		}

		protected function getSocketServer(client : Socket) : ISocketServer
		{
			return factory.getSocketServer(socket, client, logger);
		}
		
		private function onClose(evt : Event) : void
		{
			logger.info("Event.CLOSE event received. Shutting down ...");
			logger.debug(evt.toString());
			close();
		}
					
		public function close() : void
		{
			for each(var server : Object in servers_)
				ISocketServer(server).close();
			removeListeners();
			socket.close();
			exitFunction(0);
		}

		private function setListeners() : void
		{
			socket.addEventListener(ServerSocketConnectEvent.CONNECT, onConnect);
			socket.addEventListener(Event.CLOSE, onClose);			
		}
		
		private function removeListeners() : void
		{
			socket.removeEventListener(ServerSocketConnectEvent.CONNECT, onConnect);
			socket.removeEventListener(Event.CLOSE, onClose);			
		}
	}
}