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
	
	public class OptionTokenizerTest
	{
		[Test]
		public function itWillHandleCorrectlyEmptyInput() : void
		{
			const EXPECTED : Array = [];
			const ACTUAL   : Array = OptionTokenizer.getTokens("");
			
			Assert.assertEquals(EXPECTED.toString(), ACTUAL.toString());
		}
		
		[Test]
		public function itWillHandleCorrectlyArgsOnlyInput() : void
		{
			const EXPECTED : Array = [new OptionToken("","arg1 arg2")];
			const ACTUAL   : Array = OptionTokenizer.getTokens("arg1 arg2");
			
			Assert.assertEquals(EXPECTED.toString(), ACTUAL.toString());
		}
		
		[Test]
		public function itWillHandleCorrectlySingleOptionInput() : void
		{
			const EXPECTED : Array = [new OptionToken("opt1","")];
			const ACTUAL   : Array = OptionTokenizer.getTokens("[-opt1]");
			
			Assert.assertEquals(EXPECTED.toString(), ACTUAL.toString());
		}
		
		[Test]
		public function itWillHandleCorrectlySingleOptionWithArgsInput() : void
		{
			const EXPECTED : Array = [new OptionToken("opt1","arg1 arg2")];
			const ACTUAL   : Array = OptionTokenizer.getTokens("[-opt1 arg1 arg2]");
			
			Assert.assertEquals(EXPECTED.toString(), ACTUAL.toString());
		}
		
		[Test]
		public function itWillHandleCorrectlyMultipleOptionsInput() : void
		{
			const EXPECTED : Array = [
				new OptionToken("opt1",""),
				new OptionToken("opt2","arg1 arg2")
			];
			const ACTUAL : Array = OptionTokenizer.getTokens("[-opt1] [-opt2 arg1 arg2]");
			
			Assert.assertEquals(EXPECTED.toString(), ACTUAL.toString());
		}

		[Test]
		public function itWillHandleCorrectlyComboInput() : void
		{
			const EXPECTED : Array = [
				new OptionToken("opt1",""),
				new OptionToken("opt2","arg1 arg2"),
				new OptionToken("","arg3 arg4")
			];
			const ACTUAL : Array = OptionTokenizer.getTokens("[-opt1] [-opt2 arg1 arg2] arg3 arg4");
			Assert.assertEquals(EXPECTED.toString(), ACTUAL.toString());
		}										
	}
}