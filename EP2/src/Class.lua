return function(...)
    local cls, bases = {}, {...}

    for _, base in ipairs(bases) do
        for k, v in pairs(base) do
            cls[k] = v
        end
    end

    cls.__index, cls.is_a = cls, {[cls] = true}

    for _, base in ipairs(bases) do
        for c in pairs(base.is_a) do
            cls.is_a[c] = true
        end
        cls.is_a[base] = true
    end

    setmetatable(cls, {__call = function(c, ...)
        local instance = setmetatable({}, c)
        local init = instance._init
        if init then init(instance, ...) end
        return instance
    end})

    return cls
end
