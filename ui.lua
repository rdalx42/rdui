-- ui.lua

local UI = {}

UI.frames = {}

function UI.isMouseOverUI(mx, my)
    for _, frame in ipairs(UI.frames) do
        if frame.visible then
            for _, el in ipairs(frame.elements) do
                if el.type == "button" then
                    if mx >= el.x and mx <= el.x + el.width and
                       my >= el.y and my <= el.y + el.height then
                        return true
                    end
                end
            end
        end
    end
    return false
end

function UI.newFrame(name, x, y, width, height)
    local frame = {
        name = name,
        x = x,
        y = y,
        width = width,
        height = height,
        visible = true,
        elements = {},
        type = "frame",
    }

    function frame:addButton(text, bx, by, bw, bh, onClick)
        table.insert(self.elements, {
            type = "button",
            text = text,
            x = self.x + bx,
            y = self.y + by,
            width = bw,
            height = bh,
            onClick = onClick,
            hovered = false
        })
    end

    function frame:show() self.visible = true end
    function frame:hide() self.visible = false end
    function frame:toggle() self.visible = not self.visible end

    function frame:update(mx, my)
        for _, el in ipairs(self.elements) do
            if el.type == "button" then
                el.hovered = mx >= el.x and mx <= el.x + el.width and
                             my >= el.y and my <= el.y + el.height
            end
        end
    end

    function frame:draw()
        love.graphics.setColor(0.1, 0.1, 0.1, 0.8)
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

        for _, el in ipairs(self.elements) do
            if el.type == "button" then
                if el.hovered then
                    love.graphics.setColor(0.7, 0.7, 1)
                else
                    love.graphics.setColor(0.4, 0.4, 0.8)
                end
                love.graphics.rectangle("fill", el.x, el.y, el.width, el.height)
                love.graphics.setColor(1, 1, 1)
                love.graphics.printf(el.text, el.x, el.y + el.height / 2 - 7, el.width, "center")
            end
        end
    end

    table.insert(UI.frames, frame)
    return frame
end

function UI.update(dt)
    local mx, my = love.mouse.getPosition()
    for _, frame in ipairs(UI.frames) do
        if frame.visible then
            frame:update(mx, my)
        end
    end
end

function UI.draw()
    for _, frame in ipairs(UI.frames) do
        if frame.visible then
            frame:draw()
        end
    end
end

function UI.mousepressed(x, y, button)
    if button ~= 1 then return end

    for _, frame in ipairs(UI.frames) do
        if frame.visible then
            for _, el in ipairs(frame.elements) do
                if el.type == "button" and el.hovered and el.onClick then
                    el.onClick()
                end
            end
        end
    end
end

return UI
