-- short alias
str = str or string
p = p or print

-- set dll load path
if os.getenv('PROCESSOR_ARCHITECTURE') == 'AMD64' then
  ARCH = 'x64'
else
  ARCH = 'x86'
end

print("lua_helper_loading ...")

-- load all lua files in this folder except this file
local path = '.'
local root = os.getenv('WINXSHELL_MODULEPATH')
if root then
  if os.getenv('WINXSHELL_DEBUG') then
    root = root .. [[\..\..]]
  end
  __this__ = root .. [[\dummy.lua]]
else
  __this__ = arg[0]
  if arg[0]:find('\\') then
    path, __this__ = arg[0]:match("(.+)\\([^\\]*)$")
  end
end

HELPERPATH = ''
if __this__ ~= 'lua_helper.lua' then
  path = path .. '\\lua_helper'
  __this__ = 'lua_helper.lua'
  package.path = '.\\lua_helper\\?.lua;' .. package.path
  HELPERPATH = 'lua_helper\\'
end

-- set dll load path
if os.getenv('PROCESSOR_ARCHITECTURE') == 'AMD64' then
  ARCH = 'x64'
else
  ARCH = 'x86'
end
local dllpath = str.format('.\\%s%s\\?.dll;', HELPERPATH, ARCH)
if root then
  dllpath = str.format(root .. '\\%s%s\\?.dll;', HELPERPATH, ARCH)
end
package.cpath = dllpath .. package.cpath

local f = io.popen('@dir /b '.. path .. '\\*.lua')
for line in f:lines() do
  if line ~= __this__ then
    if suilib then
      suilib.print(line)
    else
      print(line)
    end
    require(line:sub(1, -5))
  end
end
f:close()

--[[
require('reg_helper')
--require('os_helper')
--]]