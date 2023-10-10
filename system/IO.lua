File = {}

local open = io.open
io.open = nil

File.Open = function(source, mode)
	local returns = open(source, mode)

	local MetaTab = getmetatable(returns)
	MetaTab.Read = MetaTab.read
	MetaTab.read = nil
	MetaTab.Close = MetaTab.close
	MetaTab.close = nil
	MetaTab.ReadLines = MetaTab.lines
	MetaTab.lines = nil

	return returns
end

local lines = debug.getinfo(io.lines, 'f').func
io.lines = nil

File.ReadAllLines = function(_, source)
	local returns = {}

	local MetaTab = {}
	MetaTab.Count = function()
		return #returns
	end
	setmetatable(returns, { __index = MetaTab })

	for line in lines(source) do
		table.insert(returns, line)
	end

  return returns
end
