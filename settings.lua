
local composer = require( "composer" )
local widget = require("widget")
local scene = composer.newScene()
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local buttonPress -- Sound when button is pressed
local buttonRelease -- Sound when button is released
local buttonSound -- Above 2 added together, for scene changing buttons

composer.setVariable("soundOn", true)

local function goToMenu()
	composer.gotoScene("menu",{time=500, effect="crossFade"});
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	-- Set up display groups
	backGroup = display.newGroup() -- display group for background image
	sceneGroup:insert(backGroup)

	mainGroup = display.newGroup() -- display group for ship, asteroids, lasers etc
	sceneGroup:insert(mainGroup)

	uiGroup = display.newGroup() -- display group for UI objects like score
	sceneGroup:insert(uiGroup)

	-- Load in background in correct pos/display group
	local background = display.newImageRect(backGroup, "sprites/mainBg.png", 320, 480)
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	-- Adds big back button 
	backButton = widget.newButton(
		{
			onPress = goToMenu,
			width = 144 / 2,
			height = 96 / 2,
			defaultFile = "sprites/back.png",
			overFile = "sprites/pressedBack.png",
		}
	)
	-- Top right corner of devices
	uiGroup:insert(backButton)
	backButton.x = display.screenOriginX + 50
	backButton.y = display.screenOriginY + 50

	-- Add sound off switch
	soundOffSwitch = widget.newButton(
		{
			onPress = function() composer.setVariable("soundOn", true) end,
			onRelease = function() audio.play(buttonRelease); soundOffSwitch.isVisible = false; soundOnSwitch.isVisible = true end,
			width = 170/2,
			height = 170/2,
			defaultFile = "sprites/soundOff.png",
			overFile = "sprites/soundOffPressed.png",
		}
	)
	uiGroup:insert(soundOffSwitch)
	soundOffSwitch.x = display.contentCenterX
	soundOffSwitch.y = display.contentCenterY - 100

	-- Add sound on switch
	soundOnSwitch = widget.newButton(
		{
			onPress = function() audio.play(buttonPress) end,
			onRelease = function() composer.setVariable("soundOn", false); soundOnSwitch.isVisible = false; soundOffSwitch.isVisible = true end,
			width = 170/2,
			height = 170/2,
			defaultFile = "sprites/soundOn.png",
			overFile = "sprites/soundOnPressed.png",
		}
	)
	uiGroup:insert(soundOnSwitch)
	soundOnSwitch.x = display.contentCenterX
	soundOnSwitch.y = display.contentCenterY - 100

	-- Add music off switch
	musicOffSwitch = widget.newButton(
		{
			onPress = function() if composer.getVariable("soundOn") == true then audio.play(buttonPress) end end,
			onRelease = function() if composer.getVariable("soundOn") == true then audio.play(buttonRelease) end; musicOffSwitch.isVisible = false; musicOnSwitch.isVisible = true end,
			width = 170/2,
			height = 170/2,
			defaultFile = "sprites/musicOff.png",
			overFile = "sprites/musicOffPressed.png",
		}
	)
	uiGroup:insert(musicOffSwitch)
	musicOffSwitch.x = display.contentCenterX
	musicOffSwitch.y = display.contentCenterY + 100

	-- Add music on switch
	musicOnSwitch = widget.newButton(
		{
			onPress = function() if composer.getVariable("soundOn") == true then audio.play(buttonPress) end end,
			onRelease = function() if composer.getVariable("soundOn") == true then audio.play(buttonRelease) end; musicOnSwitch.isVisible = false; musicOffSwitch.isVisible = true end,
			width = 170/2,
			height = 170/2,
			defaultFile = "sprites/musicOn.png",
			overFile = "sprites/musicOnPressed.png"
		}
	)
	uiGroup:insert(musicOnSwitch)
	musicOnSwitch.x = display.contentCenterX
	musicOnSwitch.y = display.contentCenterY + 100

	-- Load buttonPress and set volume to 0.5
	buttonPress = audio.loadSound("audio/buttonPress.wav")
	audio.setVolume(0.5, buttonPress)

	-- Load buttonRelease and set volume to 0.5
	buttonRelease = audio.loadSound("audio/buttonRelease.wav")
	audio.setVolume(0.5, buttonRelease)

	-- Load buttonSound and set volume to 0.5
	buttonSound = audio.loadSound("audio/buttonSound.wav")
	audio.setVolume(0.5, buttonSound)
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		if composer.getVariable("soundOn") == true then audio.play(buttonSound) end
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
