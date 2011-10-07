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
	import flash.net.Socket;
	import mx.logging.*;
	import mx.logging.targets.*;
		
	public class SlimSocketServiceTest
	{
		[Rule] public var includeMocks : IncludeMocksRule = new IncludeMocksRule([
			Socket,
			ISlimServiceContext
		]);

		private var loggingTarget : ILoggingTarget;
		private var service       : SocketService;
		private var server        : SlimSocketServer;
		private var mocks         : MockRepository;
		private var client        : Socket;
		private var processor     : SlimInstructionProcessor;
		private var exitFunction  : Function;
		private var context       : ISlimServiceContext;
		
		[Before]
		public function setUp() : void
		{
			mocks         = new MockRepository();
			loggingTarget = new TraceTarget();
			client        = Socket(mocks.createStub(Socket));
			context       = ISlimServiceContext(mocks.createStub(ISlimServiceContext));
		}
		
		[After]
		public function tearDown() : void
		{
			Log.removeTarget(loggingTarget);	
		}
		
		[Test]
		public function willStartUsingPortNumberOnly() : void
		{
			const PORT_NUMBER : int   = 635;
			const ARGS        : Array = [String(PORT_NUMBER)];
			
			testGetService(PORT_NUMBER, ARGS);
			Assert.assertFalse(Log.isDebug());
		}
		
		[Test]
		public function willStartInVerboseMode() : void
		{
			const PORT_NUMBER : int   = 639;
			const ARGS        : Array = ["-v", String(PORT_NUMBER)];
			
			testGetService(PORT_NUMBER, ARGS);
			Assert.assertTrue(Log.isDebug());
		}
		
		private function testGetService(port : int, args : Array) : void
		{
			Expect.call(context.getLoggingTarget()).returnValue(loggingTarget);
			Expect.call(context.getExitFunction()).returnValue(exitFunction);
			mocks.replayAll();//will ignore start up SLIM message
			service = SlimSocketService.getService(args, context);
			mocks.verifyAll();
			Assert.assertNotNull(service);
			Assert.assertEquals(port, service.port);
			Assert.assertNotNull(service.logger);
			Assert.assertTrue(Log.isInfo());
			Assert.assertEquals(exitFunction, service.exitFunction);
		}
	}
}