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
	
	public class CommandLineTest
	{
		private static const COMBO_DESCRIPTOR : String = "[-opt1 arg1 arg2] [-opt2 arg1] [-opt3] arg1 arg2";

		[Test]
		public function willHandleEmptyInput() : void
		{
			Assert.assertNotNull(createCommandLine("", ""));
		}

		[Test]
		public function willComplainAboutUnexpectedArgument() : void
		{
			try
			{
				createCommandLine("", "blah");
				Assert.fail("Should not get there");
			} catch(e: UnexpectedCommandLineArgumentError)
			{
				Assert.assertEquals(
					"Unexpected command line argument(s): "+"blah",
					e.message
				);
			}
		}
		
		[Test]
		public function willAcceptOneRequiredArgument() : void
		{
			const cmd : CommandLine = createCommandLine("arg1", "blah");
			
			Assert.assertEquals("blah", cmd.arg1);			
		}

		[Test]
		public function willComplainAboutMissingArgumentEnd() : void
		{
			try
			{
				createCommandLine("arg1", "");
				Assert.fail("Should not get there");
			} catch(e: MissingCommandLineArgumentError)
			{
				Assert.assertEquals(
					"Command line argument 'arg1' is missing",
					e.message
				);
			}
		}

		[Test(expects="util.MissingCommandLineArgumentError")]
		public function willComplainAboutMissingCommandLineArgumentUnexpectedOption() : void
		{
			createCommandLine("[-opt2] arg1", "-opt2");
		}
		
		[Test]
		public function willAcceptThreeRequiredArguments() : void
		{
			const cmd : CommandLine = createCommandLine("arg1 arg2 arg3", "tic tac toe");
			
			Assert.assertEquals("tic", cmd.arg1);
			Assert.assertEquals("tac", cmd.arg2);
			Assert.assertEquals("toe", cmd.arg3);
		}

		[Test]
		public function willAcceptOneSimpleOption() : void 
		{
			const cmd : CommandLine = createCommandLine("[-opt1]", "-opt1");
			Assert.assertTrue(cmd.isDefined("opt1"));
		}

		[Test]
		public function willNotComplainAboutMissingOption() : void 
		{
			const cmd : CommandLine = createCommandLine("[-opt1]", "");
			Assert.assertFalse(cmd.isDefined("opt1"));
		}

		[Test]
		public function willThrowExceptionForUndefinedOptionSupplied() : void 
		{
			try
			{
				createCommandLine("", "-opt1");
				Assert.fail("Should not get there");
			} catch (e : UndefinedCommandLineOptionSuppliedError)
			{
				Assert.assertEquals(
					"Undefined command line option '-opt1' supplied",
					e.message);
			}
		}

		[Test]
		public function WillAcceptOptionWithArgument() : void 
		{
			const cmd : CommandLine = createCommandLine("[-opt1 arg]", "-opt1 blah");
			
			Assert.assertTrue(cmd.isDefined("opt1"));
			Assert.assertEquals("blah", cmd.opt1.arg);
		}
		
		[Test]
		public function willAcceptCombinationOfOptionsAndArguments() : void
		{			
			createCommandLine(COMBO_DESCRIPTOR, "a b");
			createCommandLine(COMBO_DESCRIPTOR, "-opt3 a b");
			createCommandLine(COMBO_DESCRIPTOR, "-opt2 a b c");
			createCommandLine(COMBO_DESCRIPTOR, "-opt1 a b c d");
			createCommandLine(COMBO_DESCRIPTOR, "-opt1 a b -opt2 c d e");
			
			const cmd : CommandLine = createCommandLine(COMBO_DESCRIPTOR, "-opt1 a b -opt2 c -opt3 d e");
			Assert.assertTrue(cmd.isDefined("opt1"));
			Assert.assertEquals("a", cmd.opt1.arg1);
			Assert.assertEquals("b", cmd.opt1.arg2);
			Assert.assertTrue(cmd.isDefined("opt2"));
			Assert.assertEquals("c", cmd.opt2.arg1);
			Assert.assertTrue(cmd.isDefined("opt3"));
			Assert.assertEquals("d", cmd.arg1);
			Assert.assertEquals("e", cmd.arg2);
		}
		
		[Test(expects="util.MissingCommandLineArgumentError")]
		public function willComplainAboutMissingArgumentInCombo_Empty() : void
		{
			createCommandLine(COMBO_DESCRIPTOR, "");			
		}

		[Test(expects="util.MissingCommandLineArgumentError")]
		public function willComplainAboutMissingArgumentInCombo_SingleArgument() : void
		{
			createCommandLine(COMBO_DESCRIPTOR, "a");			
		}

		[Test(expects="util.MissingCommandLineArgumentError")]
		public function willComplainAboutMissingArgumentInCombo_Opt1() : void
		{
			createCommandLine(COMBO_DESCRIPTOR, "-opt1 a b c");			
		}

		[Test(expects="util.MissingCommandLineArgumentError")]
		public function willComplainAboutMissingArgumentInCombo_Opt2() : void
		{
			createCommandLine(COMBO_DESCRIPTOR, "-opt2 a b");			
		}

		[Test]
		public function willComplainAboutMissingOptionArgument() : void
		{
			try
			{
				createCommandLine(COMBO_DESCRIPTOR, "-opt2 -opt3 a b");
				Assert.fail("Should not get there");
			} catch (e: MissingCommandLineOptionArgumentError)
			{
				Assert.assertEquals("Command line option '-opt2' argument 'arg1' is missing", e.message);
			}
		}

		[Test(expects="util.MissingCommandLineOptionArgumentError")]
		public function willComplainAboutMissingOptionArgumentInCombo_Opt1Opt2Opt3() : void
		{
			createCommandLine(COMBO_DESCRIPTOR, "-opt1 a -opt2 b -opt3 c d");			
		}

		[Test(expects="util.UnexpectedCommandLineArgumentError")]
		public function willComplainAboutExtraCommandLineArgumentInCombo() : void
		{
			createCommandLine(COMBO_DESCRIPTOR, "-opt1 a b -opt2 c -opt3 d e f");			
		}
		
		private function createCommandLine(descriptor : String, input : String) : CommandLine 
		{
			return CommandLine.makeCommandLine(descriptor, StringTokenizer.getTokens(input));
		}		
	}
}