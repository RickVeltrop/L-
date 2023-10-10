Thread = {
	-- Halts current thread for N milliseconds
	Sleep = function(_n)
		local n = _n / 1000
    	local timer = io.popen("sleep " .. n)
    	timer:close()
	end
}
