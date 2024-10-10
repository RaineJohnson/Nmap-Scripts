-- HEAD
local stdnse = require "stdnse"
local shortport = require "shortport"

description = [[
  A simple http scan to look for information on the port and print out specific info.
]]

author = "Raine Johnson"

license = "Same as nmap, see website at https://nmap.org/book/man-legal.html"

categories = {"safe"}

-- RULES
portrule = shortport.port_or_service(8000, "http-alt")

-- ACTION
action = function(host, port)
  return port.version.name .. " is " .. port.state .. " and running on port number " .. port.number .. "."
end