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
	import mx.logging.ILogger;
		
	public class SlimInstructionProcessorTest
	{		
		[Rule] public var includeMocks : IncludeMocksRule = new IncludeMocksRule([
			ListSerializer,
			ListExecutor
		]);

		private var mocks        : MockRepository;
		private var serializer   : ListSerializer;
		private var executor     : ListExecutor;
		private var processor    : SlimInstructionProcessor;
		
		[Before]
		public function setUp():void
		{
			mocks        = new MockRepository();
			serializer   = ListSerializer(mocks.createStub(ListSerializer));
			executor     = ListExecutor(mocks.createStub(ListExecutor));
			processor    = new SlimInstructionProcessor(serializer, executor);
		}
		
		[Test]
		public function willProcessInstructions() : void
		{
			const input        : String = "[[id_01, import xyz]]";
			const instructions : Array  = [[]];
			const results      : Array  = [new Object()];
			const replay       : String = "replay";
			
			Expect.call(serializer.deserialize(input)).returnValue(instructions);
			Expect.call(executor.execute(instructions)).returnValue(results);
			Expect.call(serializer.serialize(null)).returnValue(replay).constraints([
				Is.equal(results)
			]);
			mocks.replayAll();
			processor.processInstructions(input);
			mocks.verifyAll();
		}				
	}
}