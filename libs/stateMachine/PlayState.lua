PlayState = Class{__includes = BaseState}

PIPE_SPEED = 120
PIPE_HEIGHT = 288
PIPE_WIDTH = 70

-- initialize gap size
PIPES_GAP_SIZE = 120

function PlayState:init()
	-- declare Bird object
    self.bird = Bird()
    -- array with pipelines
    self.pipePairs = {}
    -- our timer for spawning pipes
    self.spawnTimer = 0

    -- now keep track of our score
    self.score = 0

    -- initialize our last recorded Y value for a gap placement to base other gaps off of
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
	self.spawnTimer = self.spawnTimer + dt
	
	self.bird:update(dt)

	if self.spawnTimer > 1.2 then
            
        local lowest_y = VIRTUAL_HEIGHT - PIPES_GAP_SIZE - PIPE_HEIGHT
        local highest_y = -PIPE_HEIGHT + 10
        -- lastY + math.random(-20, 20) random gap
        -- max(pipe_height+10, min(lasY+/-20, height-pipe-gap))
        local y = math.max(highest_y, math.min(self.lastY + math.random(-20, 20), lowest_y))
        self.lastY = y
        
        table.insert(self.pipePairs, PipePair(y))

        -- print in console
        --print('Added new pipe!')
        
        -- reset timer
        self.spawnTimer = 0
    end

    for k, pair in pairs(self.pipePairs) do
    	-- calculate score
    	if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                pair.scored = true
                sounds['score']:play()
            end
        end
        
        pair:update(dt)

        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                sounds['explosion']:play()
                sounds['hurt']:play()
            	-- show score
                gStateMachine:change('score', {
                    score = self.score
                })
            end
        end

        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end
end

function PlayState:render()
	for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    self.bird:render()
end

function PlayState:enter()
    scrolling = true
end

function PlayState:exit()
    -- stop scrolling
    scrolling = false
end