local awful = require("awful")
local gears = require("gears")

local M = {}

local function pid_file()
    local host = io.lines("/proc/sys/kernel/hostname")()
    return gears.filesystem.get_cache_dir() .. "awesome." .. host .. ".pid"
end

local function read_pid(path)
    local f = io.open(path)
    if not f then return nil end
    local pid = f:read("*n")
    f:close()
    return pid
end

local function write_pid(path, pid)
    local f = io.open(path, "w+")
    f:write(pid)
    f:close()
end

local function current_pid()
    local f = io.popen("pgrep -u " .. os.getenv("USER") .. " -o awesome")
    local pid = f:read("*n")
    f:close()
    return pid
end

local path = pid_file()
local old_pid = read_pid(path)
local cur_pid = current_pid()
write_pid(path, cur_pid)

function M.run(cmd)
    if old_pid ~= cur_pid then
        awful.spawn.with_shell(cmd)
    end
end

return M
