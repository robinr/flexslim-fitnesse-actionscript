package fitnesse.slim.test
{
	public class LoginDialogDriver
	{
		private var userName_ : String;
		private var password_ : String;
		private var message_  : String;
		private var attempts_ : int;
		
		public function LoginDialogDriver(userName : String, password : String)
		{
			userName_ = userName;
			password_ = password;
			message_  = "";
			attempts_ = 0;
		}
		
		public function loginWithUsernameAndPassword(userName : String, password : String) : Boolean
		{
			const isLoggedIn : Boolean = (userName_==userName) && (password_ == password);

			attempts_++;
			if(isLoggedIn)
				message_ = userName + " logged in.";
			else
				message_ = userName + " not logged in."
			return isLoggedIn;
		}
		
		public function loginMessage() : String
		{
			return message_;
		}
		
		public function numberOfLoginAttempts() : int
		{
			return attempts_;
		}
	}
}