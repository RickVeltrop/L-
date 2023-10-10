TestMethods.FormatStringTest = function()
	local var = "test"
	local str = f"This is a {var}."

	Console.WriteLine(str)

	if str == "This is a test." then
		return true
	else
		return false
	end
end
