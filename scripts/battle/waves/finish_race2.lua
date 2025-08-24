local finish_race, super = Class("finish_race")

function finish_race:init()
    super.init(self)

    self.target_time = 0.5
end

return finish_race