This repository contains a list of nmap scripts written in Lua that can be used through the nmap scripting engine to execute various scans.

The finger-scan file uses the finger service to look for usernames on a linux machine. Note that the finger service isn't actually running through this script, and we're just assuming that in this scenario finger is running on port 79. 

The simple-http-scan file scans open HTTP ports on a simulated network and prints out specific information based on the scan. 

The scanning.nse file is a nmap script that's used to search for vulnerabilities, list open ports, look for any backup files, and record information in a notes.txt file for future reference. Note that most of the manually coded lua in this script can just be used in nmap through script libraries. See libraries such as http-backup-finder and afp-path-vuln for examples.
