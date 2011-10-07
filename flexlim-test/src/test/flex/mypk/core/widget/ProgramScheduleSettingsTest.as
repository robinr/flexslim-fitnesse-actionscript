package mypk.core.widget
{
	import asmock.framework.*;
	import asmock.framework.constraints.*;
	import asmock.integration.flexunit.*;
	
	import org.flexunit.Assert;
	
	import mypk.core.dataaccess.ProgramData;
	
	public class ProgramScheduleSettingsTest
	{	
		private var settings : ProgramScheduleSettings;
		private var mocks    : MockRepository;

		[Rule] public var includeMocks : IncludeMocksRule = new IncludeMocksRule([
		]);
		
		[Before]
		public function setUp():void
		{
			mocks    = new MockRepository();
			settings = new ProgramScheduleSettings();
		}
		
		[Test]
		public function willAddnewProgramDataOnExecute() : void
		{
			var date : Date = new Date();
			date.hours   = 13;
			date.minutes = 30;
			const EXPECTED : Array = [new ProgramData(1,date,90,"ABC")];
			
			settings.setChannel("1");
			settings.setStartTime("13:30");
			settings.setDuration("90");
			settings.setTitle("ABC");
			settings.execute();
			Assert.assertEquals(EXPECTED.toString(), ProgramScheduleSettings.data.toString());
		}
	}
}