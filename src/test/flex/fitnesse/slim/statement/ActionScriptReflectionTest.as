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
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	
	import org.flexunit.Assert;
	
	public class ActionScriptReflectionTest
	{	
		private var clazz       : Class;
		private var intClazz    : Class;
		private var instance    : Object;
		private var forCompiler : ClassForTestingReflection;
		
		[Before]
		public function setUp():void
		{
			clazz = getDefinitionByName("fitnesse.slim.statement.ClassForTestingReflection") as Class;
			intClazz = getDefinitionByName("int") as Class;
		}						
		
		[Test]
		public function willBeAbleToConvertToInt() : void
		{
			Assert.assertEquals(127, intClazz("127"));
		}
		[Test]
		public function canCreateInstance() : void
		{
			instance = createInstance();
			Assert.assertNotNull(instance);
		}

		[Test]
		public function canCallMethodOnInstance() : void
		{
			instance = createInstance();
			const method : Function = instance["method1"] as Function;
			const result : Object = method.call(instance, 778, "Argument");
			Assert.assertEquals(1798, int(result));
		}

		[Test]
		public function canInspectMethodArguments() : void
		{
			instance = createInstance();
			const descr : XML = describeType(clazz);
			for each (var staticMethod : XML in descr.method)
				if("create" == staticMethod.attribute("name"))
					for each(var parameter:XML in staticMethod.parameter)
					{
						trace(int(parameter.attribute("index")));
						trace(parameter.attribute("type"));
					}
			trace(descr);
		}
		
		private function createInstance() : Object
		{
			return new clazz.prototype.constructor(127,"Hello");

//			return (clazz["create"] as Function).call(clazz,127, "Hello");
		}
	}
}