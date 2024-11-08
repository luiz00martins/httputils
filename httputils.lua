--- HttpUtils Library for ComputerCraft
--- @author PentagonLP, SkyTheCodeMaster
--- @version 1.0

local fileutils = require("/lib/fileutils")

--- Gets result of HTTP URL
--- @param url string: The desired URL
--- @return table|false: The result of the request; If the URL is not reachable, an error is printed in the terminal and boolean false is returned
local function gethttpresult(url)
	if not http.checkURL(url) then
		print("ERROR: Url '" .. url .. "' is blocked in config. Unable to fetch data.")
		return false
	end
	local result,err = http.get(url)
	if not result then
		print("ERROR: Unable to reach '" .. url .. "' because '" .. err .. "'")
		return false
	end
	return result
end

--- Gets table from HTTP URL
--- @param url string: The desired URL
--- @return table|false: The content of the site parsed into a table; If the URL is not reachable, an error is printed in the terminal and boolean false is returned
local function gethttpdata(url)
	local result = gethttpresult(url)
	if not result then
		return false
	end
	local data = result.readAll()
	data = string.gsub(data,"\n","")
	if textutils.unserialize(data) == nil then
		print("ERROR: Unable to parse data fetched from '" .. url .. "'")
		return false
	end
	return textutils.unserialize(data)
end

--- Download file HTTP URL
--- @param filepath string: Filepath where to create file (if file already exists, it gets overwritten)
--- @param url string: The desired URL
--- @return boolean: If the URL is not reachable, an error is printed in the terminal and boolean false is returned; If everything goes well, true is returned
local function downloadfile(filepath,url)
	local result = gethttpresult(url)
	if not result then
		return false
	end
	fileutils.storeFile(filepath,result.readAll())
	return true
end

return {
	gethttpresult = gethttpresult,
	gethttpdata = gethttpdata,
	downloadfile = downloadfile,
}