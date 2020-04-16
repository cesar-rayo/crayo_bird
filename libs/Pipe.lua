Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('/images/pipe.png')
local PIPE_SCROLL = -60

function Pipe:init(orientation, y)
    -- at the very right of the screen
    self.x = VIRTUAL_WIDTH
    self.y = y
    self.width = PIPE_IMAGE:getWidth()
    self.orientation = orientation
end

function Pipe:update(dt)
    --self.x = self.x + PIPE_SCROLL * dt
end

function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, self.x, self.y)
    love.graphics.draw(PIPE_IMAGE, self.x, 
        -- self.orientation == 'top ? self.y + PIPE_HEIGHT : self.y
        (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y), 
        0, -- rotation
        1, -- scale in X
        -- self.orientation == 'top ? -1 : 1
        self.orientation == 'top' and -1 or 1) -- sale in Y
end