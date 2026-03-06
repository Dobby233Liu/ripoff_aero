---@class SwapInside : Event
local SwapInside, super = Class("Event")

function SwapInside:init(data)
    super.init(self, data)
    self:setSprite("kristal/banana_1")
end

function SwapInside:onCollide(player)
    if Input.pressed("SC") and #Game.party > 1 then
        local old_party_ord = {}
        for _, party in ipairs(Game.party) do
            table.insert(old_party_ord, party.id)
        end

        Game:movePartyMember(Game.party[1], #Game.party)

        local charas = { Game.world.player, unpack(Game.world.followers) }
        for _, chara in ipairs(charas) do
            if chara.party then
                local ndx = TableUtils.getIndex(old_party_ord, chara.party)
                if ndx ~= nil then
                    old_party_ord[ndx] = false
                    chara.party = Game.party[ndx].id
                    chara:setActor(Game.party[ndx].actor.id)
                end
            end
        end
    end
end

return SwapInside
