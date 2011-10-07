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
	import asmock.framework.*;
	import asmock.framework.constraints.*;
	import asmock.integration.flexunit.*;
	import org.flexunit.Assert;
	
	import fitnesse.socketservice.*;	
	import flash.net.*;
	import mx.logging.*;

	public class SlimSocketServerFactoryTest
	{		
		[Rule] public var includeMocks : IncludeMocksRule = new IncludeMocksRule([
			Socket,
			ServerSocket,
			ILogger
		]);
		
		private var mocks   : MockRepository;
		private var parent  : ServerSocket;
		private var client  : Socket;
		private var logger  : ILogger;
		private var factory : SlimSocketServerFactory;
		
		[Before]
		public function setUp() : void
		{
			mocks   = new MockRepository();
			parent  = ServerSocket(mocks.createStub(ServerSocket));
			client  = Socket(mocks.createStub(Socket));
			logger  = ILogger(mocks.createStub(ILogger));
			factory = new SlimSocketServerFactory();
		}
		
		[Test]
		public function getServerWillCreateSlimSocketServer() : void
		{
			mocks.replayAll();
			const server : SlimSocketServer = SlimSocketServer(factory.getSocketServer(parent, client, logger));
			mocks.verifyAll();
			Assert.assertNotNull(server);
			Assert.assertEquals(logger, server.logger);
			Assert.assertEquals(client, server.socket);
			const processor : SlimInstructionProcessor = SlimInstructionProcessor(server.processor);
			Assert.assertNotNull(processor);
			Assert.assertNotNull(processor.serializer);
			Assert.assertNotNull(processor.executor);
		}		
	}
}