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
	import fitnesse.slim.SlimVersion;
	import fitnesse.socketservice.AbstractSocketServer;
	
	import flash.events.Event;
	import flash.net.ServerSocket;
	import flash.net.Socket;
	import flash.utils.Dictionary;
	
	import mx.logging.ILogger;
	
	import util.sprintf;
	
	public class SlimSocketServer extends AbstractSocketServer
	{
		private var parent_      : ServerSocket;
		private var processor_   : IInstructionProcessor;
		private var length_      : uint;
         
        public static var variables:Dictionary = new Dictionary();
        
		public function SlimSocketServer(parent : ServerSocket, client : Socket, processor : IInstructionProcessor, logger : ILogger)
		{
			super(this, client, logger);
			parent_     = parent;
			processor_  = processor;
			length_     = 0;
			writeResponse(sprintf("Slim -- V%s\n",SlimVersion.VERSION));
		}
		
		public function get processor() : IInstructionProcessor
		{
			return processor_;
		}
		
		public function get parent() : ServerSocket
		{
			return parent_;
		}
		
		public function get length() : uint
		{
			return length_;
		}
		
		protected override function processRequest() : void
		{
			readLength();
			if(allBytesArrived())
				processInstructions(readInstructions());
		}

		private function readLength() : void
		{
			if(length_ == 0)
			{
				length_ = uint(socket.readUTFBytes(SlimFormat.LENGTH_WIDTH));
				socket.readUTFBytes(1);
				logger.debug(sprintf("Input Length: %d",length));
			}			
		}
		
		private function allBytesArrived() : Boolean
		{
			const available : uint = socket.bytesAvailable;
			if(length_ <= available) return true;
			logger.debug(sprintf("Insufficient input length: %d",available));
			return false;
		}
		
		private function readInstructions() : String
		{
			const instructions : String = socket.readUTFBytes(length_);
			logger.debug(sprintf("Instructions: %s",instructions));
			return instructions;
		}
		
		private function processInstructions(instructions : String) : void
		{
			if("bye" == instructions.toLowerCase())
				shutDown();
			else
				execute(instructions);			
			length_ = 0;
		}
		
		private function shutDown() : void
		{
			parent.dispatchEvent(new Event(Event.CLOSE));			
		}
		
		private function writeResponse(response : String) : void
		{
			socket.writeUTFBytes(response);
			socket.flush();
		}
		
		private function execute(instructions : String) : void
		{
            processor.addEventListener("done", doneHandler);
			processor.processInstructions(instructions);
		}
        
        private function doneHandler(event:Event):void {
            processor.removeEventListener("done", doneHandler);
            
            const results:String = processor.retrieveResults();
            logger.debug(sprintf("Results: %s",results));
            writeResponse(sprintf(SlimFormat.RESPONSE_FORMAT, results.length, results));
        }
	}
}