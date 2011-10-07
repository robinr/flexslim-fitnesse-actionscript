package fitnesse.slim.test
{
	public class ShouldIBuyMilk
	{
		private var dollars_    : int;
		private var pints_      : int;
		private var creditCard_ : Boolean;
		
		public function ShouldIBuyMilk()
		{
		}
		
		public function setCashInWallet(dollars : String) : void
		{
			dollars_ = int(dollars);
		}
		
		public function setPintsOfMilkRemaining(pints : String) : void
		{
			pints_ = int(pints);
		}
		
		public function setCreditCard(valid : String) : void
		{
			creditCard_ = ("yes" == valid);
		}
		
		public function goToStore() : String
		{
			return (pints_ == 0 && (dollars_ > 2 || creditCard_)) ? "yes" : "no";
		}		
	}
}