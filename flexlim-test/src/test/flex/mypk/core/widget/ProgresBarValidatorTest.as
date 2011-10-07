package mypk.core.widget
{
	import asmock.framework.*;
	import asmock.framework.constraints.*;
	import asmock.integration.flexunit.*;
	import mypk.core.widget.ctrlr.ProgressBarCtrlr;
	
	public class ProgresBarValidatorTest
	{	
		private var validator:ProgressBarValidator;
		private var mocks    : MockRepository;
		private var controller : ProgressBarCtrlr;
		
		[Rule] public var includeMocks : IncludeMocksRule = new IncludeMocksRule([ProgressBarCtrlr
		]);
		
		[Before]
		public function setUp():void
		{
			mocks    = new MockRepository();
			controller = ProgressBarCtrlr(mocks.createStub(ProgressBarCtrlr));
			validator = new ProgressBarValidator("14:00", "1");
			ProgressBarValidator.controller = controller;
		}
		
		[Test]
		public function willHandleCorrectlyStartSTB():void
		{
			Expect.call(controller.start());
			mocks.replayAll();
			validator.startStb();
			mocks.verifyAll();
		}

		[Test]
		public function willHandleCorrectlyTune():void
		{
			Expect.call(controller.refresh());
			mocks.replayAll();
			validator.tune("2");
			mocks.verifyAll();
		}
	}
}