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
package util
{
	import org.flexunit.Assert;
	
	public class CommandLineOptionTest
	{
		private var schema : Array;
		private var option : CommandLineOption;

		public function CommandLineOptionTest()
		{
			
		}
		
		[Before]
		public function setUp() : void
		{
			schema = new Array();
			schema["opt"] = ["arg1", "arg2"];
			schema[""] = ["arg1", "arg2"];
		}
		
		[Test]
		public function willAcceptCorrectListOfValues():void
		{
			option = CommandLineOption.makeOption(schema,"opt",["a", "b"]);
			Assert.assertEquals("a", option.arg1);
			Assert.assertEquals("b", option.arg2);
		}
		
		[Test]
		public function willComplainAboutMissingOptionArgumentEnd() : void
		{
			try
			{
				option = CommandLineOption.makeOption(schema,"opt",[]);
				Assert.fail("Should not get there");
			} catch (e: MissingCommandLineOptionArgumentError)
			{
				Assert.assertEquals("Command line option '-opt' argument 'arg1' is missing", e.message);
			}
		}		
		
		[Test]
		public function willComplainAboutMissingOptionArgumentAnotherOption() : void
		{
			try
			{
				option = CommandLineOption.makeOption(schema,"opt",["-opt2"]);
				Assert.fail("Should not get there");
			} catch (e: MissingCommandLineOptionArgumentError)
			{
				Assert.assertEquals("Command line option '-opt' argument 'arg1' is missing", e.message);
			}
		}		
	}
}