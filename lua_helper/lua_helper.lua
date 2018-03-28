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
local __this__ = os.getenv('WINXSHELL_MODULEPATH')
if  os.getenv('WINXSHELL_DEBUG') then
  __this__ = __this__ .. [[\..\..\dummy.lua]]
else
  __this__ = __this__ .. [[\dummy.lua]]
end

suilib.print(__this__)
if __this__:find('\\') then
  path, __this__ = __this__:match("(.+)\\([^\\]*)$")
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
package.cpath = str.format('.\\%s%s\\?.dll;' .. package.cpath, HELPERPATH, ARCH)

local f = io.popen('@dir /b '.. path .. '\\*.lua')
for line in f:lines() do
  if line ~= __this__ then
    suilib.print(line)
    require(line:sub(1, -5))
  end
end
f:close()

--[[
require('reg_helper')
require('os_helper')
]]
