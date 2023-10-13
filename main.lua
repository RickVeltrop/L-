using "system";
using "system.Diagnostics";
using "system.Threading";
using "system.IO";

class "Program" {
	Var = "variable";

	Gay = function(str)
		return f"This is a {Var}!"
	end;

	Main = function(args)
		Console.WriteLine(Gay());
	end;
}
