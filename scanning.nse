-- HEAD
local http = require "http"
local shortport = require "shortport"

description = [[
  This script checks for open HTTP ports, retrieves version and header information, and checks for common backup files.
]]

author = "Raine Johnson"
license = "Same as Nmap, see https://nmap.org/book/man-legal.html"
categories = {"discovery", "vuln"}

-- RULES
portrule = shortport.port_or_service(80, "http")

-- ACTION
action = function(host, port)
  local open_ports = {}
  local backup_files = {"/backup.zip", "/backup.tar.gz", "/backup.bak"}
  local found_files = {}

  -- Check if the port is open
  if port.state == "open" then
    table.insert(open_ports, port.number)

    -- Print open port information
    local message = "HTTP port " .. port.number .. " is open on " .. host.ip
    print(message)

    -- Send an HTTP GET request
    local response = http.get(host, port)

    -- Extract version and headers
    local version_info = "Server version: " .. (response.header["server"] or "unknown")
    local headers = "HTTP headers: " .. table.concat(response.rawheader, "\n")

    -- Print version and headers
    print(version_info)
    print(headers)

    -- Check for backup files
    for _, file in ipairs(backup_files) do
      local backup_response = http.get(host, port, file)
      if backup_response.status == 200 then
        table.insert(found_files, file)
      end
    end

    -- Print and record found backup files
    if #found_files > 0 then
      local backup_message = "Found backup files: " .. table.concat(found_files, ", ")
      print(backup_message)

      -- Write to notes.txt
      local file = io.open("notes.txt", "a")
      file:write(host.ip .. ": " .. message .. "\n" .. version_info .. "\n" .. headers .. "\n" .. backup_message .. "\n")
      file:close()
    else
      -- Write to notes.txt if no backup files are found
      local file = io.open("notes.txt", "a")
      file:write(host.ip .. ": " .. message .. "\n" .. version_info .. "\n" .. headers .. "\nNo backup files found.\n")
      file:close()
    end
  end

  return "Scan completed for " .. host.ip
end
