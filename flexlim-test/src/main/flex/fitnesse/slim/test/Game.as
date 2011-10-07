package fitnesse.slim.test
{
	public class Game
	{
		private var rolls : Array;
		
		public function Game()
		{
			rolls = new Array();
		}
		
		public function roll(pins : int) : void
		{
			rolls.push(pins);	
		}
		
		public function score(frame : int) : int
		{
			var score     : int = 0;
			var firstBall : int = 0;
			
			for(var i : int = 0; i < frame; i++)
			{
				if (isStrike(firstBall))
				{
					score     += 10 + nextTwoBallsForStrike(firstBall);
					firstBall += 1;
				} else if(isSpare(firstBall))
				{
					score     += 10 + nextBallForSpare(firstBall);
					firstBall += 2;
				} else {
					score += twoBallsInFrame(firstBall);
					firstBall += 2;	
				}
			}
			return score;
		}
		
		private function twoBallsInFrame(firstBall : int) : int 
		{
			return rolls[firstBall] + rolls[firstBall+1];
		}
		
		private function nextBallForSpare(firstBall : int) : int
		{
			return rolls[firstBall+2];
		}
		
		private function nextTwoBallsForStrike(firstBall : int) : int 
		{
			return rolls[firstBall+1] + rolls[firstBall+2];
		}
		
		private function isSpare(firstBall : int) : Boolean
		{
			return rolls[firstBall] + rolls[firstBall+1] == 10;
		}
		
		private function isStrike(firstBall : int) : Boolean 
		{
			return rolls[firstBall] == 10;
		}		
	}
}