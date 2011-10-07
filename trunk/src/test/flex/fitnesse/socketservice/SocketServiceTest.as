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
	import asmock.framework.*;
	import asmock.framework.constraints.*;
	import asmock.integration.flexunit.*;
	import org.flexunit.Assert;
	
	import flash.errors.IllegalOperationError;
	import flash.errors.IOError;
	import flash.events.*;
	import flash.net.Socket;
	import flash.utils.Dictionary;	
	import mx.logging.ILogger;
	import util.sprintf;
				
	public class SocketServiceTest
	{		
		[Rule] public var includeMocks : IncludeMocksRule = new IncludeMocksRule([
			ILogger,
			ISocketServerFactory,
			ISocketServer
		]);
		
		private const PORT_NUMBER   : int = 0; //to avoid test fragility use the next free port
		private var   mocks         : MockRepository;
		private var   factory       : ISocketServerFactory;
		private var   logger	    : ILogger;
		private var   service       : SocketService;
		private var   servers       : Dictionary;
		private var   exitCalled    : Boolean;
		
		[Before]
		public function setUp() : void
		{
			mocks         = new MockRepository();
			factory       = ISocketServerFactory(mocks.createStub(ISocketServerFactory));
			logger        = ILogger(mocks.createStub(ILogger));
			service       = new SocketService(PORT_NUMBER, factory, mockExit, logger);
			servers       = new Dictionary();
			exitCalled    = false;
		}
		
		private function mockExit(exitCode : int) : void
		{
			exitCalled = true;
		}
		
		[Test]
		public function onStartWillBeListeningToCorrectPort() : void
		{
			Expect.call(logger.debug(sprintf("Listening on %d port.",PORT_NUMBER)));
			replayAll();
			service.start();
			verifyAll();
			Assert.assertTrue(0 != service.socket.localPort);
			Assert.assertTrue(service.socket.listening);
		}

		[Test]
		public function onStartWillShutDownIfBindingFailed() : void
		{
			var BUSY_PORT : int = service.socket.localPort;
			Expect.call(logger.info(sprintf("Binding to port %d failed.",BUSY_PORT)));
			Expect.call(logger.debug((new IOError("Error #2002: Operation attempted on invalid socket.")).message));
			replayAll();
			service = new SocketService(BUSY_PORT, factory, mockExit, logger);
			verifyAll();
			Assert.assertTrue(exitCalled);
		}

		[Test]
		public function willCreateServerOnConnectEvent() : void
		{
			const event : ServerSocketConnectEvent = makeConnectEvent();

			expectGetServer(event);
			replayAll();
			service.socket.dispatchEvent(event);
			verifyAll();
			Assert.assertTrue(event.socket.hasEventListener(Event.CLOSE));
		}

		[Test]
		public function willCallStopOnCloseEventFromClient() : void
		{
			const connectEvt : ServerSocketConnectEvent = makeConnectEvent();
			const closeEvt   : Event                    = new Event(Event.CLOSE); 
			
			expectGetServer(connectEvt);
			expectServerToClose(connectEvt.socket, closeEvt);
			replayAll();
			service.socket.dispatchEvent(connectEvt);
			connectEvt.socket.dispatchEvent(closeEvt);
			verifyAll();
			Assert.assertFalse(connectEvt.socket.hasEventListener(Event.CLOSE));
		}
		
		[Test]
		public function willProperlyShutdownOnCloseWhenNotConnected() : void
		{
			service.close();
			Assert.assertFalse(service.socket.listening);
			Assert.assertFalse(service.socket.hasEventListener(ServerSocketConnectEvent.CONNECT));
			Assert.assertFalse(service.socket.hasEventListener(Event.CLOSE));
		}

		[Test]
		public function willCallServerCloseOnServiceCloseWhenConnected() : void
		{
			const connectEvent : ServerSocketConnectEvent = makeConnectEvent();
			
			expectGetServer(connectEvent);
			expectAllServersToClose()
			replayAll();
			service.socket.dispatchEvent(connectEvent);
			service.close();
			verifyAll();
		}
		
		[Test]
		public function willLogAndShutDownOnCloseEvent() : void
		{
			const event : Event = new Event(Event.CLOSE);
			
			Expect.call(logger.info("Event.CLOSE event received. Shutting down ..."));
			Expect.call(logger.debug(event.toString()));
			replayAll();
			service.start();
			service.socket.dispatchEvent(event);
			verifyAll();
			Assert.assertFalse(service.socket.listening);
			Assert.assertFalse(service.socket.hasEventListener(ServerSocketConnectEvent.CONNECT));
			Assert.assertFalse(service.socket.hasEventListener(Event.CLOSE));
			Assert.assertTrue(exitCalled);
		}
		
		[Test]
		public function willSupportMultipleConnections() : void
		{
			var   events   : Array = makeEvents(10);
			const closeEvt : Event = new Event(Event.CLOSE); 

			for each(var e1 : ServerSocketConnectEvent in events)
				expectGetServer(e1);
			expectServerToClose(events[0].socket, closeEvt);
			delete servers[events[0].socket];
			expectAllServersToClose();
			replayAll();
			for each(var e2 : ServerSocketConnectEvent in events)
				callDispatch(e2);
			events.shift().socket.dispatchEvent(closeEvt);
			service.close();
			verifyAll();
		}		

		private function replayAll() : void
		{
			mocks.replayAll();
		}
		
		private function verifyAll() : void
		{
			mocks.verifyAll();
		}
		
		private function makeEvents(count : int) : Array
		{
			var events : Array = new Array();;
			
			for(var i : int = 0; i < count; i++)
				events.push(makeConnectEvent());
			return events;
		}
		
		private function makeConnectEvent() : ServerSocketConnectEvent
		{
			const client  : Socket = new Socket();
			const event   : ServerSocketConnectEvent = new ServerSocketConnectEvent(ServerSocketConnectEvent.CONNECT,false,false,client);
			
			return event;
		}
		
		private function expectGetServer(event : ServerSocketConnectEvent) : void
		{
			const server : ISocketServer = ISocketServer(mocks.createStub(ISocketServer));
			const client : Socket        = event.socket;

			servers[client] = server;
			Expect.call(logger.debug(event.toString()));
			Expect.call(factory.getSocketServer(
				service.socket, 
				client, 
				logger))
			.returnValue(server);
		}
		
		private function expectServerToClose(client : Socket, event : Event) : void
		{
			Expect.call(logger.debug(client.toString()+": "+event.toString()));
			Expect.call(servers[client].close());
		}
		
		private function expectAllServersToClose() : void
		{
			for each (var server : Object in servers)
				Expect.call(ISocketServer(server).close());			
		}
		
		private function callDispatch(event : ServerSocketConnectEvent) : void
		{
			service.socket.dispatchEvent(event);
		}
		
	}
}