push = require './libs/push'
Class = require './libs/class'

require './libs/Bird'
require './libs/Pipe'
require './libs/PipePair'
require './libs/stateMachine/StateMachine'
require './libs/stateMachine/BaseState'
require './libs/stateMachine/TitleState'
require './libs/stateMachine/PlayState'
require './libs/stateMachine/ScoreState'

-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- images we load into memory from files to later draw onto the screen
local background = love.graphics.newImage('/images/background.png')
local backgroundScroll = 0 --initial point in X axis

local ground = love.graphics.newImage('/images/ground.png')
local groundScroll = 0

-- speed for scrolling images
local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 120

-- point at which we should loop our background back to X 0
local BACKGROUND_LOOPING_POINT = 413

-- flag to pause the game
local scrolling = true

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Crayo Bird')

    -- set fonts
    smallFont = love.graphics.newFont('/fonts/font.ttf', 8)
    mediumFont = love.graphics.newFont('/fonts/flappy.ttf', 14)
    flappyFont = love.graphics.newFont('/fonts/flappy.ttf', 28)
    hugeFont = love.graphics.newFont('/fonts/flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    -- seed randoom object
    math.randomseed(os.time())

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- initialize state machine with all state-returning functions
    gStateMachine = StateMachine {
        ['title'] = function() return TitleState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end,
    }
    gStateMachine:change('title')

    -- initialize new element keysPressed
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    -- New custom element keysPressed in love.keyboard table
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

-- custom function to detect if given key was pressed
function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.update(dt)
    -- scroll background by preset speed * dt, looping back to 0 after the looping point
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) 
        % BACKGROUND_LOOPING_POINT

    -- scroll ground by preset speed * dt, looping back to 0 after the screen width passes
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) 
        % VIRTUAL_WIDTH

    -- now, we just update the state machine, which defers to the right state
    gStateMachine:update(dt)

    -- clear new element
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    
    -- draw the background starting at top left (0, 0)
    love.graphics.draw(background, -backgroundScroll, 0)

    -- render from state
    gStateMachine:render()

    -- draw the ground on top of the background, toward the bottom of the screen
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
    
    push:finish()
end