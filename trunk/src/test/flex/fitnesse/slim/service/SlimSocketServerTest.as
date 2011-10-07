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
	
	import flash.events.*;
	import flash.net.ServerSocket;
	import flash.net.Socket;	
	import mx.logging.ILogger;
	import util.sprintf;
			
	public class SlimSocketServerTest
	{
		[Rule] public var includeMocks : IncludeMocksRule = new IncludeMocksRule([
			ILogger,
			Socket,
			IInstructionProcessor
		]);
		
		private var mocks        : MockRepository;
		private var logger       : ILogger;
		private var processor	 : IInstructionProcessor;
		private var client       : Socket;
		private var parent       : ServerSocket;
		private var parentClosed : Boolean;
		private var server       : SlimSocketServer;

		private static const INSTRUCTIONS : String = "[[id_0, import, xyz]]";
		private static const RESULTS      : String = "[[id_0, result]]";
		private static const IN_LENGTH    : uint   = INSTRUCTIONS.length;
		private static const OUT_LENGTH   : uint   = RESULTS.length;
		
		[Before]
		public function setUp() : void
		{
			mocks        = new MockRepository();
			logger       = ILogger(mocks.createStub(ILogger));
			processor    = IInstructionProcessor(mocks.createStub(IInstructionProcessor));
			client       = Socket(mocks.createStub(Socket));				
			parent       = new ServerSocket();
			//dispacthEvent is not mockable, hence need this trick 
			parentClosed = false;
			parent.addEventListener(Event.CLOSE,function(evt : Event) : void{ parentClosed = true; });
		}
		
		[Test]
		public function willSendVersionInConstructor() : void
		{
			Expect.call(client.writeUTFBytes("Slim -- V0.3\n"));
			Expect.call(client.flush());
			mocks.replayAll();
			server = createServer();
			mocks.verifyAll();
		}
		
		[Test]
		public function willShutDownParentIfReceivedBye() : void
		{
			expectReadLength(3);
			Expect.call(client.bytesAvailable).returnValue(3);
			Expect.call(client.readUTFBytes(3)).returnValue("bye");
			Expect.call(logger.debug("Instructions: bye"));
			mocks.replayAll();
			server = createServer();
			client.dispatchEvent(new ProgressEvent(ProgressEvent.SOCKET_DATA));
			mocks.verifyAll();
			Assert.assertTrue(parentClosed);
			Assert.assertEquals(0, server.length);
		}

		[Test]
		public function willCallInstructionProcessorIfSufficientInputAndNotBuy() : void
		{
			expectReadLength(IN_LENGTH);
			Expect.call(client.bytesAvailable).returnValue(IN_LENGTH);
			expectProcessRequest();
			mocks.replayAll();
			server = createServer();
			client.dispatchEvent(new ProgressEvent(ProgressEvent.SOCKET_DATA));
			mocks.verifyAll();
			Assert.assertEquals(0, server.length);
		}

		private function expectReadLength(inLength : uint) : void
		{
			Expect.call(client.readUTFBytes(SlimFormat.LENGTH_WIDTH)).returnValue(sprintf(SlimFormat.LENGTH_FORMAT,inLength));
			Expect.call(client.readUTFBytes(1)).returnValue(":");			
		}

		private function expectProcessRequest() : void
		{
			Expect.call(client.readUTFBytes(IN_LENGTH)).returnValue(INSTRUCTIONS);
			Expect.call(logger.debug("Instructions: "+INSTRUCTIONS));
			Expect.call(processor.processInstructions(INSTRUCTIONS)).returnValue(RESULTS);
			Expect.call(logger.debug("Results: "+RESULTS));
			Expect.call(client.writeUTFBytes(sprintf(SlimFormat.LENGTH_BODY_FORMAT,OUT_LENGTH,RESULTS)));			
		}
		
		[Test]
		public function willReturnIfNotSufficientInput() : void
		{
			const available : uint = IN_LENGTH - 1;

			expectReadLength(IN_LENGTH);
			Expect.call(client.bytesAvailable).returnValue(available);
			Expect.call(logger.debug("Insufficient input length: "+available));
			mocks.replayAll();
			server = createServer();
			client.dispatchEvent(new ProgressEvent(ProgressEvent.SOCKET_DATA));
			mocks.verifyAll();
			Assert.assertEquals(IN_LENGTH, server.length);
		}

		[Test]
		public function willResumeProcessingIfWasInssuficientForTheFirstTime() : void
		{
			const available    : uint   = IN_LENGTH - 1;

			expectReadLength(IN_LENGTH);
			Expect.call(client.bytesAvailable).returnValue(available);
			Expect.call(logger.debug("Insufficient input length: "+available));
			Expect.call(client.bytesAvailable).returnValue(IN_LENGTH);
			expectProcessRequest();
			mocks.replayAll();
			server = createServer();
			client.dispatchEvent(new ProgressEvent(ProgressEvent.SOCKET_DATA));
			client.dispatchEvent(new ProgressEvent(ProgressEvent.SOCKET_DATA));
			mocks.verifyAll();
			Assert.assertEquals(0, server.length);
		}
		
		private function createServer() : SlimSocketServer
		{
			return new SlimSocketServer(parent, client, processor, logger);
		}
	}
}