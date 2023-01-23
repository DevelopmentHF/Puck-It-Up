-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local composer = require("composer")
local widget = require("widget")

-- Hides the status bar
display.setStatusBar(display.HiddenStatusBar)

-- Seed the random number generation for potential RNG uses
math.randomseed(os.time())

-- Go to the menu screen
composer.gotoScene("menu")

-- Enable multitouch so two players can play at once
system.activate("multitouch")