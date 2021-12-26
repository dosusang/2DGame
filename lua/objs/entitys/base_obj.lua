local M = Util.create_class()

function M:_init(name, obj)
    self.name = name
    self.transform = obj.transform
    self.gameobj = obj

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

function M:add_component(path, name, ...)
    local component = require(path):new(self, ...)
    self.components[name] = component
    self[name] = component
end

function M:on_destory()
    for name, component in pairs(self.components) do
        component:on_destory()
        self[name] = nil
        self.components[name] = nil
    end

    self.transform = nil
end

return M