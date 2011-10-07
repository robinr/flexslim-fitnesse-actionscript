package fitnesse.slim.test
{
	import util.sprintf;
	
	public class Bowling
	{
		public function Bowling()
		{
		}
		
		private static const ROLLS  : int = 21;
		private static const FRAMES : int = 10;
		
		public function doTable(table : Array) : Array
		{
			const game        : Game   = new Game();
			const rollResults : Array  = createResultsTable();
			const scoreResults: Array  = createResultsTable();
			
			rollBalls(table[0], game);
			evaluateScores(game, table[1], scoreResults);
			return [rollResults, scoreResults];
		}
		
		private function createResultsTable() : Array
		{
			const results : Array = new Array();
			
			for(var i : int = 0; i < ROLLS; i++)
				results.push("");
				
			return results;
		}
		
		private function evaluateScores(game : Game, scoreRow : Array, scoreResults : Array) : void
		{
			for(var frame : int = 0; frame < FRAMES; frame++)
			{
				const actualScore   : int = game.score(frame+1);
				const expectedScore : int = int(scoreRow[frameCoordinate(frame)]);
				
				if(expectedScore == actualScore)
					scoreResults[frameCoordinate(frame)] = "pass";
				else
					scoreResults[frameCoordinate(frame)] = sprintf("Was:%d, expected:%d.",actualScore,expectedScore);
			}
		}
		
		private function frameCoordinate(frame : int) : int
		{
			return (frame < 9) ? (frame*2+1) : (frame*2+2);
		}
		
		private function rollBalls(rollRow : Array, game : Game) : void
		{
			for(var frame : int = 0; frame < FRAMES; frame++)
			{
				const firstRoll : String = rollRow[frame*2];
				const secondRoll: String = rollRow[frame*2+1];
				if("X" == firstRoll.toUpperCase())
					game.roll(10);
				else 
				{
					var firstRollInt : int = 0;
					if("-" == firstRoll)
						game.roll(0);
					else
					{
						firstRollInt = int(firstRoll);
						game.roll(firstRollInt);
					}
					if("/" == secondRoll)
						game.roll(10 - firstRollInt);
					else if("-" == secondRoll)
						game.roll(0);
					else
						game.roll(int(secondRoll));
				} 
			}
		}
	}
}