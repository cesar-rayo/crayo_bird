PipePair = Class{}

function PipePair:init(y)
    self.x = VIRTUAL_WIDTH
    self.y = y

    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + PIPES_GAP_SIZE)
    }

    -- flag used for remove pipes from array
    self.remove = false

    -- whether or not this pair of pipes has been scored
    self.scored = false
end

function PipePair:update(dt)
    -- if not visible then delete
    if self.x < -PIPE_WIDTH then
        self.remove = true
    else
        self.x = self.x - PIPE_SPEED * dt
        self.pipes['lower'].x = self.x
        self.pipes['upper'].x = self.x
    end
end

function PipePair:render()
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
end