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
	import fitnesse.slim.statement.IStatement;
	import fitnesse.slim.statement.StatementExecutor;
	import fitnesse.slim.statement.StatementFactory;
	
	public class ListExecutorTest
	{	
		[Rule] public var includeMocks : IncludeMocksRule = new IncludeMocksRule([
			StatementFactory,
			StatementExecutor,
			IStatement
		]);
		
		private var mocks     : MockRepository;
		private var factory   : StatementFactory;
		private var sExecutor : StatementExecutor;
		private var statement : IStatement;
		private var executor  : ListExecutor;
		
		[Before]
		public function setUp():void
		{
			mocks     = new MockRepository();			
			factory   = StatementFactory(mocks.createStub(StatementFactory));
			sExecutor = StatementExecutor(mocks.createStub(StatementExecutor));
			statement = IStatement(mocks.createStub(IStatement));
			executor  = new ListExecutor(factory, sExecutor);
		}
		
		[Test(expects=SyntaxError)]
		public function cannotExecuteIfNotArrayOfArrays() : void
		{
			executor.execute(["aaa"]);
		}
		
		[Test]
		public function willExecuteOneStatementAtTheTime() : void
		{
			const instruction : Array  = ["id1", "statement", "arg"];
			const result      : Object = new Object();
			
			Expect.call(factory.getStatement(null)).constraints([
				new ArrayEquals(["statement", "arg"])	
			]).returnValue(statement);
			Expect.call(statement.execute(sExecutor)).returnValue(result);
			mocks.replayAll();
			const r : Array = executor.execute([instruction]);
			mocks.verifyAll();
			Assert.assertEquals(["id1",result].toString(), r.toString());
		}
	}
}