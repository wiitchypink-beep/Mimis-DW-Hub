-- Use this while you are setting up GitHub.
-- Put hub.lua and wheel.png into Madium's workspace/MimisDWHub folder first.
assert(type(readfile) == "function", "Madium readfile() is unavailable.")
local source = readfile("MimisDWHub/hub.lua")
local chunk, err = loadstring(source)
assert(chunk, err)
chunk()
