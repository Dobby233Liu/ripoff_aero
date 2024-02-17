local Empty, super = Class(Wave)

function Empty:onStart()
    super.init(self)

    self.time = 1
end

return Empty