using "system";
using "system.Diagnostics";
using "system.Threading";
using "system.IO";

class("Program", {
	var = "variable";

	gay = function()
		Console.WriteLine("u are gayyyyy boyyyyyy");
	end;

	Main = function(args)
		local str = f"This is a {var}!";
		Console.WriteLine(str);
		Console.WriteLine(f"{gay()}");
	end;
})
