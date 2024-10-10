-- HEAD
local comm = require "comm"
local shortport = require "shortport"

description = [[
  This script checks for usernames on a Linux machine using the finger service.
]]

author = "Raine Johnson"
license = "Same as Nmap, see here https://nmap.org/book/man-legal.html"
categories = {"safe" , "discovery"}

-- RULES
portrule = shortport.port_or_service(79,"finger")

-- ACTION
action = function(host, port)
    local try = nmap.new_try()

    return try(comm.exchange(host, port, "\r\n", {lines=100, proto=port.protocol, timeout=5000}))
    end