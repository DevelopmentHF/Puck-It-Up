
local composer = require( "composer" )
local widget = require("widget")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local buttonSound -- Sound when button is pressed

composer.setVariable("soundOn", true)

-- Switch scene functions
local function goToSelection()
	composer.gotoScene("selection",{time=500, effect="crossFade"});
end

local function goToSettings()
	composer.gotoScene("settings",{time=500, effect="crossFade"});
end

local function visitWebsite()
	system.openURL("https://github.com/DevelopmentHF/Puck-It-Up");
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

	-- Adds big play button 
	playButton = widget.newButton(
		{
			onPress = goToSelection,
			width = 144,
			height = 96,
			defaultFile = "sprites/play.png",
			overFile = "sprites/pressedPlay.png",
		}
	)
	uiGroup:insert(playButton)
	playButton.x = display.contentCenterX
	playButton.y = display.actualContentHeight - 150

	-- Adds big settings button 
	settingsButton = widget.newButton(
		{
			onPress = goToSettings,
			width = 89 * 1.25,
			height = 44 * 1.25,
			defaultFile = "sprites/settings.png",
			overFile = "sprites/pressedSettings.png",
		}
	)
	uiGroup:insert(settingsButton)
	settingsButton.x = display.contentCenterX
	settingsButton.y = display.actualContentHeight - 55

	-- Load in puck for logo in correct pos/display group
	local puck = display.newImageRect(mainGroup, "sprites/logoPuck.png", 573/3, 231/3)
	puck.x = display.contentCenterX 
	puck.y = display.contentCenterY - 150

	-- Adds github navigation button 
	gitButton = widget.newButton(
		{
			onPress = visitWebsite,
			width = 32,
			height = 32,
			defaultFile = "sprites/github.png",
			overFile = "sprites/github.png",
		}
	)
	uiGroup:insert(gitButton)
	gitButton.x = display.screenOriginX + display.actualContentWidth - 25
	gitButton.y = display.screenOriginY + display.actualContentHeight - 25

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
