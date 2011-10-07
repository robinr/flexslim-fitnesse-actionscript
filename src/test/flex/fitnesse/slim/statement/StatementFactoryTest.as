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
	import asmock.framework.*;
	import asmock.framework.constraints.*;
	import asmock.integration.flexunit.*;	
	import org.flexunit.Assert;
	
	public class StatementFactoryTest
	{	
		[Rule] public var includeMocks : IncludeMocksRule = new IncludeMocksRule([
			StatementExecutor
		]);
		
		private var mocks    : MockRepository;
		private var executor : StatementExecutor;
		private var factory  : StatementFactory;
		
		[Before]
		public function setUp():void
		{
			mocks    = new MockRepository();			
			executor = StatementExecutor(mocks.createStub(StatementExecutor));
			factory  = new StatementFactory();
		}
				
		[Test]
		public function willReturnInvalidStatementIfNotFound() : void
		{
			const statement : IStatement = factory.getStatement(["hello"]);
			const result    : Object     = statement.execute(executor);
			const EXPECTED  : SlimError  = new SlimError("INVALID_STATEMENT: hello");
			
			Assert.assertEquals(EXPECTED.toString(), result.toString());
		}
		
		[Test]
		public function willSupportImportStatement() : void
		{
			const PATH      : String     = "C:/fitnesse";
			const statement : IStatement = factory.getStatement(["import", PATH]);
			const EXPECTED  : String     = "OK";
			
			Expect.call(executor.addPath(PATH)).returnValue(EXPECTED);
			mocks.replayAll();
			const result : Object = statement.execute(executor);
			mocks.verifyAll();
			Assert.assertEquals(EXPECTED, result.toString());
		}
		
		[Test]
		public function willSupportMakeStatement() : void
		{
			const INSTANCE   : String = "x";
			const CLASS_NAME : String = "classA";
			const ARGS       : Array  = ["arg1", "arg2"];
			const statement  : IStatement = factory.getStatement([
				"make", 
				INSTANCE, 
				CLASS_NAME].concat(ARGS));
			const EXPECTED  : String     = "OK";
			
			Expect.call(executor.create(INSTANCE,CLASS_NAME,ARGS)).returnValue(EXPECTED);
			mocks.replayAll();
			const result : Object = statement.execute(executor);
			mocks.verifyAll();
			Assert.assertEquals(EXPECTED, result.toString());
		}
		
		[Test]
		public function willSupportCallStatement() : void
		{
			const INSTANCE    : String = "x";
			const METHOD_NAME : String = "methodB";
			const ARGS        : Array  = ["arg1", "arg2"];
			const statement  : IStatement = factory.getStatement([
				"call", 
				INSTANCE, 
				METHOD_NAME].concat(ARGS));
			const EXPECTED  : String     = "OK";
			
			Expect.call(executor.call(INSTANCE,METHOD_NAME,ARGS)).returnValue(EXPECTED);
			mocks.replayAll();
			const result : Object = statement.execute(executor);
			mocks.verifyAll();
			Assert.assertEquals(EXPECTED, result.toString());
		}
		
		[Test]
		public function willSupportCallAndAssignStatement() : void
		{
			const TARGET      : String = "y";
			const INSTANCE    : String = "x";
			const METHOD_NAME : String = "methodB";
			const ARGS        : Array  = ["arg1", "arg2"];
			const statement  : IStatement = factory.getStatement([
				"callAndAssign",
				TARGET,
				INSTANCE, 
				METHOD_NAME].concat(ARGS));
			const EXPECTED  : String     = "OK";
			
			Expect.call(executor.callAndAssign(TARGET,INSTANCE,METHOD_NAME,ARGS)).returnValue(EXPECTED);
			mocks.replayAll();
			const result : Object = statement.execute(executor);
			mocks.verifyAll();
			Assert.assertEquals(EXPECTED, result.toString());
		}				
	}
}