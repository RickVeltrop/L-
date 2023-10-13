local ENV = os.getenv('environment')

null = nil

local r = require
using = function(...) r(...) end
require = null

using 'system';

local ts = tostring
tostring = function(value)
	if not value then return "null" end

	return ts(value)
end

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

		if nullcounter > 10 then
			return null,null
		end
	end
end

class = function(name)
	return function(members)
		classes[name] = members
		_G[name] = members

		for i,v in pairs(members) do
			_G[i] = v
		end
	end
end

local function ResolveInterpolation(VariableName)
	VariableName = VariableName:gsub('{', '')
	VariableName = VariableName:gsub('}', '')

	if string.find(VariableName, '()', 0, -1) then
		VariableName = VariableName:gsub('%(%)', '')
		assert(_G[VariableName],
			'Unable to find function '.. VariableName..'().'
		)

		return tostring(_G[VariableName]())
	else
		local key,val = debug.findlocal(VariableName)

		if not key and not val then
			key,val = findmember(VariableName)
		end

		val = val or "null"

		return val
	end
end

f = function(InterpolationString)
	for Match in string.gmatch(InterpolationString, '{.-}') do
		local Interpolation = ResolveInterpolation(Match)
		InterpolationString = InterpolationString:gsub(Match, Interpolation)
	end

	return InterpolationString
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
