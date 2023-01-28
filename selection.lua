
local composer = require( "composer" )
local widget = require("widget")
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local potentialPaddlesTop = {}	-- array of paddle choices for top player
local potentialPaddlesBot = {}	-- array of paddle choices for bottom player
local numPaddles	-- number of paddle choices for each player
local topChoice = 1
local bottomChoice = 1
local gameLoopTimer

local buttonPress -- Sound when button is pressed
local buttonRelease -- Sound when button is released
local buttonSound -- Above 2 added together, for scene changing buttons

-- Switches scenes to the menu scene
local function goToMenu()
	composer.gotoScene("menu",{time=500, effect="crossFade"});
end

-- Switches scenes to go into the main game
local function goToGame()
	composer.gotoScene("game",{time=500, effect="crossFade"});
end

-- Retuns a shallow copy of an original table
function shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else 
        copy = orig
    end
    return copy
end

local function sceneLoop()
	-- Check which puck to display
	for i=1, numPaddles do
		if i == topChoice then
			potentialPaddlesTop[i].isVisible = true
		else
			potentialPaddlesTop[i].isVisible = false
		end

		if i == bottomChoice then
			potentialPaddlesBot[i].isVisible = true
		else
			potentialPaddlesBot[i].isVisible = false
		end

	end
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

	-- Load in potential paddles to play with 
	local redPaddleTop = display.newImageRect(mainGroup, "sprites/redPaddle.png", 60, 60)
	local bluePaddleTop = display.newImageRect(mainGroup, "sprites/bluePaddle.png", 60, 60)
	local greenPaddleTop = display.newImageRect(mainGroup, "sprites/greenPaddle.png", 60, 60)
	local purplePaddleTop = display.newImageRect(mainGroup, "sprites/purplePaddle.png", 60, 60)
	local yellowPaddleTop = display.newImageRect(mainGroup, "sprites/yellowPaddle.png", 60, 60)

	-- Insert all paddles to an array to list through
	table.insert(potentialPaddlesTop, redPaddleTop)
	table.insert(potentialPaddlesTop, bluePaddleTop)
	table.insert(potentialPaddlesTop, greenPaddleTop)
	table.insert(potentialPaddlesTop, purplePaddleTop)
	table.insert(potentialPaddlesTop, yellowPaddleTop)

	-- Get number of paddles for looping purposes
	numPaddles = table.getn(potentialPaddlesTop)

	-- Copy the array of paddles across, so both players have the same options
	local redPaddleBot = display.newImageRect(mainGroup, "sprites/redPaddle.png", 60, 60)
	local bluePaddleBot = display.newImageRect(mainGroup, "sprites/bluePaddle.png", 60, 60)
	local greenPaddleBot = display.newImageRect(mainGroup, "sprites/greenPaddle.png", 60, 60)
	local purplePaddleBot = display.newImageRect(mainGroup, "sprites/purplePaddle.png", 60, 60)
	local yellowPaddleBot = display.newImageRect(mainGroup, "sprites/yellowPaddle.png", 60, 60)
	table.insert(potentialPaddlesBot, redPaddleBot)
	table.insert(potentialPaddlesBot, bluePaddleBot)
	table.insert(potentialPaddlesBot, greenPaddleBot)
	table.insert(potentialPaddlesBot, purplePaddleBot)
	table.insert(potentialPaddlesBot, yellowPaddleBot)

	-- Shift postions of each paddle for each player; should all remain layered on top of one another
	for i=1, numPaddles do
		potentialPaddlesTop[i].x = display.contentCenterX
		potentialPaddlesTop[i].y = display.contentCenterY - 50

		potentialPaddlesBot[i].x = display.contentCenterX
		potentialPaddlesBot[i].y = display.contentCenterY + 50
		
		-- Hide all options other than the first one
		if i ~= 1 then
			potentialPaddlesTop[i].isVisible = false
			potentialPaddlesBot[i].isVisible = false
		end
	end

	-- arrow button to change paddle preferences
	-- right bottom
	RBarrowButton = widget.newButton(
		{
			onPress = function() audio.play(buttonPress); bottomChoice = bottomChoice + 1; if bottomChoice > numPaddles then bottomChoice = numPaddles end end,
			onRelease = function() audio.play(buttonRelease) end,
			width = 34 * 2,
			height = 18 * 2,
			defaultFile = "sprites/rightArrow.png",
			overFile = "sprites/rightArrowPressed.png",
		}
	)
	uiGroup:insert(RBarrowButton)
	RBarrowButton.x = display.contentCenterX + 72
	RBarrowButton.y = display.contentCenterY + 52 	-- 52 aligns to middle of paddle 

	-- left bottom
	LBarrowButton = widget.newButton(
		{
			onPress = function() audio.play(buttonPress); bottomChoice = bottomChoice - 1; if bottomChoice<1 then bottomChoice = 1 end end,
			onRelease = function() audio.play(buttonRelease) end,
			width = 34 * 2,
			height = 18 * 2,
			defaultFile = "sprites/leftArrow.png",
			overFile = "sprites/leftArrowPressed.png",
		}
	)
	uiGroup:insert(LBarrowButton)
	LBarrowButton.x = display.contentCenterX - 70	-- 2 less to account for shadow
	LBarrowButton.y = display.contentCenterY + 52	-- 52 aligns to middle of paddle 

	-- right top
	RTarrowButton = widget.newButton(
		{
			onPress = function() audio.play(buttonPress); topChoice = topChoice + 1; if topChoice>numPaddles then topChoice = numPaddles end end,
			onRelease = function() audio.play(buttonRelease) end,
			width = 34 * 2,
			height = 18 * 2,
			defaultFile = "sprites/rightArrow.png",
			overFile = "sprites/rightArrowPressed.png",
		}
	)
	uiGroup:insert(RTarrowButton)
	RTarrowButton.x = display.contentCenterX + 72 -- 20px in from edge of device screen
	RTarrowButton.y = display.contentCenterY - 48	-- 48 aligns to middle of paddle 

	-- left top
	LTarrowButton = widget.newButton(
		{
			onPress = function() audio.play(buttonPress); topChoice = topChoice - 1; if topChoice<1 then topChoice = 1 end end,
			onRelease = function() audio.play(buttonRelease) end,
			width = 34 * 2,
			height = 18 * 2,
			defaultFile = "sprites/leftArrow.png",
			overFile = "sprites/leftArrowPressed.png",
		}
	)
	uiGroup:insert(LTarrowButton)
	LTarrowButton.x = display.contentCenterX - 70	-- 20px in from edge of device screen
	LTarrowButton.y = display.contentCenterY - 48	-- 48 aligns to middle of paddle 

	-- Adds big play button 
	goButton = widget.newButton(
		{
			onEvent = goToGame,
			width = 41 * 2,
			height = 43 * 2,
			defaultFile = "sprites/go.png",
			overFile = "sprites/pressedGo.png",
		}
	)
	uiGroup:insert(goButton)
	goButton.x = display.contentCenterX + 2	-- +2 to account for shadow
	goButton.y = display.actualContentHeight - 75

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
		gameLoopTimer = timer.performWithDelay(100, sceneLoop, 0)
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		audio.play(buttonSound)
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
