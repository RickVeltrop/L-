Console = {
  	['WriteLine'] = function(...) return print(...) end,
  	['Write'] = function(...) return write(...) end,
  	['ReadLine'] = function(...) return read(...) end,

	['BackgroundColor'] = '',
	['ForegroundColor'] = ''
}

local print = print
print = null
local write = io.write
io.write = null
local read = io.read
io.read = null

Console.Clear = function()
	if pcall(os.execute('cls')) then
		os.execute('cls')
	elseif pcall(os.execute('clear')) then
		os.execute('clear')
	else
		for i=0, 25, 1 do
			Console.WriteLine('\n')
		end
	end
end

Console.ResetColor = function()
	os.execute('tput sgr0')
end

ConsoleColor = {}
ConsoleColor.Black = 16
ConsoleColor.White = 7
ConsoleColor.Red = 1
ConsoleColor.Green = 22
ConsoleColor.Yellow = 11
ConsoleColor.Blue = 19
ConsoleColor.Pink = 5

local function SetConsoleBackgroundColor(Color)
	os.execute(f'tput setab {Color}')
end

local function SetConsoleForegroundColor(Color)
	os.execute(f'tput setaf {Color}')
end

local index = {}
local mt = {
	__index = function(t,k)
  	return t[index][k]
	end;

	__newindex = function(t, k, v)
  	if k == 'BackgroundColor' then
			SetConsoleBackgroundColor(v)
		elseif k == 'ForegroundColor' then
			SetConsoleForegroundColor(v)
		end

  	t[index][k] = v
	end;
}

local function track(t)
	local proxy = {}
  proxy[index] = t
  setmetatable(proxy, mt)

  return proxy
end
Console = track(Console)

local function NextDouble()
	return Random.Next(0, 100000000)/100000000
end

Random = {
	['Next'] = function(m, n) return math.random(m, n) end,
	['NextDouble'] = NextDouble
}

Math = {}

math.random = null

math.rad = null
math.deg = null

Math.Sin = function(x) return math.sin(x) end
math.sin = null

Math.Cos = function(x) return math.cos(x) end
math.cos = null

Math.Tan = function(x) return math.tan(x) end
math.tan = null

Math.PI = function() return math.pi() end
math.pi = null

math.randomseed = null
