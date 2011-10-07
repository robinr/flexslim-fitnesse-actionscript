package fitnesse.slim.test
{
	public class EmployeesHiredBefore
	{
		public function EmployeesHiredBefore(date : String)
		{
		}
		
		public function query() : Array
		{
			return [
				[
					["employee number", "1429"],
					["first name"     , "Bob"],
					["last name"      , "Martin"],
					["hire date"      , "10-Oct-1974"]
				],
				[
					["employee number", "8832"],
					["first name"     , "James"],
					["last name"      , "Grenning"],
					["hire date"      , "15-Dec-1979"]
				]
			];
		}
	}
}