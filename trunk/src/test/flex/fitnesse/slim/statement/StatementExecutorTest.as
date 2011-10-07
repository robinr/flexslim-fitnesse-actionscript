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
	import org.flexunit.Assert;

	public class StatementExecutorTest
	{	
		private var   executor     : StatementExecutor;
		private const PATH1        : String = "fitnesse.fixtures";
		private const PATH2        : String = "fitnesse.slim.statement";
		private const forCompiler1 : ClassInDefaultPackage = null;
		private const forCompiler2 : ClassInNonDefaultPackage = null;
		
		[Before]
		public function setUp():void
		{
			executor = new StatementExecutor();
			executor.addPath(PATH1);
			executor.addPath(PATH2);
		}
		
		[Test]
		public function willExecuteImportStatement() : void
		{
			const EXPECTED : Array  = ["", PATH1+".", PATH2+"."];
			
			Assert.assertEquals(EXPECTED.toString(), executor.path);
		}
		
		[Test]
		public function canMakeAnInstanceInDefaultPackage() : void
		{
			const result      : String = String(executor.create("instance1", "ClassInDefaultPackage",[]));
			const instance    : Object = executor.instances["instance1"];
			
			Assert.assertEquals("OK", result);
			Assert.assertNotNull(instance);
			Assert.assertTrue(instance is ClassInDefaultPackage);
		}
		
		[Test]
		public function canMakeAnInstanceInNonDefaultPackage() : void
		{
			const result      : String = String(executor.create("instance1", "ClassInNonDefaultPackage",[]));
			const instance    : Object = executor.instances["instance1"];
			
			Assert.assertEquals("OK", result);
			Assert.assertNotNull(instance);
			Assert.assertTrue(instance is ClassInNonDefaultPackage);
		}

		[Test]
		public function willSupportConstructorWithOneArgument() : void
		{
			const result      : String = String(executor.create("instance1", "ClassInNonDefaultPackage1",["arg"]));
			const instance    : Object = executor.instances["instance1"];
			
			Assert.assertEquals("OK", result);
			Assert.assertNotNull(instance);
			Assert.assertTrue(instance is ClassInNonDefaultPackage1);
		}

		[Test]
		public function willSupportConstructorWithTwoArguments() : void
		{
			const result      : String = String(executor.create("instance1", "ClassInNonDefaultPackage2",["arg1","arg2"]));
			const instance    : Object = executor.instances["instance1"];
			
			Assert.assertEquals("OK", result);
			Assert.assertNotNull(instance);
			Assert.assertTrue(instance is ClassInNonDefaultPackage2);
		}
		
		[Test]
		public function willReturnErrorIfArgumentNumberMismatchInConstructor() : void
		{
			const result      : String    = String(executor.create("instance1", "ClassInNonDefaultPackage1",[]));
			const instance    : Object    = executor.instances["instance1"];
			const EXPECTED    : SlimError = new SlimError("COULD_NOT_INVOKE_CONSTRUCTOR ClassInNonDefaultPackage1[0]");
			
			Assert.assertEquals(EXPECTED.toString(), result);
			Assert.assertNull(instance);
		}

		[Test]
		public function willReturnErrorForUnsupprtedNumberOfArgumentsInConstructor() : void
		{
			const result      : String    = String(executor.create("instance1", "ClassInNonDefaultPackage1",["a","b","c","d","e"]));
			const instance    : Object    = executor.instances["instance1"];
			const EXPECTED    : SlimError = new SlimError("UNSUPPORTED_NUMBER_OF_ARGUMENTS_IN_CONSTRUCTOR ClassInNonDefaultPackage1[5]");
			
			Assert.assertEquals(EXPECTED.toString(), result);
			Assert.assertNull(instance);
		}
		
		[Test]
		public function willReturnAnErrorIfClassNotFound() : void
		{
			const result      : String    = String(executor.create("instance1", "UndefinedClass",[]));
			const instance    : Object    = executor.instances["instance1"];
			const EXPECTED    : SlimError = new SlimError("NO_CLASS UndefinedClass");
			
			Assert.assertEquals(EXPECTED.toString(), result);
			Assert.assertNull(instance);
		}

		[Test]
		public function willReturnAnErrorIfInstanceNotFound() : void
		{
			const ARGS     : Array     = [["Column1","Column2"],["Value1", "Value2"]];
			const EXPECTED : SlimError = new SlimError("NO_INSTANCE instance1");
			const result2  : String    = String(executor.call("instance1","table1",[ARGS]));
			
			Assert.assertEquals(EXPECTED.toString(), result2);			
		}
		
		[Test]
		public function willReturnAnErrorIfMethodNotFound() : void
		{
			const result1  : Object    = executor.create("instance1", "ClassInNonDefaultPackage",[]);
			const ARGS     : Array     = [["Column1","Column2"],["Value1", "Value2"]];
			const EXPECTED : SlimError = new SlimError("NO_METHOD_IN_CLASS table1[1] fitnesse.slim.statement::ClassInNonDefaultPackage");
			const result2  : String    = String(executor.call("instance1","table1",[ARGS]));
			
			Assert.assertEquals(EXPECTED.toString(), result2);
		}
		
		[Test]
		public function willCallMethodWithArrayArgument() : void
		{
			const result   : Object = executor.create("instance1", "ClassInNonDefaultPackage",[]);
			const instance : Object = executor.instances["instance1"];
			const ARGS     : Array = [["Column1","Column2"],["Value1", "Value2"]];
			
			executor.call("instance1","table",[ARGS]);
			Assert.assertTrue((instance as ClassInNonDefaultPackage).wasCalled("table",[ARGS]));
		}
	}
}