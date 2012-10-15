package = "redis-lua-unit"
version = "1.0.0"
source = {
  url = "https://github.com/Redsmin/redis-lua-unit/tarball/master",
  dir = "redis-lua-unit"
}
description = {
  summary = "Give some unit-test love to your Redis LUA scripts",
  detailed = [[

  ]],
  homepage = "https://github.com/Redsmin/redis-lua-unit",
  license = "MIT <http://opensource.org/licenses/MIT>"
}
dependencies = {
  "lua >= 5.1",
  "busted => 1.3-1",
  "luafilesystem => 1.6.2-1"
}
build = {
  type = "builtin",
  modules = {
    -- ["busted.core"] = "src/core.lua",
    -- ["busted.output.utf_terminal"] = "src/output/utf_terminal.lua",
    -- ["busted.output.plain_terminal"] = "src/output/plain_terminal.lua",
    -- ["busted.output.TAP"] = "src/output/TAP.lua",
    -- ["busted.output.json"] = "src/output/json.lua",
    -- ["busted.init"] = "src/init.lua",
    -- ["busted.languages.en"] = "src/languages/en.lua",
    -- ["busted.languages.ar"] = "src/languages/ar.lua",
    -- ["busted.languages.fr"] = "src/languages/fr.lua",
    -- ["busted.languages.nl"] = "src/languages/nl.lua",
    -- ["busted.languages.ru"] = "src/languages/ru.lua",
    -- ["busted.languages.ua"] = "src/languages/ua.lua",
  },
  install = {
    -- bin = {
    --   ["busted"] = "bin/busted",
    --   ["busted.bat"] = "bin/busted.bat",
    --   ["busted_bootstrap"] = "bin/busted_bootstrap"
    -- }
  }
}