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
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.Socket;	
	import mx.logging.ILogger;	
	
	public class AbstractSocketServerTest
	{	
		[Rule] public var includeMocks : IncludeMocksRule = new IncludeMocksRule([
			ILogger
		]);
		
		private var mocks  : MockRepository;
		private var logger : ILogger;
		private var client : Socket;
		private var server : AbstractSocketServer;
		
		[Before]
		public function setUp() : void
		{
			mocks   = new MockRepository();
			logger  = ILogger(mocks.createStub(ILogger));
			client  = new Socket();			
			server  = new SampleSocketServer(client, logger);
		}
		
		[Test]
		public function cannotBeInstantiatedDirectly() : void
		{
			try
			{
				new AbstractSocketServer(null, client, logger);
				Assert.fail("Should not get there");
			} catch (e : IllegalOperationError)
			{
				
			}
		}
		
		[Test]
		public function willLogIOErrorEventAndWillCallIOErrorFunction() : void
		{
			const event : IOErrorEvent = new IOErrorEvent(IOErrorEvent.IO_ERROR);
			
			Expect.call(logger.error(client.toString()+": "+event.toString()));
			mocks.replayAll();
			client.dispatchEvent(event);
			mocks.verifyAll();
		}
		
		[Test]
		public function willTraceSocketDataEventAndCallReadRequestFunction() : void
		{
			const event : ProgressEvent = new ProgressEvent(ProgressEvent.SOCKET_DATA);
	
			Expect.call(logger.debug(client.toString()+": "+event.toString()));
			mocks.replayAll();
			client.dispatchEvent(event);
			mocks.verifyAll();
		}
		
		[Test]
		public function willShutDownConnectionOnClose() : void
		{
			try
			{
				server.close();
				Assert.fail("Closing socket should throw an exception");
			} catch (e : Error)
			{
				
			}
			Assert.assertFalse(client.hasEventListener(IOErrorEvent.IO_ERROR));
			Assert.assertFalse(client.hasEventListener(ProgressEvent.SOCKET_DATA));				
		}
	}
}