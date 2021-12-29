local M = Util.create_class()

function M:_init(obj_cfg)
    self.cfg = obj_cfg

    local obj = SceneMgr:load_obj(obj_cfg.res_path, self)

    self.name = obj_cfg.name or "No Name Obj"
    obj.name = self.name
    self.transform = obj.transform
    self.gameobj = obj

    self.transform.position = {x = 0, y =  0, z = -1}
    self.components = {}
end

function M:on_update(dt)
    for _, component in pairs(self.components) do
        if component.on_update then
            component:on_update(dt)
        end
    end
end

function M:on_fixed_update()
    for _, component in pairs(self.components) do
        if component.on_fixed_update then
            component:on_fixed_update()
        end
    end
end

function M:add_component(class, name, ...)
    local component = class:new(self, ...)
    self.components[name] = component
    self[name] = component
end

function M:on_destory()
    for name, component in pairs(self.components) do
        if component.on_destory then
            component:on_destory() 
        end
        self[name] = nil
        self.components[name] = nil
    end

    UnityGameObject.Destroy(self.gameobj)
    self.transform = nil
end

function M:set_pos(x, y)
    self.transform.position = {x = x, y = y}
end

function M:get_pos2()
    local pos = self.transform.position
    return pos.x, pos.y
end

return M