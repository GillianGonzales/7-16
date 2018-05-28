-----------------------------------------------------------------------------------------
--
-- scene1.lua
--
-- Created By Gillian Gonzales	
-- Created On May 15 2018
--
-- This file will show a level
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local physics = require( "physics" )
local json = require( "json" )
local tiled = require ( "com.ponywolf.ponytiled")

local scene = composer.newScene()

local ninjaBoy = nil
local map = nil
local rightArrow = nil
local jumpButton = nil

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function onRightArrowTouch( event )
    if (event.phase == "began") then
        if ninjaBoy.sequence ~= "run" then
            ninjaBoy.sequence = "run"
            ninjaBoy:setSequence ( "run" )
            ninjaBoy:play()
        end

    elseif (event.phase == "ended") then
        if ninjaBoy.sequence ~= "idle" then
            ninjaBoy.sequence = "idle"
            ninjaBoy:setSequence( "idle" )
            ninjaBoy:play()
        end
    end
    return true
end

local function onJumpButtonTouch( event )
    if (event.phase == "began") then
        if ninjaBoy.sequence ~= "jump" then
            ninjaBoy.sequence = "jump"
            ninjaBoy:setSequence ( "jump" )
            ninjaBoy:play()
        end

    elseif (event.phase == "ended") then

    end
    return true
end

local moveNinjaBoyRun = function ( event )

    if ninjaBoy.sequence == "run" then
        transition.moveBy(ninjaBoy, {
            x = 10,
            y = 0,
            time = 0,
            })
    end
end

local moveNinjaBoyJump = function ( event )

    if ninjaBoy.sequence == "jump" then
        ninjaBoy:setLinearVelocity( 0, -750 )
    end
end


 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
	physics.start()
	physics.setGravity(0, 50)

    local filename = "assets/maps/level0.json"
    local mapData = json.decodeFile( system.pathForFile( filename, system.ResourceDirectory ))
    map = tiled.new( mapData, "assets/maps")
    
    local sheetOptionsIdle = require("assets.spritesheets.ninjaBoy.ninjaBoyIdle")
    local sheetIdleNinja = graphics.newImageSheet("./assets/spritesheets/ninjaBoy/ninjaBoyIdle.png", sheetOptionsIdle:getSheet() )

    local sheetOptionsRun = require("assets.spritesheets.ninjaBoy.ninjaBoyRun")
    local sheetRunNinja = graphics.newImageSheet("./assets/spritesheets/ninjaBoy/ninjaBoyRun.png", sheetOptionsRun:getSheet() )

    local sheetOptionsJump = require("assets.spritesheets.ninjaBoy.ninjaBoyJump")
    local sheetJumpNinja = graphics.newImageSheet("./assets/spritesheets/ninjaBoy/ninjaBoyJump.png", sheetOptionsJump:getSheet() )

    local sheetOptionsThrow = require("assets.spritesheets.ninjaBoy.ninjaBoyThrow")
    local sheetThrowNinja = graphics.newImageSheet("./assets/spritesheets/ninjaBoy/ninjaBoyThrow.png", sheetOptionsThrow:getSheet() )

    local sheetOptionsDead = require("assets.spritesheets.ninjaBoy.ninjaBoyDead")
    local sheetDeadNinja = graphics.newImageSheet("./assets/spritesheets/ninjaBoy/ninjaBoyDead.png", sheetOptionsDead:getSheet() )

    local sequence_data = {
        {
            name = "idle",
            start = 1,
            count = 10,
            time = 800,
            loopCount = 0,
            sheet = sheetIdleNinja
        },
        {
            name = "run",
            start = 1,
            count = 10,
            time = 800,
            loopCount = 0,
            sheet = sheetRunNinja
        },
        {
            name = "jump",
            start = 1,
            count = 10,
            time = 800,
            loopCount = 0,
            sheet = sheetJumpNinja
        },
        {
            name = "throw",
            start = 1,
            count = 10,
            time = 800,
            loopCount = 1,
            sheet = sheetThrowNinja
        },
        {
            name = "dead",
            start = 1,
            count = 10,
            time = 800,
            loopCount = 1,
            sheet = sheetDeadNinja        
    }
    }

    ninjaBoy = display.newSprite( sheetIdleNinja, sequence_data)
    physics.addBody( ninjaBoy, "dynamic", { density = 3, bounce = 0, friction = 1.0 })
    ninjaBoy.isFixedRotation = true
    ninjaBoy.x = display.contentWidth * .5
    ninjaBoy.y = 0 
    ninjaBoy.sequence = "idle"
    ninjaBoy:setSequence("idle")
    ninjaBoy:play()

    rightArrow = display.newImageRect("./assets/sprites/rightButton.png",200,200 )
    rightArrow.x = 200
    rightArrow.y = display.contentHeight - 300

    jumpButton = display.newImageRect("./assets/sprites/jumpButton.png",128,128 )
    jumpButton.x = 400
    jumpButton.y = display.contentHeight - 300

    sceneGroup:insert( map )
    sceneGroup:insert( ninjaBoy ) 
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        sceneGroup:insert( rightArrow )
        sceneGroup:insert( jumpButton )
        rightArrow:addEventListener("touch",onRightArrowTouch)
        jumpButton:addEventListener("touch",onJumpButtonTouch)
        jumpButton:addEventListener("touch",moveNinjaBoyJump)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        Runtime:addEventListener("enterFrame",moveNinjaBoyRun) 
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
        rightArrow:addEventListener("touch",onRightArrowTouch)
        Runtime:addEventListener("enterFrame",moveNinjaBoyRun)
        jumpButton:addEventListener("touch",onJumpButtonTouch)
        jumpButton:addEventListener("touch",moveNinjaBoyJump)
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