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

package fitnesse.slim.statement
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import util.sprintf;
	
	public class StatementExecutor
	{
		private var path_      : Array;
		private var instances_ : Array;
		
		public function StatementExecutor()
		{
			path_      = [""];
			instances_ = new Array();
		}
		
		public function get path() : Array
		{
			return path_;
		}
		
		public function get instances() : Array
		{
			return instances_;
		}
		
		public function addPath(pathToAdd : String) : Object
		{
			path_.push(pathToAdd+".");
			return "OK";
		}
		
		public function create(instance : String, className : String, args : Array) : Object
		{
			for each(var scope : String in path)
				try
				{
					const clazz : Class = getDefinitionByName(scope + className) as Class;
					instances[instance] = makeInstance(className, clazz, args);
					return "OK";
				} catch (e : ReferenceError) {
				} catch (e : ArgumentError) {
					return new SlimError(sprintf("COULD_NOT_INVOKE_CONSTRUCTOR %s[%d]",className,args.length));					
				} catch (e : SlimError) {
					return e;
				}
				return new SlimError(sprintf("NO_CLASS %s",className));
		}

		private static function makeInstance(className : String, clazz : Class, args : Array) : Object
		{
			switch(args.length)
			{
				case 0:
					return new clazz();
				case 1:
					return new clazz.prototype.constructor(args[0]);
				case 2:
					return new clazz.prototype.constructor(args[0],args[1]);
			}
			throw new SlimError(
				sprintf(
					"UNSUPPORTED_NUMBER_OF_ARGUMENTS_IN_CONSTRUCTOR %s[%d]",
					className,
					args.length
				)
			);
		}
		
		public function call(instanceName : String, methodName : String, args : Array) : Object
		{
			const instance : Object   = instances[instanceName];
			
			try
			{
				const method : Function = instance[methodName];
				const result : Object   = method.apply(instance, args);
			} catch (e : TypeError) {
				return new SlimError(
					sprintf(
						"NO_INSTANCE %s",
						instanceName
					)
				);
			} catch (e : ReferenceError) {
				return new SlimError(
					sprintf(
						"NO_METHOD_IN_CLASS %s[%d] %s",
						methodName,
						args.length,
						getQualifiedClassName(instance)
					)
				);
			}
			return result;
		}
		
		public function callAndAssign(target : String, instance : String, methodName : String, args : Array) : Object
		{
			return "OK";
		}		
	}
}