local M = Util.create_class()
local IDX = 0
function M.get_idx()
    IDX = IDX + 1
    return IDX
end

function M:_init()
    self.effects = {}
end 

function M:show_effect(path, x, y)
    local res = Util.load_prefab(path)
    if not res then
        Log.Error("资源不存在" .. res)
        return 
    end
    local obj = UnityGameObject.Instantiate(res)
    Util.set_pos(obj, x, y)
    local effect = {gameobj = obj, live_time = 0}
    self.effects[M.get_idx()] = effect
end

function M:on_update(dt)
    for key, effect in pairs(self.effects) do
        effect.live_time = effect.live_time + dt
        if effect.live_time > 1 then
            self:stop_effect(effect, key)
        end
    end
end

function M:stop_effect(effect, idx)
    self.effects[idx] = nil
    UnityGameObject.Destroy(effect.gameobj)
end

return M