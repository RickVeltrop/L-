local ENV = os.getenv('environment')

null = nil

using = require
require = null

using 'system';

local classes = {}

local index = {}
local mt = {
  __index = function (t,k)
  	return t[index][k]
  end,

  __newindex = function (t, k, v)
    t[index][k] = v
  end
}
local function track(t)
	local proxy = {}
	proxy[index] = t
	setmetatable(proxy, mt)
	return proxy
end
_G = track(_G)

table.find = function(haystack, needle)
	for i,v in pairs(haystack) do
		if i == needle then
			return i,v
		end
	end
end

local function findmember(name)
	for i,v in pairs(classes) do
		if type(v) == "table" then
			key,val = table.find(v, name)
		end
	end

	return key,val
end

local function searchlevel(level, name)
	for i=1, 256, 1 do
		local key,val
		local suc,err = pcall(function()
			key,val = debug.getlocal(level, i)
		end)

		if key == name then
			return key,val
		elseif not key and not val then
			return null,null
		end

		i = i + 1
	end
end

debug.findlocal = function(name)
	local nullcounter = 0
	for i=1, 256, 1 do
		local key,val = searchlevel(i, name)

		if key == name then
			return key,val
		elseif not key then
			nullcounter = nullcounter + 1
		end

		if nullcounter > 5 then
			return null,null
		end
	end
end

class = function(name)
	classes[name] = _G[name]

	return function(members)
		_G[name] = members
	end
end

f = function(str)
	local returns = str

	for match in string.gmatch(str, '{.-}') do
		match = match:gsub('{', '')
		match = match:gsub('}', '')

		local key,val = debug.findlocal(match)
		if not key and not val then
			key,val = findmember(match)
		end

		if key and val then
			returns = returns:gsub("{"..match.."}", val)
		end
	end

	return returns
end

local args = { 'main.lua', ENV }

using 'main'

if os.getenv('environment') == 'development' then
	using 'UnitTests'
end

if not Program or type(Program) ~= 'table' then
	error('Could not find `Program` class.')
end
if not Program.Main or type(Program.Main) ~= 'function' then
	error('Could not find `Program.Main` Method.')
end

Program.Main(args)
