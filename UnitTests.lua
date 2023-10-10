using 'system';
using 'system.Threading';

TestMethods = {}

for file in io.popen('dir "UnitTests"'):lines() do
	local matches = string.gmatch(file, "[^.]+")
	local name = 'UnitTests.' .. matches(1)

	using(name);
end

local function SuccessfulTest(TestName, TestFunction, Dur)
	Console.ForegroundColor = ConsoleColor.Green
	Console.WriteLine(f'Test `{TestName}` completed successfully. ({Dur}ms)')
	Console.ForegroundColor = Console.ResetColor()
end

local function FailedTest(TestName, TestFunction, Dur)
	Console.ForegroundColor = ConsoleColor.Red
	Console.WriteLine(f'Test `{TestName}` failed. ({Dur}ms)')
	Console.ForegroundColor = Console.ResetColor()
end

local function NilResult(TestName, TestFunction, Dur)
	Console.ForegroundColor = Console.ResetColor()
	Console.WriteLine(f'Test `{TestName}` had no return value, did you forget to implement it?. ({Dur}ms)')
end

local function round(exact, decimals)
	return string.format(f'%.{decimals}f', exact)
end

Console.ForegroundColor = ConsoleColor.Blue
Console.WriteLine('Starting tests: \n')
Console.ForegroundColor = Console.ResetColor()

for i,v in pairs(TestMethods) do
	local start = os.clock()
	local result = v()
	local stop = os.clock()
	local dur = round((stop-start)*1000, 3)

	if result == null then NilResult(i, v, dur)
	elseif result == false then FailedTest(i, v, dur)
	elseif result == true then SuccessfulTest(i, v, dur) end
end

Console.ForegroundColor = ConsoleColor.Blue
Console.WriteLine('\nFinished tests; continuing program. \n')
Console.ForegroundColor = Console.ResetColor()
