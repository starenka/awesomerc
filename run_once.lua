require("awful.util")
require("lfs")

local M = {}

-- {{{ Run programm once
function M.processwalker()
  local function yieldprocess()
    for dir in lfs.dir("/proc") do
      -- All directories in /proc containing a number, represent a process
      if tonumber(dir) ~= nil then
        local f, err = io.open("/proc/" .. dir .. "/cmdline")
        if f then
          local cmdline = f:read("*all")
          f:close()
          if cmdline ~= "" then
            coroutine.yield(cmdline)
          end
        end
      end
    end
  end

  return coroutine.wrap(yieldprocess)
end

function M.run_once(process, cmd)
  assert(type(process) == "string")
  local regex_killer = {
    ["+"] = "%+",
    ["-"] = "%-",
    ["*"] = "%*",
    ["?"] = "%?"
  }

  for p in M.processwalker() do
    if p:find(process:gsub("[-+?*]", regex_killer)) then
      return
    end
  end
  return awful.util.spawn(cmd or process)
end

-- }}}

return M
