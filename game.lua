
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local puck
-- Load in selected paddles from the selection screen
local topPaddle = composer.getVariable("topSelectedPaddle")
local botPaddle = composer.getVariable("botSelectedPaddle")

-- Init. physics engine
local physics = require("physics")
physics.start()
physics.setGravity(0,0)

-- Allows for the dragging of paddles on screen -> credit to someone one forum
local function dragger( self, event )
		local phase = event.phase
		local id 	= event.id
		if( phase == "began" ) then
			self.isFocus = true
			self.tempJoint = physics.newJoint( "touch", self, self.x, self.y )
			self.tempJoint.maxForce = 1e6
			self.tempJoint.dampingRatio = 0
			self.tempJoint.frequency = 2000
			display.currentStage:setFocus( self, id )
		elseif( self.isFocus ) then
			self.tempJoint:setTarget( event.x, event.y )
			if( phase == "ended" or phase == "cancelled" ) then
				self.isFocus = false
				display.currentStage:setFocus( self, nil )
				display.remove( self.tempJoint ) 
			end	
		end
		return false
end

-- Caculate x,y edges of bounds

local paddleRadius = 30
local minYTop = 0
local maxYTop = 240
local minYBot = maxYTop
local maxYBot = 480
local minX = 0
local maxX = display.actualContentWidth + display.screenOriginX

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

	-- Place paddles in their starting positions with physics added
	mainGroup:insert(topPaddle)
	topPaddle.x = display.contentCenterX
	topPaddle.y = display.contentCenterY - 100
	physics.addBody(topPaddle, "dynamic", {radius=30})
	topPaddle.touch = dragger
	topPaddle:addEventListener("touch")	

	mainGroup:insert(botPaddle)
	botPaddle.x = display.contentCenterX
	botPaddle.y = display.contentCenterY + 100
	physics.addBody(botPaddle, "dynamic", {radius=30})
	botPaddle.touch = dragger
	botPaddle:addEventListener("touch")	

	-- Load in puck with physics and correct position
	puck = display.newImageRect(mainGroup, "sprites/puck.png", 160/4, 160/4)
	puck.x = display.contentCenterX
	puck.y = display.contentCenterY
	physics.addBody(puck, "dynamic", {radius=20})
	puck.linearDamping = 1.1
	puck.isBullet = true

	-- Add in bounding walls
	local left = display.newImageRect(mainGroup,"sprites/greyWall.png", 10,600)
	left.x = display.screenOriginX 
	left.y = 240
	physics.addBody(left, "static")

	local right = display.newImageRect(mainGroup,"sprites/greyWall.png", 10,600)
	right.x = display.screenOriginX + display.actualContentWidth
	right.y = 240
	physics.addBody(right, "static")

	local top = display.newImageRect(mainGroup,"sprites/greyWall.png", 10,600)
	top:rotate(90)
	top.x = display.screenOriginX
	top.y = display.screenOriginY
	physics.addBody(top, "static")
	
	local bot = display.newImageRect(mainGroup,"sprites/greyWall.png", 10,600)
	bot:rotate(90)
	bot.x = display.screenOriginX
	bot.y = display.screenOriginY + display.actualContentHeight
	physics.addBody(bot, "static")

	-- Middle line
	local mid = display.newImageRect(backGroup,"sprites/greyWall.png", 10,600);
	mid:rotate(90)
	mid.x = display.screenOriginX;
	mid.y = display.contentCenterY;
	mid.alpha = 0.3

	-- Add and enterFrame Listener to help limit movement
	function topPaddle.enterFrame( self )
		if (self.y < minYTop) then self.y = minYTop end
		if (self.y > maxYTop) then self.y = maxYTop end
		if (self.x < minX + paddleRadius) then self.x = minX end
		if (self.x > maxX - paddleRadius) then self.x = maxX end
	end

	function botPaddle.enterFrame(self)
		if (self.y > maxYBot) then self.y = maxYBot end
		if (self.y < minYBot) then self.y = minYBot end
		if (self.x < minX + paddleRadius) then self.x = minX end
		if (self.x > maxX - paddleRadius) then self.x = maxX end
	end


end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		Runtime:addEventListener("enterFrame", topPaddle)
		Runtime:addEventListener("enterFrame", botPaddle)
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

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
