Debug = {}

Debug.IndentLevel = 0
Debug.IndentSize = 4

Debug.Indent = function()
	Debug.IndentLevel = Debug.IndentLevel + 1
end

Debug.Unindent = function()
	Debug.IndentLevel = Debug.IndentLevel - 1
end

local function GetIndent()
	local indent = ''
	for i=1, Debug.IndentSize - 0, 1 do
		indent = indent .. ' '
	end

	local returns = ''
	for i=1, Debug.IndentLevel - 0, 1 do
		returns = returns .. indent
	end
	return returns
end

local ENV = os.getenv('environment')

Debug.Write = function(...)
	if ENV ~= 'development' then return end

	local indent = GetIndent()
	if indent:len() == 0 then
		Console.Write(...)
	elseif indent:len() > 0 then
		Console.Write(GetIndent(), ...)
	end
end

Debug.WriteIf = function(Condition, ...)
	if ENV ~= 'development' and Condition then return end

	local indent = GetIndent()
	if indent:len() == 0 then
		Console.Write(...)
	elseif indent:len() > 0 then
		Console.Write(GetIndent(), ...)
	end
end

Debug.WriteLine = function(...)
	if ENV ~= 'development' then return end

	local indent = GetIndent()
	if indent:len() == 0 then
		Console.WriteLine(...)
	elseif indent:len() > 0 then
		Console.WriteLine(GetIndent(), ...)
	end
end

Debug.WriteLineIf = function(Condition, ...)
	if ENV ~= 'development' or not Condition then return end

	local indent = GetIndent()
	if indent:len() == 0 then
		Console.WriteLine(...)
	elseif indent:len() > 0 then
		Console.WriteLine(GetIndent(), ...)
	end
end
