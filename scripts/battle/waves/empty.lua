local Empty, super = Class(Wave)

function Empty:onStart()
    super.init(self)

    self.time = 0
end

return Empty